import { fakerVI as faker } from '@faker-js/faker';
import bcryptjs from 'bcryptjs';

import { User } from '../modules/user/user.model.js';

export const seedUsers = async (numUsers = 15) => {
  const users = [];

  for (let idx = 0; idx < numUsers; idx++) {
    const user = await User.create({
      avatar: faker.image.avatar(),
      phoneNumber: faker.phone.number(),
      email: faker.internet.email({ provider: 'gmail.com' }),
      password: await bcryptjs.hash('123123', 10),
      username: faker.person.fullName(),
      status: 1,
      coins: faker.number.int(200)
    });

    users.push(user);
  }

  await Promise.all(users).catch((err) => {
    console.error(err);
    throw err;
  });

  console.log('User seeding completed!');
};
