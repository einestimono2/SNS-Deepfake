import dayjs from 'dayjs';
import sequelize, { Op } from 'sequelize';

import { Block } from '../block/block.model.js';
import { Comment } from '../comment/comment.model.js';
import { BadRequestError } from '../core/error.response.js';
import { Group } from '../group/group/group.model.js';
import { GroupUser } from '../group/groupuser.model.js';
import { User } from '../user/user.model.js';

import { Feel } from './models/feel.model.js';
import { Mark } from './models/mark.model.js';
import { PostImage } from './models/post_image.model.js';
import { PostVideo } from './models/post_video.model.js';
import { PostView } from './models/post_view.model.js';
import { Report } from './models/report.model.js';
import { Post } from './post.model.js';

import { Message, costs } from '#constants';
import { deleteFile, getBanned, getCanEdit, getCanMark, getCanRate, setFileUsed } from '#utils';

export class PostServices {
  // Tất cả đều chưa xử lý và notification
  // Thêm mới một bài viết vào 1 nhóm (Đã test)
  static async addPost(userId, body) {
    const { groupId, description, status, images, videos } = { ...body };
    if (groupId === undefined || !userId) throw new BadRequestError(Message.ID_EMPTY);

    const user = await User.findByPk(userId);

    // Kiểm tra số coins của user
    if (user.coins < costs.createPost) {
      throw new BadRequestError(Message.NO_ENOUGH_COINS);
    }
    const post = await Post.create({
      authorId: userId,
      description,
      status,
      groupId: groupId === 0 ? null : groupId
    });

    // Lưu dữ liệu vào bảng postvideo và postimage
    let postVideos = [];
    if (videos?.length) {
      const videoPromises = videos.map((video, i) => {
        const fileVideoUsed = setFileUsed(video);
        return PostVideo.create({
          postId: post.id,
          url: fileVideoUsed
        });
      });

      postVideos = await Promise.all(videoPromises);
    }

    let postImages = [];
    if (images?.length) {
      const imagePromises = images.map((image, i) => {
        const fileImageUsed = setFileUsed(image);
        return PostImage.create({
          postId: post.id,
          url: fileImageUsed,
          order: i + 1
        });
      });

      postImages = await Promise.all(imagePromises);
    }

    // Cập nhật số coins
    user.coins -= costs.createPost;
    user.lastActive = new Date();
    await user.save();
    await post.save();
    // await NotificationServices.notifyAddPost({ post, author: user });
    // Thong bao
    return {
      post: {
        ...post.dataValues,
        author: user,
        videos: postVideos,
        images: postImages
      },
      coins: String(user.coins)
    };
  }

  // Lấy thông tin 1 bài viết ()
  static async detailsPost(userId, postId) {
    if (!postId || !userId) throw new BadRequestError(Message.ID_EMPTY);
    const user = await User.findOne({
      where: {
        id: userId
      }
    });
    const postTotal = await Post.findOne(
      {
        where: {
          id: postId
          // [Op.and]: [{ id: postId }, { groupId }]
        },
        include: [
          {
            model: User,
            as: 'author',
            attributes: ['id', 'avatar', 'username', 'email', 'phoneNumber']
            // where: { author, blocked: null },
          },
          {
            model: PostImage,
            as: 'images',
            order: [['order', 'ASC']]
          },
          {
            model: PostVideo,
            as: 'videos'
          },
          {
            model: Feel,
            as: 'feels',
            where: { userId },
            required: false
          },
          {
            model: Mark,
            as: 'marks',
            where: { userId },
            required: false
          }
        ],
        attributes: [
          // include: [
          [
            sequelize.literal(
              '(SELECT COUNT(*) FROM "Feels" WHERE "Feels"."postId" = "Post"."id" AND "Feels"."type" = 0)'
            ),
            'kudosCount'
          ],
          [
            sequelize.literal(
              '(SELECT COUNT(*) FROM "Feels" WHERE "Feels"."postId" = "Post"."id" AND "Feels"."type" = 1)'
            ),
            'disappointedCount'
          ],
          [
            sequelize.literal(
              '(SELECT COUNT(*) FROM "Marks" WHERE "Marks"."postId" = "Post"."id" AND "Marks"."type" = 0)'
            ),
            'trustCount'
          ],
          [
            sequelize.literal(
              '(SELECT COUNT(*) FROM "Marks" WHERE "Marks"."postId" = "Post"."id" AND "Marks"."type" = 1)'
            ),
            'fakeCount'
          ]
        ]
      }
      // group: ['Post.id', 'author.id', 'images.id', 'videos.id', 'feels.id', 'marks.id', 'histories.id']
    );
    if (!postTotal) {
      throw new BadRequestError(Message.POST_NOT_FOUND);
    }
    const post = postTotal.toJSON();
    return {
      post,
      can_edit: getCanEdit(post, user),
      // banned: getBanned(post),
      can_mark: getCanMark(post, user),
      // can_rate: getCanRate(post, user),
      deleted: post.deletedAt ? post.deletedAt : undefined
    };
  }

