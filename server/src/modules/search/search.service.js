import sequelize, { Op } from 'sequelize';

import { Block } from '../block/block.model.js';
import { Comment } from '../comment/comment.model.js';
import { BadRequestError } from '../core/error.response.js';
import { Friend } from '../friend/friend.model.js';
import { Feel } from '../post/models/feel.model.js';
import { Mark } from '../post/models/mark.model.js';
import { PostImage } from '../post/models/post_image.model.js';
import { PostVideo } from '../post/models/post_video.model.js';
import { Post } from '../post/post.model.js';
import { User } from '../user/user.model.js';

import { Search } from './search.model.js';

import { Message } from '#constants';

export class SearchServices {
  // Tìm kiếm bài viết
  static async searchPost(userId, body) {
    const usersIdBlocked = await Block.findAll({
      where: { userId },
      attributes: ['targetId']
    });
    // Danh sach các userId mà bị mình blocgettargetId
    const usersIdBlocking = await Block.findAll({
      where: { targetId: userId },
      attributes: ['userId']
    });
    // Lưu thông tin tìm kiếm vào cơ sở dữ liệu
    const { index, count } = { ...body };
    let { keyword } = { ...body };
    const search = await Search.create({
      keyword,
      userId
    });
    // Tìm kiếm
    keyword = keyword.trim().replace(/\s+/g, '|');
    const posts = await Post.findAll({
      include: [
        {
          model: User,
          as: 'author',
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
          as: 'images'
        },
        {
          model: PostVideo,
          as: 'video'
        },
        {
          model: Feel,
          as: 'feels',
          // attributes: [],
          where: { userId },
          required: false
        }
      ],
      attributes: {
        include: [
          [
            sequelize.literal(
              `ts_rank_cd(to_tsvector('english', "Post"."description"), to_tsquery('english', '${keyword}'))`
            ),
            'rank'
          ]
          // [sequelize.literal('(SELECT COUNT(*) FROM Feels WHERE Feel.postId = Post.id)'), 'feelsCount'],
          // [sequelize.literal('(SELECT COUNT(*) FROM Marks WHERE Mark.postId = Post.id)'), 'marksCount']
        ]
      },
      where: sequelize.literal(
        ' ts_rank_cd(to_tsvector(\'english\', "Post"."description"), to_tsquery(\'english\', :keyword)) > 0'
      ),
      replacements: { keyword },
      order: [
        ['rank', 'DESC'],
        ['id', 'DESC']
      ],
      offset: index,
      limit: count,
      subQuery: false
    });
    // Lấy số lượng bình luận cho mỗi bài viết
    for (const post of posts) {
      const commentsCount = await Comment.count({
        include: [
          {
            model: Mark,
            where: { postId: post.id }
          }
        ]
      });
      post.commentsCount = commentsCount;
      // await post.save();
    }
    console.log(posts);
    // Trả về kết quả được định dạng
    return posts.map((post) => ({
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
      feel: String(post.feels.length),
      // mark_comment: String(post.marks.length + post.commentsCount),
      is_felt: post.feels.length > 0 ? '1' : '0',
      state: post.status || '',
      author: {
        id: String(post.author.id),
        name: post.author.username || '',
        avatar: post.author.avatar
      }
    }));
  }

