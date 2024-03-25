import { CatchAsyncError } from '#middlewares';

import { ApiKeyServices } from './api_key.service.js';

export class ApiKeyControllers {
  static createApiKey = CatchAsyncError(async (req, res) => {
    const apiKey = await ApiKeyServices.createApiKey(req.body);

    res.created({
      data: apiKey
    });
  });

  static updateApiKey = CatchAsyncError(async (req, res) => {
    await ApiKeyServices.updateApiKey(req.params.id, req.body);

    res.created();
  });

  static deleteApiKey = CatchAsyncError(async (req, res) => {
    await ApiKeyServices.deleteApiKey(req.params.id);

    res.ok();
  });

  static getApiKeys = CatchAsyncError(async (req, res) => {
    const { apiKeys, totalCount } = await ApiKeyServices.getApiKeys();

    res.ok({
      data: apiKeys,
      extra: {
        totalCount
      }
    });
  });

  // static getApiKeyDetails = CatchAsyncError(async (req, res, next) => {});
}
