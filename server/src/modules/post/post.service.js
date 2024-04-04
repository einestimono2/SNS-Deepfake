import dayjs from 'dayjs';
import sequelize, { Op } from 'sequelize';

import { Block } from '../block/block.model.js';
import { Comment } from '../comment/comment.model.js';
import { BadRequestError } from '../core/error.response.js';
import { User } from '../user/user.model.js';

import { Feel } from './models/feel.model.js';
import { Mark } from './models/mark.model.js';
import { PostHistory } from './models/post.history.js';
import { PostImage } from './models/post_image.model.js';
import { PostVideo } from './models/post_video.model.js';
import { PostView } from './models/post_view.model.js';
import { Report } from './models/report.model.js';
import { Post } from './post.model.js';

import { Message, costs } from '#constants';
import { setFileUsed } from '#utils';

export class PostServices {
  // Tất cả đều chưa xử lý transaction và notification
  // Thêm mới một bài viết(Đã test)
  static async addPost(userId, body) {
    // C1:Dùng transaction
    // const t = await postgre.transaction();
    // try {
    //   const userInstance = await User.findOne({ where: { id: user.id } }, { transaction: t });
    //   // Kiểm tra số coins của user
    //   if (userInstance.coins < costs.createPost) {
    //     throw new BadRequestError(Message.NO_ENOUGH_COINS);
    //   }
    //   // Kiểm tra các trường đầu vào
    //   if (!body.description && !body.status && (!body.images || !body.images.length) && !body.video) {
    //     throw new BadRequestError(Message.FILE_NOT_FOUND);
    //   }
    //   // Goi truoc ham Post.create de tao model
    //   // setFileUsed();
    //   // Tạo dữ liệu cho bảng post
    //   console.log(typeof user.id);
    //   const postInstance = await Post.create(
    //     {
    //       authorId: user.id,
    //       description: body.description,
    //       status: body.status,
    //       images: []
    //     },
    //     { transaction: t }
    //   );
    //   // Lưu dữ liệu vào bảng postvideo và postimage
    //   if (body.video) {
    //     await PostVideo.create({ postId: postInstance.id, url: body.video }, { transaction: t });
    //   } else if (body.images?.length) {
    //     body.images.map(async (image, i) => {
    //       postInstance.images = await PostImage.create(
    //         {
    //           postId: postInstance.id,
    //           url: image,
    //           order: i + 1
    //         },
    //         { transaction: t }
    //       );
    //     });
    //   }
    //   // Cập nhật số coins
    //   userInstance.coins -= costs.createPost;
    //   userInstance.lastActive = new Date();
    //   await userInstance.save({ transaction: t });
    //   // await t.commit();
    //   // this.notificationService.notifyAddPost({ post, author: user });
    //   // Thong bao
    //   return {
    //     id: String(postInstance.id),
    //     coins: String(user.coins)
    //   };
    // } catch (error) {
    //   await t.rollback();
    //   throw error;
    // }
    //= ==== C2:Không dùng transaction
    const user = await User.findOne({ where: { id: userId } });
    // Kiểm tra số coins của user
    if (user.coins < costs.createPost) {
      throw new BadRequestError(Message.NO_ENOUGH_COINS);
    }
    // Kiểm tra các trường đầu vào
    if (!body.description && !body.status && (!body.images || !body.images.length) && !body.video) {
      throw new BadRequestError(Message.FILE_NOT_FOUND);
    }
    // Goi truoc ham Post.create de tao model
    // setFileUsed();
    // Tạo dữ liệu cho bảng post
    const post = await Post.create({
      authorId: userId,
      description: body.description,
      status: body.status
    });
    // Lưu dữ liệu vào bảng postvideo và postimage
    if (body.video) {
      const fileVideoUsed = setFileUsed(body.video);
      await PostVideo.create({ postId: post.id, url: fileVideoUsed });
    }
    if (body.images?.length) {
      const { images } = body;
      // console.log(body.images);
      post.images = images.map((image, i) => {
        const fileImageUsed = setFileUsed(image);
        return PostImage.create({
          postId: post.id,
          url: fileImageUsed,
          order: i + 1
        });
      });
    }
    // Cập nhật số coins
    user.coins -= costs.createPost;
    user.lastActive = new Date();
    await user.save();
    await post.save();
    // await t.commit();
    // this.notificationService.notifyAddPost({ post, author: user });
    // Thong bao
    return {
      id: String(post.id),
      coins: String(user.coins)
    };
  }

