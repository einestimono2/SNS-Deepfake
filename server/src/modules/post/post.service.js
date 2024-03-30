import dayjs from 'dayjs';

import { BadRequestError } from '../core/error.response.js';
import { User } from '../user/user.model.js';

import { Feel } from './feel/feel.model.js';
import { Post } from './post.model.js';

import { costs, Message } from '#constants';

export class PostServices {
  static async addPost(body) {
    // query user

    // Kiểm tra số coins của user
    if (body.user.coins < costs.createPost) {
      throw new BadRequestError(Message.NO_ENOUGH_COINS);
    }

    // Kiểm tra các trường đầu vào
    if (!body.described && !body.status && (!body.images || !body.images.length) && !body.video) {
      throw new BadRequestError(Message.FILE_NOT_FOUND);
    }

    // Goi truoc ham Post.create de tao model
    // setFileUsed();

    // Tạo dữ liệu cho bảng post
    const post = await Post.create({
      authorId: body.user.id,
      description: body.described,
      status: body.status,
      images: []
    });

    // Cập nhật số coins
    body.user.coins -= costs.createPost;
    body.user.lastActive = new Date();
    await body.user.save();
    await post.save();
    // this.notificationService.notifyAddPost({ post, author: user });
    // Thong bao
    return {
      id: String(post.id),
      coins: String(body.user.coins)
    };
  }

  // Lấy thông tin bài viết
  // static async getPost(user, id) {
  //   const post = await Post.findOne({
  //     where: { id },
  //     include: [
  //       {
  //         model: User,
  //         as: 'author',
  //         required: true,
  //         attributes: ['id', 'username', 'avatar', 'coins'],
  //         include: [
  //           {
  //             model: User,
  //             as: 'blocked',
  //             where: { id: user.id },
  //             attributes: []
  //           },
  //           {
  //             model: User,
  //             as: 'blocking',
  //             where: { targetId: user.id },
  //             attributes: []
  //           }
  //         ],
  //         through: { attributes: [] }
  //       },
  //       {
  //         model: Feel,
  //         as: 'feels',
  //         where: { userId: user.id },
  //         required: false,
  //         attributes: []
  //       }
  //       // {
  //       //   model: Mark,
  //       //   as: 'marks',
  //       //   where: { userId: user.id },
  //       //   required: false,
  //       //   attributes: []
  //       // }
  //     ],
  //     order: [
  //       [{ model: 'images', as: 'images' }, 'order', 'ASC'],
  //       [{ model: 'histories', as: 'histories' }, 'id', 'DESC']
  //     ]
  //   });

  //   if (!post) {
  //     throw new BadRequestError(Message.POST_NOT_FOUND);
  //   }
  //   return {
  //     id: String(post.id),
  //     name: '',
  //     created: post.createdAt,
  //     described: post.description || '',
  //     modified: String(post.edited),
  //     fake: String(post.fakeCount),
  //     trust: String(post.trustCount),
  //     kudos: String(post.kudosCount),
  //     disappointed: String(post.disappointedCount),
  //     is_felt: post.feels.length ? String(post.feels[0].type) : '-1',
  //     is_marked: post.marks.length ? '1' : '0',
  //     your_mark: post.marks.length
  //       ? {
  //           mark_content: post.marks[0].content,
  //           type_of_mark: String(post.marks[0].type)
  //         }
  //       : undefined,
  //     image: post.images.map((e) => ({
  //       id: String(e.order),
  //       url: e.url
  //     })),
  //     video: post.video ? { url: post.video.url } : undefined,
  //     author: {
  //       id: String(post.author.id),
  //       name: post.author.username || '',
  //       avatar: post.author.avatar,
  //       coins: String(post.author.coins),
  //       listing: post.histories.map((e) => String(e.oldPostId))
  //     },
  //     // category: getCategory(post),
  //     // state: post.status || '',
  //     // is_blocked: '0',
  //     // can_edit: getCanEdit(post, user),
  //     // banned: getBanned(post),
  //     // can_mark: getCanMark(post, user),
  //     // can_rate: getCanRate(post, user),
  //     url: '',
  //     messages: '',
  //     deleted: post.deletedAt ? post.deletedAt : undefined
  //   };
  // }

