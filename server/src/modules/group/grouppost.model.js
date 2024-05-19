// import { DataTypes } from 'sequelize';

// import { postgre } from '#dbs';
// import { logger } from '#utils';

// export const PostGroup = postgre.define('PostGroup', {
//   id: {
//     allowNull: false,
//     type: DataTypes.INTEGER,
//     primaryKey: true,
//     autoIncrement: true
//   },
//   postId: {
//     type: DataTypes.INTEGER
//   },
//   groupId: {
//     type: DataTypes.INTEGER,
//     allowNull: true
//   }
// });

// (() => {
//   PostGroup.sync({ alter: true }).then(() => logger.info("Table 'PostGroup' synced!"));
// })();