  // Lấy thông tin bài viết(vấn đề bảng Block)
  static async getPost(userId, postId) {
    const post = await Post.findOne({
      where: { id: postId },
      include: [
        // Trả về thông tin ng mà chặn bạn
        {
          model: User,
          as: 'author',
          // where: { deletedAt: null },
          include: [
            {
              model: Block,
              as: 'blocked',
              where: { userId },
              required: false
            },
            {
              model: Block,
              as: 'blocking',
              where: { targetId: userId },
              required: false
            }
          ]
        },
        {
          model: PostImage,
          as: 'images',
          order: [['order', 'ASC']]
        },
        {
          model: PostVideo,
          as: 'video'
        },
        {
          model: PostHistory,
          as: 'histories'
        },
        // Tính tổng số lượng cảm xúc feel
        {
          model: Feel,
          as: 'feels',
          attributes: [
            [
              sequelize.literal(
                'SUM(CASE WHEN "marks"."type"=\'0\' THEN 1 ELSE 0 END) + SUM(CASE WHEN "marks"."type"=\'1\' THEN 1 ELSE 0 END)'
              ),
              'total_feel_count'
            ]
          ],
          where: { postId },
          required: false
        },
        // Tính tổng số lượng đánh giá của mỗi bài đăng
        {
          model: Mark,
          as: 'marks',
          attributes: [
            [
              sequelize.literal(
                'SUM(CASE WHEN "marks"."type"=\'0\' THEN 1 ELSE 0 END) + SUM(CASE WHEN "marks"."type"=\'1\' THEN 1 ELSE 0 END)'
              ),
              'total_mark_count'
            ]
          ],
          where: { postId },
          required: false
        },
        // Lấy thông tin cảm xúc,đánh giá của người dùng hiện tại
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
      group: [
        'Post.id',
        'author.id',
        'author.blocked.id',
        'author.blocking.id',
        'images.id',
        'video.id',
        'feels.id',
        'marks.id',
        'histories.id'
      ]
    });
    if (!post) {
      throw new BadRequestError(Message.POST_NOT_FOUND);
    }
    console.log(post);
    return {
      post,
      id: String(post.id),
      name: '',
      created: post.createdAt,
      described: post.description || '',
      modified: String(post.edited),
      feel: String(post.total_feel_count),
      mark: String(post.total_mark_count),
      is_felt: post.feels.length ? String(post.feels[0].type) : '-1',
      is_marked: post.marks.length ? '1' : '0',
      your_mark: post.marks.length
        ? {
            mark_content: post.marks[0].content,
            type_of_mark: String(post.marks[0].type)
          }
        : undefined,
      image: post.images.map((e) => ({
        id: String(e.order),
        url: e.url
      })),
      video: post.video ? { url: post.video.url } : undefined,
      author: {
        id: String(post.author.id),
        name: post.author.username || '',
        avatar: post.author.avatar,
        coins: String(post.author.coins)
        // listing: post.histories.map((e) => String(e.oldPostId))
      },
      // category: getCategory(post),
      // state: post.status || '',
      // is_blocked: '0',
      // can_edit: getCanEdit(post, user),
      // banned: getBanned(post),
      // can_mark: getCanMark(post, user),
      // can_rate: getCanRate(post, user),
      url: '',
      messages: '',
      deleted: post.deletedAt ? post.deletedAt : undefined
    };
  }

  // Lấy danh sách các bài viết(đã test)
  static async getListPosts(userId, body) {
    const { rows: posts, count: total } = await Post.findAndCountAll({
      include: [
        {
          model: User,
          as: 'author',
          // where: { deletedAt: null },
          include: [
            {
              model: Block,
              as: 'blocked',
              where: { userId },
              required: false
            },
            {
              model: Block,
              as: 'blocking',
              where: { targetId: userId },
              required: false
            }
          ]
        },
        {
          model: PostImage,
          as: 'images',
          order: [['order', 'ASC']]
        },
        {
          model: PostVideo,
          as: 'video'
        }
      ],
      attributes: {
        include: [
          [sequelize.fn('COUNT', 'feels.id'), 'feelsCount'],
          [sequelize.fn('COUNT', 'marks.id'), 'marksCount']
        ]
      },
      order: [['id', 'DESC']],
      offset: body.index,
      limit: body.count,
      group: ['Post.id']
    });
    if (!posts?.length) {
      throw new BadRequestError(Message.POST_NOT_FOUND);
    }
    console.log(posts);
    console.log(total);
    if (body.last_id) {
      posts.id = { [Op.lt]: body.last_id };
    }
    if (body.user_id) {
      posts['$author.id$'] = userId;
    }
    // Tính toán số lượng comment cho mỗi bài viết
    for (const post of posts) {
      const commentsCount = await Comment.count({
        where: { markId: post.id }
      });
      post.commentsCount = commentsCount || 0;
    }
    // Lấy id của bài viết cuối cùng và tính số lượng bài viết mới
    const lastId = posts.length > 0 ? posts[posts.length - 1].id : null;
    const newItems = total - posts.length;
    const transformedPosts = posts.map((post) => ({
      id: String(post.id),
      name: '',
      image: post.images
        .sort((a, b) => a.order - b.order)
        .map((e) => ({
          id: String(e.order),
          url: e.url
        })),
      video: post.video ? { url: post.video.url } : undefined,
      described: post.description || '',
      created: post.createdAt,
      feel: String(post.feelsCount),
      comment_mark: String(post.marksCount + post.commentsCount),
      is_felt: post.feelOfUser ? String(post.feelOfUser.type) : '-1',
      is_blocked: '0',
      // can_edit: getCanEdit(post, user),
      // banned: getBanned(post),
      state: post.status || '',
      author: {
        id: String(post.author.id),
        name: post.author.username || '',
        avatar: post.author.avatar
      }
    }));
    return {
      post: transformedPosts,
      new_items: String(newItems),
      last_id: String(lastId)
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
        { model: PostVideo, as: 'video' },
        { model: Mark, as: 'marks', include: [{ model: Comment, as: 'comments' }] },
        { model: Feel, as: 'feels' }
      ]
    });
    // console.log(post);
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
    // Tạo nhưng chưa insert dữ liệu
    const oldPost = Post.build({
      id: post.id,
      authorId: post.authorId,
      description: post.description,
      images: post.images.map((image) =>
        PostImage.create({
          url: image.url,
          order: image.order
        })
      ),
      video:
        post.video &&
        PostVideo.create({
          url: post.video.url
        }),
      status: post.status,
      edited: post.edited,
      deletedAt: new Date()
    });
    // console.log(oldPost);
    // Tạo dữ liệu cho bảng PostHistory
    await PostHistory.create({
      postId: post.id,
      oldPostId: oldPost.id
    });
    // const imageModels = body.images.map((image) => ({
    //   url: image
    // }));
    const updatedImages = await PostImage.findAll({ where: { postId: post.id } });
    body.images.forEach(async (image, index) => {
      for (let i = 0; i < updatedImages.length; i++) {
        await updatedImages[i].update({ url: image, order: index + 1 });
      }
    });
    // console.log(imageModels);
    // Chèn nhiều bản ghi vào bảng PostImage cùng lúc
    // await PostImage.bulkCreate(imageModels);
    // Sắp xếp lại thứ tự ảnh nếu cần
    if (body.image_sort) {
      const newOrderImages = [];
      for (const order of body.image_sort) {
        const foundImage = post.images.find((image) => image.order === order);
        if (foundImage) {
          newOrderImages.push(foundImage);
        }
      }
      post.images = newOrderImages;
    }
    // Xóa ảnh nếu cần
    if (body.image_del) {
      const deletedOrders = body.image_del.map(Number);
      post.images = post.images.filter((image) => !deletedOrders.includes(image.order));
    }
    if (body.description !== undefined && body.description !== null) {
      post.description = body.description;
    }
    if (body.status !== undefined && body.status !== null) {
      post.status = body.status;
    }
    // Xử lý video
    if (body.video) {
      if (post.video) {
        post.video.url = body.video;
      } else {
        post.video = await PostVideo.create({ postId, url: body.video });
      }
    }
    await post.save();
    // this.notificationService.notifyEditPost({ post, author: user });
    return {
      id: String(post.id),
      coins: String(user.coins)
    };
  }

  // Xóa một bài viết(Đã test)
  static async deletePost(userId, postId) {
    return Post.sequelize.transaction(async (t) => {
      const user = await Post.findOne({
        where: { id: userId }
      });
      const post = await Post.findOne({
        where: { id: postId, authorId: userId },
        include: ['histories']
      });
      if (!post) {
        throw new BadRequestError(Message.POST_NOT_FOUND);
      }
      if (post.histories.length > 0) {
        await Post.destroy({
          where: { id: post.histories.map((history) => history.oldPostId) },
          transaction: t
        });
      }
      await post.destroy({ transaction: t });
      user.coins -= costs.deletePost;
      await user.save({ transaction: t });
      return { coins: String(user.coins) };
    });
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
  static async getNewPosts(userId, count) {
    const user = await User.findOne({
      where: { id: userId }
    });
    const posts = await Post.findAll({
      include: [
        {
          model: User,
          as: 'author',
          include: [
            { model: Block, as: 'blocked', where: { userId: user.id } },
            { model: Block, as: 'blocking', where: { targetId: user.id } }
          ]
        },
        { model: PostImage, as: 'images', order: [['order', 'ASC']] },
        { model: PostVideo, as: 'video' },
        { model: Feel, as: 'feels' },
        { model: Mark, as: 'marks' }
      ],
      where: {
        '$author.blocked.id$': null,
        '$author.blocking.id$': null
      },
      order: [
        [{ model: PostView, as: 'views' }, 'count', 'ASC'],
        ['id', 'DESC']
      ],
      limit: count
    });
    console.log(posts);
    for (const post of posts) {
      if (post.marks.length > 0) {
        const commentsCount = await Comment.count({ where: { markId: post.id } });
        post.commentsCount = commentsCount;
      } else {
        post.commentsCount = 0;
      }
    }
    return {
      post: posts.map((post) => ({
        id: String(post.id),
        name: '',
        image: post.images.map((e) => ({ id: String(e.order), url: e.url })),
        video: post.video ? { url: post.video.url } : undefined,
        described: post.description || '',
        created: post.createdAt,
        feel: String(post.feels.length),
        comment_mark: String(post.marks.length + post.commentsCount),
        is_felt: post.feels.some((feel) => feel.userId === user.id) ? String(post.feelOfUser.type) : '-1',
        is_blocked: '0',
        // can_edit: getCanEdit(post, user),
        // banned: getBanned(post),
        state: post.status || '',
        author: {
          id: String(post.author.id),
          name: post.author.username || '',
          avatar: post.author.avatar
        }
      }))
    };
  }

  // Tăng số lượt xem bài viết(đã test)
  static async setViewedPost(userId, postId) {
    // Tìm postView dựa trên postId và userId
    const postView = await PostView.findOne({ where: { postId } });
    console.log(postView);
    // Nếu không tìm thấy, tạo mới một postView
    if (!postView) {
      await PostView.create({ postId, userId, count: 0 });
    }
    // Tăng giá trị count lên 1
    postView.count += 1;
    // Lưu hoặc cập nhật postView vào cơ sở dữ liệu
    await postView.save();
    // Trả về số lượt xem
    return {
      viewed: String(postView.count)
    };
  }

  // Lấy các video của một người dùng
  static async getListVideos(userId, body) {
    const user = await User.findOne({
      where: { id: userId }
    });
    const { lastId, index, count } = { ...body };
    const whereClause = {
      '$author.blocked.id$': null,
      '$author.blocking.id$': null
    };
    if (lastId) {
      whereClause.id = { [sequelize.Op.lt]: lastId };
    }
    const posts = await Post.findAll({
      // where: whereClause,
      include: [
        {
          model: User,
          as: 'author',
          // where: { deletedAt: null },
          include: [
            {
              model: Block,
              as: 'blocked',
              where: { userId: user.id },
              required: false
            },
            {
              model: Block,
              as: 'blocking',
              where: { targetId: user.id },
              required: false
            }
          ]
        },
        {
          model: PostVideo,
          as: 'video'
        }
      ],
      attributes: {
        include: [
          [sequelize.fn('COUNT', 'feels.id'), 'feelsCount'],
          [sequelize.fn('COUNT', 'marks.id'), 'marksCount']
        ]
      },
      group: ['Post.id'],
      order: [['id', 'DESC']],
      offset: index,
      limit: count
    });
    console.log(posts);
    // const total = await Post.count({ where: options.where });
    // Tính số lượng comment của 1 bài viết
    for (let i = 0; i < posts.length; i++) {
      const post = posts[i];
      if (post.marksCount > 0) {
        const commentsCount = await Comment.count({
          where: {
            postId: post.id
          }
        });
        post.commentsCount = commentsCount;
      } else {
        post.commentsCount = 0;
      }
    }
    // const lastId = posts.length > 0 ? posts[posts.length - 1].id : null;
    // const newItems = total - posts.length;
    return {
      post: posts.map((post) => ({
        id: String(post.id),
        name: '',
        video: post.video ? { url: post.video.url } : undefined,
        described: post.description || '',
        created: post.createdAt,
        feel: String(post.feelsCount),
        comment_mark: String(post.marksCount + post.commentsCount),
        is_felt: post.feelOfUser ? String(post.feelOfUser.type) : '-1',
        is_blocked: post.author.blocked.length > 0 ? '1' : '0',
        // can_edit: getCanEdit(post, user),
        // banned: getBanned(post),
        state: post.status || '',
        author: {
          id: String(post.author.id),
          name: post.author.username || '',
          avatar: post.author.avatar
        }
      })),
      // new_items: String(newItems),
      last_id: String(lastId)
    };
  }
}