  // Lấy danh sách các bài viết của 1 nhóm(đã test)
  static async getListPosts({ userId, limit, offset }, groupId, user_id) {
    if (!userId || !groupId) throw new BadRequestError(Message.ID_EMPTY);
    const user = await User.findOne({ where: { id: userId } });

    // Danh sach các userId của người mà block mình
    const usersIdBlocked = await Block.findAll({
      where: { userId },
      attributes: ['targetId']
    });

    const userGroups = await GroupUser.findAll({
      where: { userId },
      attributes: ['groupId']
    });

    const groupIds = userGroups.map((group) => group.groupId);
    // const postCount = await Post.findAndCountAll({
    //   where: {
    //     groupId
    //   }
    // });

    // Danh sach các userId của người mà bị mình block
    const usersIdBlocking = await Block.findAll({
      where: { targetId: userId },
      attributes: ['userId']
    });

    const query = {
      where: {
        [Op.or]: [{ groupId: { [Op.in]: groupIds } }, { groupId: { [Op.eq]: null } }]
      },
      include: [
        {
          model: User,
          as: 'author',
          attributes: ['id', 'avatar', 'username', 'email', 'phoneNumber'],
          required: false,
          where: {
            id: {
              // [Op.notIn]: usersIdBlocked.targetId
              [Op.notIn]: [
                ...usersIdBlocked.map((block) => block.targetId),
                ...usersIdBlocking.map((block) => block.userId)
              ]
            }
          }
        },
        {
          model: PostImage,
          as: 'images',
          order: [['order', 'ASC']],
          required: false
        },
        {
          model: PostVideo,
          as: 'videos'
        },
        {
          model: Group,
          as: 'group',
          attributes: ['id', 'groupName', 'description', 'coverPhoto'],
          required: false
        },
        {
          model: Feel,
          as: 'feels',
          where: { userId },
          required: false
        }
        // ,
        // {
        //   model: Mark,
        //   as: 'marks',
        //   where: { userId },
        //   required: false
        // }
      ],
      attributes: [
        'id',
        'authorId',
        'description',
        'status',
        'edited',
        'categoryId',
        'rate',
        'createdAt',
        [
          sequelize.literal(
            '(SELECT COUNT(*) FROM "Feels" WHERE "Feels"."postId" = "Post"."id" AND "Feels"."type" = 0)'
          ),
          'kudosCount'
        ],
        [
          sequelize.literal(
            '(SELECT COUNT(*) FROM "Feels" WHERE "Feels"."postId" = "Post"."id" AND "Feels"."type" = 1)'
          ),
          'disappointedCount'
        ],
        [
          sequelize.literal(
            '(SELECT COUNT(*) FROM "Marks" WHERE "Marks"."postId" = "Post"."id" AND "Marks"."type" = 0)'
          ),
          'trustCount'
        ],
        [
          sequelize.literal(
            '(SELECT COUNT(*) FROM "Marks" WHERE "Marks"."postId" = "Post"."id" AND "Marks"."type" = 1)'
          ),
          'fakeCount'
        ]
      ],
      order: [['id', 'DESC']],
      distinct: true,
      subQuery: false,
      offset,
      limit
    };

    if (groupId && Number(groupId) > 0) {
      query.where = {
        groupId
      };
    }

    if (user_id && Number(user_id) > 0) {
      query.where = {
        authorId: user_id
      };
    }

    const postTotal = await Post.findAndCountAll(query);
    return {
      rows: postTotal.rows.map((post) => ({
        post,
        can_edit: getCanEdit(post, user)
        // banned: getBanned(post)
      })),
      count: postTotal.count
    };
  }

