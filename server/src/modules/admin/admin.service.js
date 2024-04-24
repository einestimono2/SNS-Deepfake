import sequelize from 'sequelize';

import { BadRequestError } from '../core/error.response.js';
import { Feel } from '../post/models/feel.model.js';
import { Mark } from '../post/models/mark.model.js';
import { PostImage } from '../post/models/post_image.model.js';
import { PostVideo } from '../post/models/post_video.model.js';
import { Post } from '../post/post.model.js';
import { User } from '../user/user.model.js';

import { Group } from '##/modules/group/group/group.model';
import { MarkType, Message, costs } from '#constants';

export class AdminServices {
  static async getAllPosts(body) {
    const { index, count } = { ...body };
    const postTotal = await Post.findAll({
      include: [
        { model: User, as: 'author' },
        { model: PostVideo, as: 'video' },
        { model: PostImage, as: 'images', order: [['order', 'ASC']] }
      ],
      attributes: {
        include: [
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
      },
      // where: { status: { [this.sequelize.Op.ne]: null } },
      order: [['id', 'DESC']],
      limit: count,
      offset: index
    });
    const posts = [];
    for (const e of postTotal) {
      const post = e.toJSON();
      posts.push(post);
    }
    // console.log(posts);
    console.log(posts);
    const total = await Post.count({ where: { status: { [sequelize.Op.ne]: null } } });
    console.log(total);
    return {
      total,
      items: posts.map((post) => ({
        id: String(post.id),
        name: '',
        image: post.images?.map((image) => ({
          id: String(image.order),
          url: image.url
        })),
        rate: post.rate ? String(post.rate) : '-1',
        video: post.video ? { url: post.video.url } : undefined,
        described: post.description || '',
        created: post.createdAt,
        // banned: getBanned(post),
        state: post.status || '',
        author: {
          id: String(post.author.id),
          name: post.author.username || '',
          avatar: post.author.avatar
        },
        trust_count: post.trust_count,
        fake_count: post.fake_count,
        kudos_count: post.kudos_count,
        disappointed_count: post.disappointed_count
      }))
    };
  }

  static async ratePost(body) {
    const { postId, rate } = { ...body };
    const post = await Post.findOne({
      where: { id: postId },
      include: [
        { model: User, as: 'author' },
        { model: Feel, as: 'feels', include: [{ model: User, as: 'user' }] },
        { model: Mark, as: 'marks', include: [{ model: User, as: 'user' }] }
      ]
    });
    if (!post) {
      throw new BadRequestError(Message.POST_NOT_FOUND);
    }
    if (post.rate !== null) {
      throw new BadRequestError(Message.POST_NOT_FOUND);
    }
    post.rate = rate;
    await post.save();

    const checkAuthor = async () => {
      const coefficient = rate === MarkType.Fake ? 0 : 3;
      post.author.coins += coefficient * costs.createPost;
      await post.author.save();
    };
    const checkFeels = post.feels.map(async (feel) => {
      const { user: feelOfUser, type } = feel;
      const feelCoefficient = type === rate ? 3 : -1;
      feelOfUser.coins += feelCoefficient * costs.createFeel;
      await feelOfUser.save();
    });

    const checkMarks = post.marks.map(async (mark) => {
      const { user: markedUser, type } = mark;
      const markCoefficient = type === rate ? 3 : -1;

      markedUser.coins += markCoefficient * costs.createMark;
      await markedUser.save();
      // await this.notificationService.createNotification({
      //   type: NotificationType.PlusCoins,
      //   userId: user.id,
      //   targetId: markedUser.id,
      //   postId: post.id,
      //   markId: mark.id,
      //   coins: markCoefficient * costs.createMark
      // });
    });
    await Promise.all([checkAuthor(), ...checkFeels, ...checkMarks]);
    return {};
  }

  static async getAllUser(body) {
    const { index, count } = { ...body };
    const userTotal = await User.findAll({
      order: [['id', 'DESC']],
      limit: count,
      offset: index
    });
    const users = [];
    for (const e of userTotal) {
      const user = e.toJSON();
      users.push(user);
    }
    console.log(users);
    const total = await User.count({ where: { status: { [sequelize.Op.ne]: null } } });
    console.log(total);
    return {
      total,
      user: users.map((user) => ({
        id: String(user.id),
        name: user.username,
        avatar: user.avatar,
        phoneNumber: user.phoneNumber,
        email: user.email,
        status: user.status,
        coins: user.coins
        // banned: getBanned(post),
      }))
    };
  }

  static async getAllGroup(body) {
    const { index, count } = { ...body };
    const groupTotal = await Group.findAll({
      order: [['id', 'DESC']],
      include: [{ model: User, as: 'members', attributes: ['id', 'avatar', 'username', 'email', 'phoneNumber'] }],
      limit: count,
      offset: index
    });
    const groups = [];
    for (const e of groupTotal) {
      const group = e.toJSON();
      groups.push(group);
    }
    console.log(groups);
    const total = await Group.count({ where: { groupName: { [sequelize.Op.ne]: null } } });
    console.log(total);
    return {
      total,
      group: groups.map((group) => ({
        id: String(group.id),
        name: group.groupName,
        description: group.description,
        coverPhoto: group.coverPhoto,
        member: group.members.map((member) => ({
          id: member.id,
          userName: member.userName,
          email: member.email,
          phoneNumber: member.phoneNumber,
          avatar: member.avatar
        }))
        // banned: getBanned(post),
      }))
    };
  }
}
