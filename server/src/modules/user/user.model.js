import { DataTypes } from 'sequelize';

import { postgre } from '#dbs';
import { logger } from '#utils';

export const User = postgre.define(
  'User',
  {
    id: {
      allowNull: false,
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    role: {
      type: DataTypes.STRING,
      allowNull: false
    },
    avatar: {
      type: DataTypes.STRING
    },
    phone_number: {
      type: DataTypes.STRING,
      allowNull: false
    },
    email: {
      type: DataTypes.STRING,
      allowNull: false
    },
    password: {
      type: DataTypes.STRING,
      allowNull: false
    },
    birthday: {
      type: DataTypes.DATE,
      allowNull: true
    },
    token: {
      type: DataTypes.STRING,
      allowNull: true
    },
    username: {
      type: DataTypes.STRING
    },
    status: {
      type: DataTypes.STRING,
      default: 'active'
    },
    coins: {
      type: DataTypes.STRING
    },
    createdAt: {
      type: DataTypes.DATE,
      allowNull: true
    },
    updatedAt: {
      type: DataTypes.DATE
    },
    family_id: {
      type: DataTypes.INTEGER,
      references: {
        model: 'Families', // Tên bảng tham chiếu
        key: 'id' // Khóa chính tham chiếu
      },
      default: '0'
    }
  },
  {
    // Tùy chọn khác của model User
  }
);
(() => {
  // Code here
  User.sync().then(() => logger.info("Table 'User' synced!"));
})();