  // Chỉnh sửa một bài viết(đã test)
  static async editPost(userId, postId, body) {
    const user = await User.findOne({
      where: { id: userId }
    });
    const post = await Post.findOne({
      where: { id: postId, authorId: userId },
      // Lấy  những ảnh tương ứng được sắp xếp và chỉ lấy ra 2 thuộc tính url và order
      include: [
        { model: PostImage, as: 'images', order: [['order', 'ASC']] },
        { model: PostVideo, as: 'videos' },
        { model: Mark, as: 'marks', include: [{ model: Comment, as: 'comments' }] },
        { model: Feel, as: 'feels' }
      ]
    });
    if (!post) {
      throw new BadRequestError(Message.POST_NOT_FOUND);
    }
    // Kiểm tra thời gian tạo post phải >= 5phut
    if (dayjs(post.createdAt).add(5, 'minutes').isBefore(dayjs())) {
      if (user.coins < costs.editPost) {
        throw new BadRequestError(Message.NO_ENOUGH_COINS);
      }
      user.coins -= costs.editPost;
      await user.save();
    }
    // Thêm mới ảnh
    if (body.images) {
      let curentOrder = post.images.length;
      for (const image of body.images) {
        curentOrder += 1;
        post.images.push(await PostImage.create({ postId: post.id, url: setFileUsed(image), order: curentOrder }));
      }
    }
    const mapImages = Object.fromEntries(post.images.map((e) => [e.order, e]));
    // Sắp xếp lại thứ tự ảnh nếu cần
    if (body.image_sort) {
      const newOrderImages = [];
      for (const order of body.image_sort) {
        if (mapImages[order]) {
          newOrderImages.push(mapImages[order]);
        }
      }
      post.images = newOrderImages;
    }
    // Xóa ảnh nếu cần
    if (body.image_del) {
      const deleted = Object.fromEntries(body.image_del.map((e) => [e, true]));
      console.log(deleted);
      const imagesToDelete = post.images.filter((image) => deleted[image.order]);

      // Xóa ảnh từ cơ sở dữ liệu
      for (const image of imagesToDelete) {
        await PostImage.destroy({ where: { id: image.id } });
        deleteFile(image.url);
      }
      // Cập nhật danh sách ảnh trong post
      post.images = post.images.filter((image) => !deleted[image.order]);
      for (let i = 0; i < post.images.length; i++) {
        post.images[i].order = i + 1;
        await post.images[i].save();
      }
    }
    if (body.description !== undefined && body.description !== null) {
      post.description = body.description;
    }
    if (body.status !== undefined && body.status !== null) {
      post.status = body.status;
    }
    if (body.groupId !== undefined && body.groupId !== null) {
      post.groupId = body.groupId;
    }
    // Xử lý video
    if (body.video) {
      if (post.video) {
        post.video.url = body.video;
      } else {
        post.video = await PostVideo.create({ postId, url: setFileUsed(body.video) });
      }
    }

    await post.save();
    // await NotificationServices.notifyEditPost({ post, author: user });
    return {
      id: post.id,
      coins: String(user.coins),
      images: post.images
    };
  }

  // Xóa một bài viết(Đã test)
  static async deletePost(userId, postId) {
    const user = await User.findOne({
      where: { id: userId }
    });

    const post = await Post.findOne({
      where: { id: postId, authorId: userId }
    });
    if (!post) {
      throw new BadRequestError(Message.POST_NOT_FOUND);
    }
    if (post.histories.length > 0) {
      await Post.destroy({
        where: { id: post.histories.map((history) => history.oldPostId) }
      });
    }
    await post.destroy();
    user.coins -= costs.deletePost;
    await user.save();

    return { coins: String(user.coins) };
  }

