import { Op } from 'sequelize';

import { Comment } from '../comment/comment.model.js';
import { NotFoundError } from '../core/index.js';
import { Group } from '../group/group/group.model.js';
import { PostImage } from '../post/models/post_image.model.js';
import { PostVideo } from '../post/models/post_video.model.js';
import { Post } from '../post/post.model.js';
import { User } from '../user/user.model.js';

import { Message } from '##/constants/message.constant';

export class adminService {
  static getFilter = async (filter, filtersOption) => {
    const result = {};

    for (const [key, value] of Object.entries(filter)) {
      if (filtersOption && filtersOption[key]) {
        Object.assign(result, await filtersOption[key](value));
      } else {
        result[key] = value;
      }
    }

    return result;
  };

  static parseQuery = (query, filtersOption) => {
    const { range, sort, filter } = query;

    const [from, to] = range ? JSON.parse(range) : [0, 10000];

    const where = filter ? JSON.parse(filter) : {};
    // console.log(from, to, where, JSON.parse(sort));
    return {
      offset: from,
      limit: to - from + 1,
      filter: where,
      order: [sort ? JSON.parse(sort) : ['id', 'ASC']]
    };
  };

  static getModel(modelName) {
    if (modelName === 'users') return User;
    if (modelName === 'posts') return Post;
    if (modelName === 'groups') return Group;
    if (modelName === 'comments') return Comment;
    if (modelName === 'post_images') return PostImage;
    if (modelName === 'post_videos') return PostVideo;
    return '';
  }

  static async getOne(model, id) {
    const record = await model.findOne({
      where: { id }
    });

    return record;
  }

  static async getList(model, limit, offset, filter, order) {
    const whereClause = {
      [Op.and]: filter
        ? Object.entries(filter).map(([key, value]) => ({
            [key]: value // Use 'like' operator for partial matching
          }))
        : []
    };

    const records = await model.findAll({
      limit,
      offset,
      where: whereClause,
      order
    });

    const count = await model.count({ where: whereClause });

    if (!records) throw new NotFoundError(Message.NO_ENOUGH_INFORMATION);

    return { rows: records, count };
  }

  static async create(model, body) {
    const record = await model.create(body);
    return record;
  }

  static async update(model, id, body) {
    const record = await model.findOne({ where: { id } });
    if (!record) throw new NotFoundError(Message.NO_ENOUGH_INFORMATION);

    for (const key in body) {
      if (Object.prototype.hasOwnProperty.call(body, key)) {
        record[key] = body[key];
      }
    }

    await record.save();

    return record;
  }

  static async delete(model, id) {
    const record = await model.findOne({ where: { id } });
    if (!record) throw new NotFoundError(Message.NO_ENOUGH_INFORMATION);
    await record.destroy();
    return record;
  }

  static _setExposeHeaders = (res) => {
    const rawValue = res.getHeader('Access-Control-Expose-Headers') || '';
    if (typeof rawValue !== 'string') {
      return;
    }

    const headers = new Set(
      rawValue
        .split(',')
        .map((header) => header.trim())
        .filter((header) => Boolean(header))
    );

    headers.add('Content-Range');
    headers.add('X-Total-Count');
    res.header('Access-Control-Expose-Headers', [...headers].join(', '));
  };

  static setGetListHeaders = (res, offset, total, rowsCount) => {
    this._setExposeHeaders(res);
    res.header('Content-Range', `${offset}-${offset + rowsCount}/${total}`);
    res.header('X-Total-Count', `${total}`);
  };
}
