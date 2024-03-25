import { app } from '##/app';
import request from 'supertest';

describe('Api Key API', () => {
  const created = [];

  describe('POST - Tạo api key', () => {
    const url = '/api/v1/apikey/create';

    // ----- Test 01 -----
    describe('Đầy đủ các trường bắt buộc', () => {
      test('Tạo thành công với status code 201', async () => {
        const response = await request(app).post(url).send({
          name: 'test'
        });

        expect(response.statusCode).toBe(201);

        if (response.status === 'success') {
          created.push(response.body.data.key);
        }
      });

      test("Response body có chứa trường 'key'", async () => {
        const response = await request(app).post(url).send({
          name: 'test'
        });

        expect(response.body.data.key).toBeDefined();

        if (response.status === 'success') {
          created.push(response.body.data.key);
        }
      });
    });

    // ----- Test 02 -----
    describe('Thiếu trường bắt buộc', () => {
      describe("Thiếu trường 'name'", () => {
        test('Lỗi thiếu trường với status code 400', async () => {
          const bodies = [{}];

          for (const body of bodies) {
            const response = await request(app).post(url).send(body);

            expect(response.statusCode).toBe(400);
          }
        });
      });
    });
  });

  describe('DELETE - Xóa api key', () => {
    const url = '/api/v1/apikey/details';

    // ----- Test 01 -----
    describe('Key hợp lệ', () => {
      test('Xóa thành công với status code 200', async () => {
        for (const key of created) {
          const response = await request(app).delete(`${url}/${key}`);

          expect(response.statusCode).toBe(200);
        }
      });
    });

    // ----- Test 02 -----
    describe('Key không hợp lệ hoặc null', () => {
      test('Lỗi với status code 400', async () => {
        const response = await request(app).delete(`${url}/2222xxx`);

        expect(response.statusCode).toBe(400);
      });
    });
  });
});
