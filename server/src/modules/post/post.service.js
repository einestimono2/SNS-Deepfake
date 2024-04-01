import dayjs from 'dayjs';
import sequelize from 'sequelize';

import { Block } from '../block/block.model.js';
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

export class PostServices {
  static async addPost(user, body) {
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
    const userInstance = await User.findOne({ where: { id: user.id } });
    // Kiểm tra số coins của user
    if (userInstance.coins < costs.createPost) {
      throw new BadRequestError(Message.NO_ENOUGH_COINS);
    }
    // Kiểm tra các trường đầu vào
    if (!body.description && !body.status && (!body.images || !body.images.length) && !body.video) {
      throw new BadRequestError(Message.FILE_NOT_FOUND);
    }
    // Goi truoc ham Post.create de tao model
    // setFileUsed();
    // Tạo dữ liệu cho bảng post
    const postInstance = await Post.create({
      authorId: user.id,
      description: body.description,
      status: body.status,
      images: []
    });
    // Lưu dữ liệu vào bảng postvideo và postimage
    if (body.video) {
      await PostVideo.create({ postId: postInstance.id, url: body.video });
      // console.log(body.images);
    } else if (body.images?.length) {
      const { images } = body;
      console.log(body.images);
      postInstance.images = images.map((image, i) => {
        console.log(image);
        return PostImage.create({
          postId: postInstance.id,
          url: image,
          order: i + 1
        });
      });
    }
    // Cập nhật số coins
    userInstance.coins -= costs.createPost;
    userInstance.lastActive = new Date();
    await userInstance.save();
    await postInstance.save();
    // await t.commit();
    // this.notificationService.notifyAddPost({ post, author: user });
    // Thong bao
    return {
      id: String(postInstance.id),
      coins: String(user.coins)
    };
  }

