import { DataTypes } from 'sequelize';

import { User } from '../user/user.model.js';

import { Category } from './category/category.model.js';
import { Feel } from './feel/feel.model.js';
import { Mark } from './mark/mark.model.js';
import { PostHistory } from './post_history/post.history.js';
import { PostImage } from './post_image/post_image.model.js';
import { PostVideo } from './post_video/post_video.model.js';
import { PostView } from './post_view/post_view.model.js';
import { Report } from './report/report.model.js';

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
    type: DataTypes.TEXT,
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
Post.belongsTo(User, { foreignKey: 'authorId', onDelete: 'CASCADE' });
Post.belongsTo(Category, { foreignKey: 'categoryId', onDelete: 'SET NULL' });
Post.hasMany(PostImage, { foreignKey: 'postId', as: 'images', onDelete: 'CASCADE' });
Post.hasOne(PostVideo, { foreignKey: 'postId', as: 'video', onDelete: 'CASCADE' });
Post.hasMany(Feel, { foreignKey: 'postId', as: 'feels', onDelete: 'CASCADE' });
Post.hasMany(Mark, { foreignKey: 'postId', as: 'marks', onDelete: 'CASCADE' });
Post.hasMany(Report, { foreignKey: 'postId', as: 'reports', onDelete: 'CASCADE' });
Post.hasMany(PostHistory, { foreignKey: 'postId', as: 'histories', onDelete: 'CASCADE' });
Post.hasMany(PostView, { foreignKey: 'postId', as: 'views', onDelete: 'CASCADE' });
