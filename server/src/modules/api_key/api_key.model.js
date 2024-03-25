import dayjs from 'dayjs';
import { DataTypes } from 'sequelize';

import { postgre } from '#dbs';
import { logger } from '#utils';

export const ApiKey = postgre.define('ApiKey', {
  key: { type: DataTypes.UUID, allowNull: false, defaultValue: DataTypes.UUIDV4, primaryKey: true },
  name: {
    type: DataTypes.STRING,
    allowNull: false,
    validate: {
      notNull: {
        msg: "[ApiKey] 'name' is required!"
      }
    }
  },
  status: { type: DataTypes.BOOLEAN, allowNull: false, defaultValue: true },
  permissions: {
    type: DataTypes.ARRAY(
      // DataTypes.ENUM({
      //   values: ['user', 'setter', 'admin']
      // })
      DataTypes.STRING
    ),
    allowNull: false,
    defaultValue: []
  },
  expires: {
    type: DataTypes.DATE,
    validate: {
      isAfter: {
        args: dayjs().subtract(1, 'day').format('YYYY-MM-DD'),
        msg: "[ApiKey] 'expires' must be greater than or equal to the current date!"
      }
    }
  }
});

(() => {
  // Code here
  ApiKey.sync().then(() => logger.info("Table 'ApiKeys' synced!"));
})();
