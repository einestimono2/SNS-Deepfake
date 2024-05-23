import { DataTypes } from 'sequelize';

import { Comment } from '../comment/comment.model.js';
import { User } from '../user/user.model.js';

import { Category } from './models/category.model.js';
import { Feel } from './models/feel.model.js';
import { Mark } from './models/mark.model.js';
import { PostHistory } from './models/post.history.js';
import { PostImage } from './models/post_image.model.js';
import { PostVideo } from './models/post_video.model.js';
import { PostView } from './models/post_view.model.js';
import { Report } from './models/report.model.js';
// import { Share } from './models/share.model.js';

// import { Share } from './models/share.model.js';
import { postgre } from '#dbs';
import { logger } from '#utils';

export const Post = postgre.define('Post', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  authorId: {
    type: DataTypes.INTEGER
  },
  description: {
    type: DataTypes.STRING,
    allowNull: true
  },
  status: {
    type: DataTypes.STRING,
    allowNull: true
  },
  edited: {
    type: DataTypes.INTEGER,
    defaultValue: 0
  },
  categoryId: {
    type: DataTypes.INTEGER,
    allowNull: true
  },
  groupId: {
    type: DataTypes.INTEGER,
    allowNull: true
  },
  rate: {
    type: DataTypes.INTEGER,
    allowNull: true
  },
  numberOfShared: {
    type: DataTypes.INTEGER,
    defaultValue: 0
  }
});

(() => {
  // Định nghĩa các mối quan hệ
  // User ---sở hữu---*> Post(quan hệ 1-n)
  Post.belongsTo(User, { foreignKey: 'authorId', as: 'author', onDelete: 'CASCADE' });
  // User ---có loại---> Post(quan hệ 1 - 1)
  Post.belongsTo(Category, { foreignKey: 'categoryId', as: 'category', onDelete: 'SET NULL' });
  // Post ---có ---*> PostImage(quan hệ 1 - n)
  Post.hasMany(PostImage, { foreignKey: 'postId', as: 'images', onDelete: 'CASCADE' });
  // Post ---có ---> PostVideo(quan hệ 1 - 1)
  Post.hasMany(PostVideo, { foreignKey: 'postId', as: 'videos', onDelete: 'CASCADE' });
  // Post ---có ---*> Feel(quan hệ 1 - n)
  Post.hasMany(Feel, { foreignKey: 'postId', as: 'feels', onDelete: 'CASCADE' });
  Feel.belongsTo(Post, { foreignKey: 'postId', as: 'post', onDelete: 'CASCADE' });
  // Post ---có ---*> Mark(quan hệ 1 - n)
  Post.hasMany(Mark, { foreignKey: 'postId', as: 'marks', onDelete: 'CASCADE' });
  Mark.belongsTo(Post, { foreignKey: 'postId', as: 'post', onDelete: 'CASCADE' });
  // Post ---có ---*> Report(quan hệ 1 - n)
  Post.hasMany(Report, { foreignKey: 'postId', as: 'reports', onDelete: 'CASCADE' });
  // Post ---có ---*> PostHistory(quan hệ 1 - n)
  Post.hasMany(PostHistory, { foreignKey: 'postId', as: 'histories', onDelete: 'CASCADE' });
  // Post ---có ---*> PostView(quan hệ 1 - n)
  Post.hasMany(PostView, { foreignKey: 'postId', as: 'views', onDelete: 'CASCADE' });
  Mark.hasMany(Comment, { onDelete: 'CASCADE', foreignKey: 'markId', as: 'comments' });
  Comment.belongsTo(Mark, { onDelete: 'CASCADE', foreignKey: 'markId', as: 'mark' });
  // Post ---có ---*> Share(quan hệ 1 - n)
  // Post.hasMany(Share, { foreignKey: 'postId', as: 'shares', onDelete: 'CASCADE' });
  Post.sync({ alter: true }).then(() => logger.info("Table 'Post' synced!"));
})();
