import { DataTypes } from 'sequelize';

import { User } from '../user/user.model.js';

import { Category } from './models/category.model.js';
import { Feel } from './models/feel.model.js';
import { Mark } from './models/mark.model.js';
import { PostHistory } from './models/post.history.js';
import { PostImage } from './models/post_image.model.js';
import { PostVideo } from './models/post_video.model.js';
import { PostView } from './models/post_view.model.js';
import { Report } from './models/report.model.js';

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
  rate: {
    type: DataTypes.INTEGER,
    allowNull: true
  }
});

(() => {
  // Code here
  Post.sync({ alter: true }).then(() => logger.info("Table 'Post' synced!"));
})();

// Định nghĩa các mối quan hệ
// Trả về thông tin tác giả thông qua author
Post.belongsTo(User, { as: 'author', foreignKey: 'authorId', onDelete: 'CASCADE' });
Post.belongsTo(Category, {
  as: 'category',
  foreignKey: 'categoryId',
  onDelete: 'SET NULL'
});
Post.hasMany(PostImage, { foreignKey: 'postId', as: 'images', onDelete: 'CASCADE' });
Post.hasOne(PostVideo, { foreignKey: 'postId', as: 'video', onDelete: 'CASCADE' });
Post.hasMany(Feel, { foreignKey: 'postId', as: 'feels', onDelete: 'CASCADE' });
Post.hasMany(Mark, { foreignKey: 'postId', as: 'marks', onDelete: 'CASCADE' });
Post.hasMany(Report, { foreignKey: 'postId', as: 'reports', onDelete: 'CASCADE' });
Post.hasMany(PostHistory, { foreignKey: 'postId', as: 'histories', onDelete: 'CASCADE' });
Post.hasMany(PostView, { foreignKey: 'postId', as: 'views', onDelete: 'CASCADE' });