  // Report một bài viết(đã test)
  static async reportPost(userId, postId, { ...reports }) {
    const post = await Post.findOne({ where: { id: postId } });
    if (!post) {
      throw new BadRequestError(Message.POST_NOT_FOUND);
    }
    const { subject, details } = { ...reports };
    if (!subject || !details) {
      throw new BadRequestError(Message.NO_ENOUGH_INFORMATION);
    }
    const report = await Report.create({
      postId,
      subject,
      details,
      userId
    });
    return { report };
  }

  // Lấy những bài viết mới(đã test)
  static async getNewPosts({ userId, limit, offset }) {
    const user = await User.findOne({
      where: { id: userId }
    });
    const usersIdBlocked = await Block.findAll({
      where: { userId },
      attributes: ['targetId']
    });
    // Danh sach các userId mà bị mình blocgettargetId
    const usersIdBlocking = await Block.findAll({
      where: { targetId: userId },
      attributes: ['userId']
    });
    console.log(1);
    const posts = await Post.findAndCountAll({
      include: [
        {
          model: User,
          as: 'author',
          attributes: ['id', 'avatar', 'username', 'email', 'phoneNumber'],
          where: {
            id: {
              // [Op.notIn]: usersIdBlocked.targetId
              [Op.notIn]: [
                ...usersIdBlocked.map((block) => block.targetId),
                ...usersIdBlocking.map((block) => block.userId)
              ]
            }
          }
        },
        { model: PostImage, as: 'images', order: [['order', 'ASC']] },
        { model: PostVideo, as: 'video' },
        { model: PostView, as: 'views' },
        { model: Feel, as: 'feels' },
        { model: Mark, as: 'marks' }
      ],
      order: [
        [sequelize.literal('(SELECT count FROM "PostViews" WHERE "PostViews"."postId" = "Post"."id")'), 'ASC'],
        ['id', 'DESC']
      ],
      distinct: true,
      subQuery: false,
      limit,
      offset
    });
    // console.log(posts);
    // for (const post of posts) {
    //   if (post.marks.length > 0) {
    //     const commentsCount = await Comment.count({ where: { markId: post.id } });
    //     post.commentsCount = commentsCount;
    //   } else {
    //     post.commentsCount = 0;
    //   }
    // }
    return {
      rows: posts.rows.map((post) => ({
        post,
        can_edit: getCanEdit(post, user),
        banned: getBanned(post)
      })),
      count: posts.count
    };
  }

  // Tăng số lượt xem bài viết()
  static async setViewedPost(userId, postId) {
    // Tìm postView dựa trên postId và userId
    const postView = await PostView.findOne({ where: { postId, userId } });

    // Nếu không tìm thấy, tạo mới một postView
    if (!postView) {
      await PostView.create({ postId, userId, count: 0 });
    }
    // Tăng giá trị count lên 1
    postView.count += 1;
    // Lưu hoặc cập nhật postView vào cơ sở dữ liệu
    await postView.save();
    // // Trả về số lượt xem
    return {
      viewed: String(postView.count)
    };
  }

