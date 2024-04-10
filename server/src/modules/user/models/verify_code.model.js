import { DataTypes } from 'sequelize';

import { VerifyCodeStatus } from '#constants';
import { postgre } from '#dbs';
import { logger } from '#utils';

export const VerifyCode = postgre.define('VerifyCode', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  userId: {
    type: DataTypes.INTEGER
  },
  code: {
    type: DataTypes.STRING
  },
  expiredAt: {
    type: DataTypes.DATE
  },
  status: {
    type: DataTypes.INTEGER,
    defaultValue: VerifyCodeStatus.Active
  }
});

(() => {
  VerifyCode.sync({ alter: true }).then(() => logger.info("Table 'VerifyCode' synced!"));
})();
