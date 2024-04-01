import { DataTypes } from 'sequelize';

import { postgre } from '#dbs';
import { logger } from '#utils';

export const Mark = postgre.define('Mark', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  postId: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  content: {
    type: DataTypes.TEXT,
    allowNull: false
  },
  type: {
    type: DataTypes.SMALLINT,
    allowNull: false
  },
  editable: {
    type: DataTypes.BOOLEAN,
    defaultValue: false // Giá trị mặc định cho trường editable là false
  },
  userId: {
    type: DataTypes.INTEGER,
    allowNull: false
  }
});

(() => {
  // Code here
  Mark.sync({ alter: true }).then(() => logger.info("Table 'Mark' synced!"));
})();