  // Lấy các video trong nhóm
  static async getListVideos({ userId, limit, offset }, groupId) {
    // Danh sach các userId mà block mình
    const user = await User.findOne({
      where: {
        id: userId
      }
    });
    const usersIdBlocked = await Block.findAll({
      where: { userId },
      attributes: ['targetId']
    });
    const usersIdBlocking = await Block.findAll({
      where: { targetId: userId },
      attributes: ['userId']
    });
    const userGroups = await GroupUser.findAll({
      where: { userId },
      attributes: ['groupId']
    });

    const groupIds = userGroups.map((group) => group.groupId);
    const query = {
      where: {
        [Op.or]: [{ groupId: { [Op.in]: groupIds } }, { groupId: { [Op.eq]: null } }]
      },
      include: [
        {
          model: User,
          as: 'author',
          attributes: ['id', 'avatar', 'username', 'email', 'phoneNumber'],
          where: {
            id: {
              [Op.notIn]: [
                ...usersIdBlocked.map((block) => block.targetId),
                ...usersIdBlocking.map((block) => block.userId)
              ]
            }
          }
        },
        {
          model: PostVideo,
          as: 'videos',
          where: {
            // Thêm điều kiện để chỉ lấy các video không rỗng
            [Op.not]: { id: null }
          }
        },
        {
          model: Group,
          as: 'group',
          attributes: ['id', 'groupName', 'description', 'coverPhoto']
        },
        {
          model: Feel,
          as: 'feels',
          where: { userId },
          required: false
        }
        // ,
        // { model: Mark, as: 'marks' }
      ],
      attributes: [
        'id',
        'authorId',
        'description',
        'status',
        'edited',
        'categoryId',
        'rate',
        'createdAt',
        [
          sequelize.literal(
            '(SELECT COUNT(*) FROM "Feels" WHERE "Feels"."postId" = "Post"."id" AND "Feels"."type" = 0)'
          ),
          'kudosCount'
        ],
        [
          sequelize.literal(
            '(SELECT COUNT(*) FROM "Feels" WHERE "Feels"."postId" = "Post"."id" AND "Feels"."type" = 1)'
          ),
          'disappointedCount'
        ],
        [
          sequelize.literal(
            '(SELECT COUNT(*) FROM "Marks" WHERE "Marks"."postId" = "Post"."id" AND "Marks"."type" = 0)'
          ),
          'trustCount'
        ],
        [
          sequelize.literal(
            '(SELECT COUNT(*) FROM "Marks" WHERE "Marks"."postId" = "Post"."id" AND "Marks"."type" = 1)'
          ),
          'fakeCount'
        ]
      ],
      order: [['createdAt', 'DESC']],
      distinct: true,
      subQuery: false,
      offset,
      limit
    };

    if (Number(groupId) > 0) {
      query.where = {
        groupId
      };
    }

    const postTotal = await Post.findAndCountAll(query);

    return {
      rows: postTotal.rows.map((post) => ({
        post,
        can_edit: getCanEdit(post, user),
        banned: getBanned(post)
      })),
      count: postTotal.count
    };
  }

  // static async setSharededPost(userId, postId) {
  //   // Tìm postView dựa trên postId
  //   const post = await Post.findOne({ where: { postId } });

  //   // Tăng giá trị lượt sharecount lên 1
  //   post.shareCount += 1;
  //   // Lưu hoặc cập nhật postView vào cơ sở dữ liệu
  //   await post.save();
  //   return {
  //     viewed: String(post.shareCount)
  //   };
  // }

  // Chia sẻ bài viết vào 1 nhóm
  // static async sharePostToGroup(userId, body) {
  //   const { groupId, postId } = { ...body };
  //   if (!groupId || !userId) throw new BadRequestError(Message.ID_EMPTY);
  //   const user = await User.findOne({ where: { id: userId } });
  //   // Kiểm tra số coins của user
  //   if (user.coins < costs.sharePost) {
  //     throw new BadRequestError(Message.NO_ENOUGH_COINS);
  //   }
  //   const postToShare = await Post.findOne({
  //     where: { id: postId },
  //     include: [
  //       {
  //         model: User,
  //         as: 'author',
  //         attributes: ['id', 'avatar', 'username', 'email', 'phoneNumber']
  //       },
  //       { model: PostImage, as: 'images', order: [['order', 'ASC']] },
  //       { model: PostVideo, as: 'video' },
  //       { model: Feel, as: 'feels' },
  //       { model: Mark, as: 'marks' }
  //     ],
  //     attributes: {
  //       include: [
  //         [
  //           sequelize.literal(
  //             '(SELECT COUNT(*) FROM "Feels" WHERE "Feels"."postId" = "Post"."id" AND "Feels"."type" = 0)'
  //           ),
  //           'kudosCount'
  //         ],
  //         [
  //           sequelize.literal(
  //             '(SELECT COUNT(*) FROM "Feels" WHERE "Feels"."postId" = "Post"."id" AND "Feels"."type" = 1)'
  //           ),
  //           'disappointedCount'
  //         ],
  //         [
  //           sequelize.literal(
  //             '(SELECT COUNT(*) FROM "Marks" WHERE "Marks"."postId" = "Post"."id" AND "Marks"."type" = 0)'
  //           ),
  //           'trustCount'
  //         ],
  //         [
  //           sequelize.literal(
  //             '(SELECT COUNT(*) FROM "Marks" WHERE "Marks"."postId" = "Post"."id" AND "Marks"."type" = 1)'
  //           ),
  //           'fakeCount'
  //         ]
  //       ]
  //     }
  //   });
  //   const postShare = postToShare.toJSON();
  //   const postCreate = await Post.create({
  //     authorId: userId,
  //     description: body.description,
  //     status: body.status,
  //     groupId,
  //     postShareId: postId
  //   });

