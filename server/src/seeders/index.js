/* eslint-disable import/order */
import { postgre, postgreDb } from '#dbs';
import dotenv from 'dotenv';
import { seedUsers } from './user.seeder.js';

try {
  //! Cấu hình env
  dotenv.config();

  // Sync
  await postgreDb.testConnect();
  await postgre.sync();

  // Execute the user seeder
  await seedUsers(1);
} catch (error) {
  console.error('Error seeding user:', error);
  process.exit(1);
}

process.exit(0);