  // Lấy thông tin bài viết
  static async getPost(user, postId) {
    const post = await Post.findOne({
      where: { id: postId },
      include: [
        // Trả về thông tin tác giả
        {
          model: User,
          as: 'author',
          where: { deletedAt: null },
          required: false
        },
        // Trả về thông tin ng mà chặn bạn
        {
          model: User,
          as: 'author',
          where: { deletedAt: null },
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
          model: PostImage,
          as: 'images',
          order: [['order', 'ASC']]
        },
        {
          model: PostVideo,
          as: 'video'
        },
        // Tính toán số lượng cảm xúc feel
        {
          model: Feel,
          as: 'feels',
          attributes: [
            [sequelize.fn('COUNT', sequelize.col('type')), 'kudosCount'],
            [sequelize.literal('SUM(CASE WHEN "type" = \'Kudos\' THEN 1 ELSE 0 END)'), 'feel_kudos'],
            [sequelize.literal('SUM(CASE WHEN "type" = \'Disappointed\' THEN 1 ELSE 0 END)'), 'feel_disappointed']
          ],
          where: { postId: sequelize.col('post.id') },
          required: false
        },
        // Tính toán số lượng đánh giá của mỗi bài đăng
        {
          model: Mark,
          as: 'marks',
          attributes: [
            [sequelize.fn('COUNT', sequelize.col('type')), 'marksCount'],
            [sequelize.literal('SUM(CASE WHEN "type" = \'Trust\' THEN 1 ELSE 0 END)'), 'mark_trust'],
            [sequelize.literal('SUM(CASE WHEN "type" = \'Fake\' THEN 1 ELSE 0 END)'), 'mark_fake']
          ],
          where: { postId: sequelize.col('post.id') },
          required: false
        },
        {
          model: Feel,
          as: 'feel_of_user',
          where: { userId: user.id },
          required: false
        },
        {
          model: Mark,
          as: 'mark_of_user',
          where: { userId: user.id },
          required: false
        }
      ],
      order: [
        [{ model: PostImage, as: 'images' }, 'order', 'ASC'],
        [{ model: Post, as: 'histories' }, 'id', 'DESC']
      ]
    });
    if (!post) {
      throw new BadRequestError(Message.POST_NOT_FOUND);
    }
    return {
      id: String(post.id),
      name: '',
      created: post.createdAt,
      described: post.description || '',
      modified: String(post.edited),
      fake: String(post.fakeCount),
      trust: String(post.trustCount),
      kudos: String(post.kudosCount),
      disappointed: String(post.disappointedCount),
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
        coins: String(post.author.coins),
        listing: post.histories.map((e) => String(e.oldPostId))
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

  // Lấy danh sách các bài viết
  static async getListPosts(user, body) {
    const post = await Post.findAll({
      include: [
        {
          model: User,
          as: 'author',
          required: true
        },
        {
          model: User,
          as: 'blocked',
          where: { userId: user.id },
          required: false
        },
        {
          model: User,
          as: 'blocking',
          where: { targetId: user.id },
          required: false
        },
        {
          model: PostImage,
          as: 'images'
        },
        {
          model: PostVideo,
          as: 'video'
        }
      ],
      attributes: {
        include: [
          [sequelize.literal('(SELECT COUNT(*) FROM feels WHERE feels.postId = post.id)'), 'feelsCount'],
          [sequelize.literal('(SELECT COUNT(*) FROM marks WHERE marks.postId = post.id)'), 'marksCount']
        ]
      },
      where: {
        '$author.blocked.id$': null,
        '$author.blocking.id$': null
      },
      order: [['id', 'DESC']],
      offset: body.index,
      limit: body.count
    });
    if (!post) {
      throw new BadRequestError(Message.POST_NOT_FOUND);
    }
    if (dayjs(post.createdAt).add(5, 'minutes').isBefore(dayjs())) {
      if (user.coins < costs.editPost) {
        throw new BadRequestError(Message.NO_ENOUGH_COINS);
      }
      user.coins -= costs.editPost;
      await user.save();
    }
    const oldPost = new Post({
      authorId: post.authorId,
      description: post.description,
      status: post.status,
      images: post.images.map(
        (image) =>
          new PostImage({
            url: image.url,
            order: image.order
          })
      ),
      video: post.video && new PostVideo({ url: post.video.url }),
      edited: post.edited,
      deletedAt: new Date()
    });
    await oldPost.save();
    // await postHistoryRepo.save(new PostHistory({ postId: post.id, oldPostId: oldPost.id }));
    const mapImages = {};
    for (const image of post.images) {
      mapImages[image.order] = image;
    }
    for (const image of body.images) {
      post.images.push(new PostImage({ url: image }));
    }
    for (let i = 0; i < post.images.length; i++) {
      post.images[i].order = i + 1;
    }
    if (body.imageSort) {
      post.images = [];
      for (const order of body.imageSort) {
        if (mapImages[order]) {
          post.images.push(mapImages[order]);
        }
      }
    }
    if (body.imageDel) {
      const deleted = {};
      for (const order of body.imageDel) {
        deleted[order] = true;
      }
      post.images = post.images.filter((image) => !deleted[image.order]);
    }
    if (body.described !== undefined && body.described !== null) {
      post.description = body.described;
    }
    if (body.status !== undefined && body.status !== null) {
      post.status = body.status;
    }
    if (body.video) {
      if (post.video) {
        post.video.url = body.video;
      } else {
        post.video = new PostVideo({ url: body.video });
      }
    }
    if (post.video) {
      post.images = [];
    } else {
      post.images = post.images.slice(0, 20);
    }
    for (let i = 0; i < post.images.length; i++) {
      post.images[i].order = i + 1;
    }
    for (const mark of post.marks) {
      mark.editable = true;
    }
    for (const feel of post.feels) {
      feel.editable = true;
    }

    await post.save();
    this.notificationService.notifyEditPost({ post, author: user });

    return {
      id: String(post.id),
      coins: String(user.coins)
    };
  }

  // Chỉnh sửa một bài viết
  static async editPost(user, body) {
    const post = await Post.findOne({
      where: {
        id: body.id,
        authorId: user.id
      },
      // Lấy  những ảnh tương ứng được sắp xếp và chỉ lấy ra 2 thuộc tính url và order
      include: [
        { model: PostImage, as: 'images', order: [['order', 'ASC']] },
        { model: PostVideo, as: 'video' },
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
    const oldPost = Post.build({
      authorId: post.authorId,
      description: post.description,
      status: post.status,
      edited: post.edited,
      deletedAt: new Date()
    });
    // Tạo dữ liệu cho bảng PostHistory
    await PostHistory.create({
      postId: post.id,
      oldPostId: oldPost.id
    });
    const imageModels = body.images.map((image) => ({
      url: image
    }));
    await PostImage.bulkCreate(imageModels);
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
    if (body.described !== undefined && body.described !== null) {
      post.description = body.described;
    }
    if (body.status !== undefined && body.status !== null) {
      post.status = body.status;
    }
    // Xử lý video
    if (body.video) {
      if (post.video) {
        post.video.url = body.video;
      } else {
        post.video = await PostVideo.create({ url: body.video });
      }
    }
    await post.save();
    // this.notificationService.notifyEditPost({ post, author: user });
    return {
      id: String(post.id),
      coins: String(user.coins)
    };
  }

  // Xóa một bài viết
  static async deletePost(user, postId) {
    return Post.sequelize.transaction(async (t) => {
      const post = await Post.findOne({
        where: { id: postId, authorId: user.id },
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

  // Report một bài viết
  static async reportPost(user, { ...reports }) {
    const post = await Post.findOne({ where: { id: reports.id } });
    if (!post) {
      throw new BadRequestError(Message.POST_NOT_FOUND);
    }
    const report = await Report.create({
      postId: reports.id,
      subject: reports.subject,
      details: reports.details,
      userId: user.id
    });
    return { report };
  }

  // Lấy những bài viết mới
  static async getNewPosts(user, count) {
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
        [{ model: PostView, as: 'view' }, 'count', 'ASC', { nulls: 'FIRST' }],
        ['id', 'DESC']
      ],
      limit: count
    });

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

  //
  static async setViewedPost(user, postId) {
    // Tìm postView dựa trên postId và userId
    let postView = await PostView.findOne({ where: { postId, userId: user.id } });
    // Nếu không tìm thấy, tạo mới một postView
    if (!postView) {
      postView = await PostView.create({ postId, userId: user.id, count: 0 });
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
}
