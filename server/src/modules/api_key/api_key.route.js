import { Router } from 'express';

import { ApiKeyControllers } from './api_key.controller.js';

const router = Router();

// - [POST] Add
router.post('/create', ApiKeyControllers.createApiKey);

// - [GET] List
router.get('/list', ApiKeyControllers.getApiKeys);

router
  .route('/details/:id')
  // [GET] Details
  // .get()
  // [PATCH] Update
  .patch(ApiKeyControllers.updateApiKey)
  // [DELETE] Delete
  .delete(ApiKeyControllers.deleteApiKey);

export const apiKeyRouter = router;