  // // Lấy danh sách các bài viết
  // static async getListPosts(user, { id, described, status, imageSort, imageDel }, images, video) {
  //   const post = await Post.findOne({
  //     where: {
  //       id,
  //       authorId: user.id
  //     },
  //     include: [
  //       { model: PostImage, as: 'images', order: [['order', 'ASC']] },
  //       { model: PostVideo, as: 'video' },
  //       // { model: Mark, as: 'marks', include: [{ model: Comment, as: 'comments' }] },
  //       { model: Feel, as: 'feels' }
  //     ]
  //   });

  //   if (!post) {
  //     throw new BadRequestError(Message.POST_NOT_FOUND);
  //   }

  //   if (dayjs(post.createdAt).add(5, 'minutes').isBefore(dayjs())) {
  //     if (user.coins < costs.editPost) {
  //       throw new BadRequestError(Message.NO_ENOUGH_COINS);
  //     }
  //     user.coins -= costs.editPost;
  //     await user.save();
  //   }

  //   const oldPost = new Post({
  //     authorId: post.authorId,
  //     description: post.description,
  //     status: post.status,
  //     images: post.images.map(
  //       (image) =>
  //         new PostImage({
  //           url: image.url,
  //           order: image.order
  //         })
  //     ),
  //     video: post.video && new PostVideo({ url: post.video.url }),
  //     edited: post.edited,
  //     deletedAt: new Date()
  //   });
  //   await oldPost.save();
  //   // await postHistoryRepo.save(new PostHistory({ postId: post.id, oldPostId: oldPost.id }));

  //   const mapImages = {};
  //   for (const image of post.images) {
  //     mapImages[image.order] = image;
  //   }

  //   for (const image of images) {
  //     post.images.push(new PostImage({ url: image }));
  //   }
  //   for (let i = 0; i < post.images.length; i++) {
  //     post.images[i].order = i + 1;
  //   }

  //   if (imageSort) {
  //     post.images = [];
  //     for (const order of imageSort) {
  //       if (mapImages[order]) {
  //         post.images.push(mapImages[order]);
  //       }
  //     }
  //   }
  //   if (imageDel) {
  //     const deleted = {};
  //     for (const order of imageDel) {
  //       deleted[order] = true;
  //     }
  //     post.images = post.images.filter((image) => !deleted[image.order]);
  //   }
  //   if (described !== undefined && described !== null) {
  //     post.description = described;
  //   }
  //   if (status !== undefined && status !== null) {
  //     post.status = status;
  //   }
  //   if (video) {
  //     if (post.video) {
  //       post.video.url = video;
  //     } else {
  //       post.video = new PostVideo({ url: video });
  //     }
  //   }
  //   if (post.video) {
  //     post.images = [];
  //   } else {
  //     post.images = post.images.slice(0, 20);
  //   }
  //   for (let i = 0; i < post.images.length; i++) {
  //     post.images[i].order = i + 1;
  //   }
  //   for (const mark of post.marks) {
  //     mark.editable = true;
  //   }
  //   for (const feel of post.feels) {
  //     feel.editable = true;
  //   }

  //   await post.save();
  //   this.notificationService.notifyEditPost({ post, author: user });

  //   return {
  //     id: String(post.id),
  //     coins: String(user.coins)
  //   };
  // }

