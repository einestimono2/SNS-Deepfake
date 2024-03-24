import { app } from '##/app';
import request from 'supertest';

describe('Server', () => {
  describe('Check health', () => {
    test('should respond with a 200 status code', async () => {
      const response = await request(app).get('/health');

      expect(response.statusCode).toBe(200);
    });
  });
});