  //   // Lưu dữ liệu vào bảng postvideo và postimage
  //   if (postShare.video) {
  //     const fileVideoUsed = setFileUsed(postShare.video.url);
  //     await PostVideo.create({ postId: postCreate.id, url: fileVideoUsed });
  //   }
  //   // if (body.images?.length) {
  //   //   const imagePromises = images.map((image, i) => {
  //   //     const fileImageUsed = setFileUsed(image);
  //   //     return PostImage.create({
  //   //       postId: post.id,
  //   //       url: fileImageUsed,
  //   //       order: i + 1
  //   //     });
  //   //   });
  //   //   await Promise.all(imagePromises);
  //   // }
  //   // Cập nhật số coins
  //   user.coins -= costs.sharePost;
  //   user.lastActive = new Date();
  //   await user.save();
  //   // this.notificationService.notifyAddPost({ post, author: user });
  //   // Thong bao
  //   return {
  //     id: String(postShare.id),
  //     coins: String(user.coins)
  //   };
  // }

  static async getMyPosts({ userId, limit, offset }) {
    if (!userId) throw new BadRequestError(Message.ID_EMPTY);
    const user = await User.findByPk(userId);

    const query = {
      where: { authorId: userId },
      include: [
        {
          model: User,
          as: 'author',
          attributes: ['id', 'avatar', 'username', 'email', 'phoneNumber'],
          required: false
        },
        {
          model: PostImage,
          as: 'images',
          order: [['order', 'ASC']],
          required: false
        },
        {
          model: PostVideo,
          as: 'videos'
        },
        {
          model: Group,
          as: 'group',
          attributes: ['id', 'groupName', 'description', 'coverPhoto'],
          required: false
        },
        {
          model: Feel,
          as: 'feels',
          where: { userId },
          required: false
        }
      ],
      attributes: [
        'id',
        'authorId',
        'description',
        'status',
        'edited',
        'categoryId',
        'rate',
        'createdAt',
        [
          sequelize.literal(
            '(SELECT COUNT(*) FROM "Feels" WHERE "Feels"."postId" = "Post"."id" AND "Feels"."type" = 0)'
          ),
          'kudosCount'
        ],
        [
          sequelize.literal(
            '(SELECT COUNT(*) FROM "Feels" WHERE "Feels"."postId" = "Post"."id" AND "Feels"."type" = 1)'
          ),
          'disappointedCount'
        ],
        [
          sequelize.literal(
            '(SELECT COUNT(*) FROM "Marks" WHERE "Marks"."postId" = "Post"."id" AND "Marks"."type" = 0)'
          ),
          'trustCount'
        ],
        [
          sequelize.literal(
            '(SELECT COUNT(*) FROM "Marks" WHERE "Marks"."postId" = "Post"."id" AND "Marks"."type" = 1)'
          ),
          'fakeCount'
        ]
      ],
      order: [['id', 'DESC']],
      distinct: true,
      subQuery: false,
      offset,
      limit
    };

    const postTotal = await Post.findAndCountAll(query);

    return {
      rows: postTotal.rows.map((post) => ({
        post,
        can_edit: getCanEdit(post, user),
        banned: getBanned(post)
      })),
      count: postTotal.count
    };
  }
}
