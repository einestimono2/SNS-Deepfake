import { Op } from 'sequelize';

import { Block } from '../block/block.model.js';
import { BlockServices } from '../block/block.service.js';
import { BadRequestError, ForbiddenError } from '../core/error.response.js';
import { Notification } from '../notification/notification.model.js';
import { NotificationServices } from '../notification/notification.service.js';
import { Feel } from '../post/models/feel.model.js';
import { Mark } from '../post/models/mark.model.js';
import { Post } from '../post/post.model.js';
import { User } from '../user/user.model.js';

import { Comment } from './comment.model.js';

import { costs, FeelType, Message, NotificationType, Roles } from '#constants';

export class CommentServices {
  // Lấy ra những bình luận cấp 1 và cấp 2 tương ứng
  static async getMarkComment({ userId, limit, offset }, postId) {
    const usersIdBlocked = await Block.findAll({
      where: { userId },
      attributes: ['targetId']
    });
    // Danh sach các userId mà bị mình blocgettargetId
    const usersIdBlocking = await Block.findAll({
      where: { targetId: userId },
      attributes: ['userId']
    });
    // Tìm kiếm bài viết
    const post = await Post.findOne({ where: { id: postId } });
    if (!post) {
      throw new BadRequestError(Message.POST_NOT_FOUND);
    }
    // Kiểm tra bạn có bị chủ bài viết block hay không?
    const isUserBlocked = await BlockServices.isBlock(userId, post.authorId);
    if (isUserBlocked) {
      throw new BadRequestError(Message.CAN_NOT_BLOCK);
    }
    // Lấy danh sách các bình luận cấp 1 của bài viết tương ứng của những tác giả không bị mình block và không block mình
    const marksTotal = await Mark.findAndCountAll({
      include: [
        {
          model: User,
          as: 'user',
          required: true,
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
        }
      ],
      where: { postId },
      order: [['id', 'DESC']],
      distinct: true,
      offset,
      limit
    });
    // Lấy những comment cấp 2 tương ứng
    const markedComments = await Promise.all(
      // Ứng với mỗi marks lấy danh sách các comment tương ứng
      marksTotal.rows.map(async (mark) => {
        const comments = await Comment.findAll({
          where: { markId: mark.id },
          include: {
            model: User,
            as: 'user',
            required: false, // Đảm bảo rằng việc join không làm mất bất kỳ bản ghi nào nếu không có kết quả phù hợp
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
          order: [['id', 'ASC']]
        });
        mark.comments = comments;
        return mark;
      })
    );
    return {
      rows: markedComments.map((mark) => ({
        id: mark.id,
        mark_content: mark.content,
        type_of_mark: String(mark.type),
        created: mark.createdAt,
        poster: mark.user,
        comments: mark.comments.map((comment) => ({
          id: comment.id,
          mark_content: comment.content,
          created: comment.createdAt,
          type_of_mark: String(mark.type),
          poster: comment.user
        }))
      })),
      count: marksTotal.count
    };
  }

  // Thêm mới Mark và Comment
  static async setMarkComment(userId, postId, body) {
    const user = await User.findOne({
      where: { id: userId }
    });

    // Kiểm tra role của người dùng(bố mẹ cho phép bình luận)
    if (user.role === Roles.Children) {
      throw new ForbiddenError(Message.INSUFFICIENT_ACCESS_RIGHTS);
    }
    const { content, markId, limit, offset, type } = { ...body };
    // Reply một Mark có sẵn
    if (markId) {
      // Mark là bình luận cấp 1
      // Trả về  mark và thông tin bài post mà mark này thuộc về
      const mark = await Mark.findOne({
        where: { id: markId },
        include: [{ model: Post, as: 'post' }]
      });
      if (!mark) {
        throw new BadRequestError(Message.MARK_IS_INVALID);
      }
      // Kiểm tra xem người dùng hiện tại có bị block bởi tác giả của mark hay là tác giả của bài viết hay không?
      if (
        (await BlockServices.isBlock(mark.post.authorId, userId)) ||
        (await BlockServices.isBlock(mark.userId, userId))
      ) {
        throw new BadRequestError(Message.USER_IS_INVALID);
      }
      await Comment.create({
        markId,
        content,
        userId
      });
      // NotificationServices.createNotification({
      //   type: NotificationType.PostCommented,
      //   userId: mark.post.authorId,
      //   post: mark.post,
      //   mark,
      //   target: user
      // });

      // if (mark.userId !== mark.post.authorId) {
      //   NotificationServices.createNotification({
      //     type: NotificationType.MarkCommented,
      //     userId: mark.userId,
      //     post: mark.post,
      //     mark,
      //     target: user
      //   });
      // }
    } else {
      // Tạo Mark
      const post = await Post.findOne({ where: { id: postId } });
      if (!post) {
        throw new BadRequestError(Message.POST_NOT_FOUND);
      }
      const isBlocked = await BlockServices.isBlock(userId, post.authorId);
      if (isBlocked) {
        throw new BadRequestError(Message.CAN_NOT_BLOCK);
      }
      let checkReduceCoins = false;
      // Check ng dùng đã có bình luận cấp 1 trên bài post này hay chưa
      let mark = await Mark.findOne({ where: { postId, userId } });
      if (mark) {
        if (type && type !== mark.type) {
          if (user.coins < costs.createMark) {
            throw new BadRequestError(Message.NO_ENOUGH_COINS);
          }
          mark.type = type;
          checkReduceCoins = true;
        }
        if (content) {
          mark.content = content;
        }
        await mark.save();
        // await Notification.destroy({
        //   where: {
        //     type: NotificationType.PostMarked,
        //     targetId: user.id,
        //     markId: mark.id
        //   }
        // });
      } else {
        if (user.coins < costs.createMark) {
          throw new BadRequestError(Message.NO_ENOUGH_COINS);
        }
        checkReduceCoins = true;
        mark = await Mark.create({
          postId,
          content,
          type,
          userId: user.id
        });
      }
      if (checkReduceCoins) {
        user.coins -= costs.createMark;
      }
      user.lastActive = new Date();
      await user.save();
      // await NotificationServices.createNotification({
      //   type: NotificationType.PostMarked,
      //   userId: post.authorId,
      //   post,
      //   mark,
      //   target: user
      // });
    }
    const data = await this.getMarkComment({ userId, limit, offset }, postId);
    return {
      data,
      coins: String(user.coins)
    };
  }

  // Cảm xúc lên một bài viết
  static async feel(userId, postId, type) {
    // Tìm bài đăng theo id
    const user = await User.findOne({
      where: { id: userId }
    });
    const post = await Post.findOne({ where: { id: postId } });
    // Nếu không tìm thấy bài đăng, ném ra một ngoại lệ
    if (!post) {
      throw new BadRequestError(Message.POST_NOT_FOUND);
    }
    // Kiểm tra xem 2 người dùng có chặn nhau không
    const isBlocked = await BlockServices.isBlock(userId, post.authorId);
    if (isBlocked) {
      throw new BadRequestError(Message.CAN_NOT_BLOCK);
    }
    // Tìm cảm xúc (feel) của người dùng hiện tại cho bài đăng
    let feel = await Feel.findOne({ where: { postId, userId } });
    let checkReduceCoins = false;
    // Nếu cảm xúc đã tồn tại
    if (feel) {
      // check loại cảm xúc không giống với loại cảm xúc trước đó, cập nhật loại cảm xúc
      if (type !== feel.type) {
        checkReduceCoins = true;
        feel.type = type;
        // Xóa thông báo liên quan đến cảm xúc trước đó
        await Notification.destroy({
          where: { type: NotificationType.PostFelt, targetId: user.id, feelId: feel.id }
        });
      }
    } else {
      // Nếu cảm xúc chưa tồn tại, tạo mới
      checkReduceCoins = true;
      feel = await Feel.create({
        postId: post.id,
        userId,
        type
      });
    }
    // Nếu cần giảm số coins
    if (checkReduceCoins) {
      if (user.coins < costs.createFeel) {
        throw new BadRequestError(Message.NO_ENOUGH_COINS);
      }
      // Giảm số coins của người dùng
      user.coins -= costs.createFeel;
      await user.save();
      // Lưu cảm xúc vào cơ sở dữ liệu
      await feel.save();
    }
    // Tạo thông báo
    NotificationServices.createNotification({
      type: NotificationType.PostFelt,
      userId: post.authorId,
      post,
      target: user,
      feel
    });
    const [disappointedCount, kudosCount] = await Promise.all([
      Feel.count({ where: { postId, type: FeelType.Disappointed } }),
      Feel.count({ where: { postId, type: FeelType.Kudos } })
    ]);
    return {
      disappointed: disappointedCount,
      kudos: kudosCount
    };
  }

  // Đã test
  static async getListFeels({ userId, limit, offset }, postId) {
    const usersIdBlocked = await Block.findAll({
      where: { userId },
      attributes: ['targetId']
    });
    // Danh sach các userId mà bị mình blocgettargetId
    const usersIdBlocking = await Block.findAll({
      where: { targetId: userId },
      attributes: ['userId']
    });
    // Tìm bài đăng theo id
    const post = await Post.findOne({ where: { id: postId } });
    // Nếu không tìm thấy bài đăng, ném ra một ngoại lệ
    if (!post) {
      throw new BadRequestError(Message.POST_NOT_FOUND);
    }
    // Kiểm tra xem người dùng có bị chặn không
    const isBlocked = await BlockServices.isBlock(userId, post.authorId);
    if (isBlocked) {
      throw new BadRequestError(Message.CAN_NOT_BLOCK);
    }
    // Lấy danh sách cảm xúc cho bài đăng và danh sách người dùng tương ứng với các feel
    const feelTotal = await Feel.findAndCountAll({
      where: { postId },
      include: {
        model: User,
        as: 'user',
        required: false, // Đảm bảo rằng việc join không làm mất bất kỳ bản ghi nào nếu không có kết quả phù hợp
        attributes: ['id', 'username', 'avatar'],
        where: {
          id: {
            [Op.notIn]: [
              ...usersIdBlocked.map((block) => block.targetId),
              ...usersIdBlocking.map((block) => block.userId)
            ]
          }
        }
      },
      distinct: true,
      order: [['id', 'DESC']],
      offset,
      limit
    });
    return feelTotal;
    // feelTotal.rows.map((feel) => ({
    //   id: String(feel.id),
    //   feel: {
    //     user: {
    //       id: String(feel.user.id),
    //       name: feel.user.username || '',
    //       avatar: feel.user.avatar || ''
    //     },
    //     type: String(feel.type)
    //   }
    // }));
  }

  // Đã test
  static async deleteFeel(userId, postId) {
    const post = await Post.findOne({ id: postId });
    if (!post) {
      throw new BadRequestError(Message.POST_NOT_FOUND);
    }
    // if (await BlockServices.isBlock(userId, post.authorId)) {
    //   throw new BadRequestError(Message.CAN_NOT_BLOCK);
    // }
    await Feel.destroy({ where: { postId, userId } });
    const [disappointed, kudos] = await Promise.all([
      Feel.count({ where: { postId, type: FeelType.Disappointed } }),
      Feel.count({ where: { postId, type: FeelType.Kudos } })
    ]);
    return {
      disappointed: disappointed || 0,
      kudos: kudos || 0
    };
  }
}
