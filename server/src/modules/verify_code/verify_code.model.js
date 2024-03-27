import { DataTypes } from 'sequelize';

import { postgre } from '#dbs';
import { logger } from '#utils';

export const VerifyCode = postgre.define(
  'VerifyCode',
  {
    id: {
      allowNull: false,
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    status: {
      type: DataTypes.STRING,
      allowNull: true
    },
    code: {
      type: DataTypes.STRING,
      allowNull: false
    },
    userID: {
      type: DataTypes.INTEGER,
      references: {
        model: 'Users', // Tên bảng tham chiếu
        key: 'id' // Khóa chính tham chiếu
      }
    },
    expiredAt: {
      type: DataTypes.DATE,
      allowNull: false
    },
    createdAt: {
      type: DataTypes.DATE,
      allowNull: false
    },
    updatedAt: {
      type: DataTypes.DATE
    }
  },
  {
    // Tùy chọn khác của model User
  }
);
(() => {
  // Code here
  VerifyCode.sync().then(() => logger.info("Table 'VerifyCode' synced!"));
})();
