import request from 'supertest';

import { app } from '##/app';

describe('Server', () => {
  describe('Check health', () => {
    test('should respond with a 200 status code', async () => {
      const response = await request(app).get('/health');

      expect(response.statusCode).toBe(200);
    });
  });
});
