// import { app } from '##/app';
// import request from 'supertest';

// describe('User API', () => {
//   describe('POST /users', () => {
//     describe('when passed a username and password', () => {
//       test('should respond with a 200 status code', async () => {
//         const response = await request(app).post('/users').send({
//           username: 'username',
//           password: 'password'
//         });
//         expect(response.statusCode).toBe(200);
//       });

//       test('should specify json as the content type in the http header', async () => {
//         const response = await request(app).post('/users').send({
//           username: 'username',
//           password: 'password'
//         });
//         expect(response.headers['content-type']).toEqual(expect.stringContaining('json'));
//       });

//       test('should contain a userId in the response body', async () => {
//         const response = await request(app).post('/users').send({
//           username: 'username',
//           password: 'password'
//         });
//         expect(response.body.userId).toBeDefined();
//       });
//     });

//     // -----
//     describe('when the username or password is missing', () => {
//       describe('when the username or password is missing', () => {
//         test('should return a 400 status code', async () => {
//           const bodies = [{ username: 'username' }, { password: 'password' }, {}];

//           for (const body of bodies) {
//             const response = await request(app).post('/users').send(body);
//             expect(response.statusCode).toBe(400);
//           }
//         });
//       });
//     });
//   });
// });
