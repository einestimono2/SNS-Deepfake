import { DataTypes } from 'sequelize';

import { User } from '../user/user.model.js';

import { SearchType } from '#constants';
import { postgre } from '#dbs';
import { logger } from '#utils';

export const Search = postgre.define('Search', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  userId: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  keyword: {
    type: DataTypes.STRING,
    allowNull: false
  },
  type: {
    type: DataTypes.ENUM,
    values: Object.values(SearchType),
    defaultValue: SearchType.User
  }
});

(() => {
  // Code here
  // Tạo mối quan hệ với mô hình User
  Search.belongsTo(User, { foreignKey: 'userId', onDelete: 'CASCADE' });
  Search.sync({ alter: true }).then(() => logger.info("Table 'Search' synced!"));
})();