  // static editPost(user, body, images, video) {
  //   return sequelize.transaction(async (transaction) => {
  //     try {
  //       const post = await Post.findOne({
  //         where: {
  //           id,
  //           authorId: user.id
  //         },
  //         include: [
  //           {
  //             model: PostImage,
  //             as: 'images',
  //             attributes: ['url', 'order']
  //           },
  //           {
  //             model: PostVideo,
  //             as: 'video',
  //             attributes: ['url']
  //           },
  //           {
  //             model: Mark,
  //             as: 'marks',
  //             include: [
  //               {
  //                 model: Comment,
  //                 as: 'comments'
  //               }
  //             ]
  //           },
  //           {
  //             model: Feel,
  //             as: 'feels'
  //           }
  //         ],
  //         order: [['images', 'order', 'ASC']]
  //       });

  //       if (!post) {
  //         throw new Error('Post not found');
  //       }

  //       if (dayjs(post.createdAt).add(5, 'minutes').isBefore(dayjs())) {
  //         if (user.coins < costs.editPost) {
  //           throw new Error('Not enough coins');
  //         }
  //         user.coins -= costs.editPost;
  //         await user.save({ transaction });
  //       }

  //       const oldPost = await Post.create(
  //         {
  //           authorId: post.authorId,
  //           description: post.description,
  //           status: post.status,
  //           edited: post.edited,
  //           deletedAt: new Date()
  //         },
  //         { transaction }
  //       );

  //       await PostHistory.create(
  //         {
  //           postId: post.id,
  //           oldPostId: oldPost.id
  //         },
  //         { transaction }
  //       );

  //       const imageModels = images.map((image) => ({
  //         url: getFileName(image)
  //       }));
  //       await PostImage.bulkCreate(imageModels, { transaction });

  //       // Sắp xếp lại thứ tự ảnh nếu cần
  //       if (image_sort) {
  //         const newOrderImages = [];
  //         for (const order of image_sort) {
  //           const foundImage = post.images.find((image) => image.order === order);
  //           if (foundImage) {
  //             newOrderImages.push(foundImage);
  //           }
  //         }
  //         post.images = newOrderImages;
  //       }

  //       // Xóa ảnh nếu cần
  //       if (image_del) {
  //         const deletedOrders = image_del.map(Number);
  //         post.images = post.images.filter((image) => !deletedOrders.includes(image.order));
  //       }

  //       if (described !== undefined && described !== null) {
  //         post.description = described;
  //       }
  //       if (status !== undefined && status !== null) {
  //         post.status = status;
  //       }

  //       // Xử lý video
  //       if (video) {
  //         if (post.video) {
  //           post.video.url = getFileName(video);
  //         } else {
  //           post.video = await PostVideo.create({ url: getFileName(video) }, { transaction });
  //         }
  //       }

  //       await post.save({ transaction });
  //       this.notificationService.notifyEditPost({ post, author: user });

  //       return {
  //         id: String(post.id),
  //         coins: String(user.coins)
  //       };
  //     } catch (error) {
  //       throw new Error(error.message);
  //     }
  //   });
  // }

  // static async deletePost(user, id) {
  //   return Post.sequelize.transaction(async (t) => {
  //     const post = await Post.findOne({
  //       where: { id, authorId: user.id },
  //       include: ['histories']
  //     });
  //     if (!post) {
  //       throw new Error('Post not found');
  //     }
  //     if (post.histories.length > 0) {
  //       await Post.destroy({
  //         where: { id: post.histories.map((history) => history.oldPostId) },
  //         transaction: t
  //       });
  //     }
  //     await post.destroy({ transaction: t });
  //     user.coins -= costs.deletePost;
  //     await user.save({ transaction: t });
  //     return { coins: String(user.coins) };
  //   });
  // }

  // static async reportPost(user, { ...reports }) {
  //   const post = await Post.findOne({ where: { id: reports.id } });

  //   if (!post) {
  //     throw new Error('Post not found');
  //   }

  //   const report = await Report.create({
  //     postId: reports.id,
  //     subject: reports.subject,
  //     details: reports.details,
  //     userId: user.id
  //   });

  //   return { report };
  // }
}
