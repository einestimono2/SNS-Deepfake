import { ApiKey } from './api_key.model.js';

export class ApiKeyServices {
  static async createApiKey({ name, status, permissions, expires }) {
    const apiKey = await ApiKey.create({
      name,
      status,
      permissions,
      expires
    });

    return apiKey;
  }

  static async updateApiKey(id, newData) {
    await ApiKey.update(newData, {
      where: {
        key: id
      }
    });
  }

  static async deleteApiKey(id) {
    await ApiKey.destroy({
      where: {
        key: id
      }
    });
  }

  static async getApiKeys() {
    const apiKeys = await ApiKey.findAndCountAll({
      distinct: true
    });

    return {
      apiKeys: apiKeys.rows,
      totalCount: apiKeys.count
    };
  }

  static getApiKeyDetails = async (id) => {
    const apiKey = await ApiKey.findByPk(id);

    return apiKey;
  };
}