  // Tìm kiếm người dùng
  static async searchUser(userId, body) {
    const { index, count } = { ...body };
    let { keyword } = { ...body };
    // Lưu thông tin tìm kiếm vào cơ sở dữ liệu
    const search = await Search.create({
      keyword,
      userId
    });
    // Tìm kiếm
    keyword = keyword.trim().replace(/\s+/g, '|');
    const users = await User.findAll({
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
        },
        {
          model: Friend,
          as: 'friends',
          // attributes: [],
          required: false,
          include: [
            {
              model: User,
              // attributes: [],
              as: 'target',
              include: [
                {
                  model: Friend,
                  as: 'friends',
                  where: { targetId: userId },
                  // attributes: []
                  required: false
                }
              ]
            }
          ]
        }
      ],
      attributes: {
        include: [
          [
            sequelize.literal(
              `ts_rank_cd(to_tsvector('english', "User"."username"), to_tsquery('english', '${keyword}'))`
            ),
            'rank'
          ]
        ]
      },
      where: sequelize.literal(
        'ts_rank_cd(to_tsvector(\'english\', "User"."username"), to_tsquery(\'english\', :keyword)) > 0'
      ),
      replacements: { keyword },
      order: [
        // [sequelize.literal('rank'), 'DESC'],
        ['lastActive', 'DESC'],
        ['id', 'DESC']
      ],
      offset: index,
      limit: count,
      subQuery: false
    });
    console.log(users);
    // Trả về kết quả được định dạng
    return users.map((user) => ({
      id: String(user.id),
      username: user.username || '',
      avatar: user.avatar,
      created: user.createdAt,
      same_friends: String(user.friends.length)
    }));
  }

  // Lấy danh sách các tìm kiếm(Đã test)
  static async getSavedSearches(userId, body) {
    const { index, count } = { ...body };
    const searches = await Search.findAll({
      where: { userId },
      order: [['id', 'DESC']],
      offset: index,
      limit: count
    });
    return searches.map((search) => ({
      id: String(search.id),
      keyword: search.keyword,
      created: search.createdAt
    }));
  }

  // Xóa tìm kiếm(Đã test)
  static async deleteSavedSearch(userId, body) {
    const { searchId, all } = { ...body };
    // Nếu chọn xóa tất cả
    if (all) {
      await Search.destroy({ where: { userId } });
    } else {
      await Search.destroy({ where: { userId, id: searchId } });
    }
    return {};
  }

  // Tìm kiếm theo hashtage(mặc đinh hashtag năm trong mô tả bài viết)
  static async searchHashtag(userId, params, body) {
    const { index, count } = { ...params };
    const { hashtag } = { ...body };
    const HashTagRegex = /^#[^\s]+$/;
    if (!HashTagRegex.test(hashtag)) throw new BadRequestError(Message.HASHTAGE_IS_INVALID);
    // Danh sach các userId mà block mình
    const usersIdBlocked = await Block.findAll({
      where: { userId },
      attributes: ['targetId']
    });
    // Danh sach các userId mà bị mình blocgettargetId
    const usersIdBlocking = await Block.findAll({
      where: { targetId: userId },
      attributes: ['userId']
    });
    const posts = await Post.findAll({
      where: {
        description: {
          [Op.like]: sequelize.literal(`'%${hashtag}%'`) // Sử dụng sequelize.literal để tạo biểu thức tìm kiếm
        }
      },
      include: [
        {
          model: User,
          as: 'author',
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
          as: 'images'
        },
        {
          model: PostVideo,
          as: 'video'
        },
        {
          model: Feel,
          as: 'feels',
          // attributes: [],
          where: { userId },
          required: false
        }
      ],
      order: [['id', 'DESC']],
      offset: index,
      limit: count
    });
    console.log(posts);
    // Lấy số lượng bình luận cho mỗi bài viết
    for (const post of posts) {
      const commentsCount = await Comment.count({
        include: [
          {
            model: Mark,
            as: 'mark',
            where: { postId: post.id }
          }
        ]
      });
      post.commentsCount = commentsCount;
      // await post.save();
    }
    console.log(posts);
    // Trả về kết quả được định dạng
    return posts.map((post) => ({
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
      feel: String(post.feels.length),
      // mark_comment: String(post.marks.length + post.commentsCount),
      is_felt: post.feels.length > 0 ? '1' : '0',
      state: post.status || '',
      author: {
        id: String(post.author.id),
        name: post.author.username || '',
        avatar: post.author.avatar
      }
    }));
  }
}
