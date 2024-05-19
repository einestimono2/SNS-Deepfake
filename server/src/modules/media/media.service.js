import { UnauthorizedError } from '../core/error.response.js';
import { User } from '../user/user.model.js';

import { Media } from './media.model.js';

import { Message } from '#constants';

export class MediaService {
  // Tạo danh sách các đầu vào
  static async createMedia(userId, fileList) {
    const newMedia = [];
    for (const file of fileList) {
      const { fileName, size, url, fileType, thumbnailUrl, description } = { ...file };
      if (!userId) throw new UnauthorizedError(Message.USER_IS_INVALID);
      const media = await Media.create({
        fileName,
        size,
        url,
        fileType,
        thumbnailUrl,
        description,
        userId
      });
      media.push(media.toJSON());
    }
    // Sau khi tạo dữ liệu cho bảng thì gửi data cho server AI xử lý
    // await axios.post('url_cua_server_AI', {
    //   fileList,
    //   userId
    // });
    return newMedia;
  }

  // Lấy thông tin video mà server deepfake trả về
  // static async getVideoDeepfakeInfo(videoId) {
  //   const deepfakeServerUrl = 'https://api.deepfakeserver.com/videos';
  //   try {
  //     const response = await axios.get(`${deepfakeServerUrl}/${videoId}`);
  //     return response.data;
  //   } catch (error) {
  //     console.error('Error fetching video info:', error);
  //     throw new Error('Failed to fetch video info');
  //   }
  // }

  // Lấy danh sách các video deepfake của một một ai đó
  // static async getListVideoDeepfake(userId) {
  //   const deepfakeServerUrl = 'https://api.deepfakeserver.com/videos';
  //   try {
  //     const response = await axios.get(`${deepfakeServerUrl}`);
  //     return response.data;
  //   } catch (error) {
  //     console.error('Error fetching video info:', error);
  //     throw new Error('Failed to fetch video info');
  //   }
  // }

  // Lấy danh sách các media liên quan tới người dùng
  static async getListMedia(userId, body) {
    const { index, count } = { ...body };
    if (!userId) throw new UnauthorizedError(Message.USER_IS_INVALID);
    const listMedia = await Media.findAll({
      where: { userId },
      include: [
        {
          model: User,
          as: 'user'
        }
      ],
      order: [['id', 'DESC']],
      offset: index,
      limit: count
    });
    const medias = [];
    for (const e of listMedia) {
      const media = e.toJSON();
      medias.push(media);
    }
    console.log(medias);
    return {
      media: medias.map((media) => ({
        media
      }))
    };
  }

  static async getMediaById(req) {
    const { id } = req.params;
    // Danh sách các thành viên
    let media = await Media.findOne({
      where: { id },
      include: [
        // Thông tin người gửi
        {
          model: User,
          as: 'user'
        }
      ]
    });
    console.log(media.toJSON);
    media = media.toJSON;
    return {
      media
    };
  }

  // Xóa thông tin
  static async deleteMedia(userId, mediaId) {
    if (!userId) throw new UnauthorizedError(Message.USER_IS_INVALID);
    const media = await Media.findOne({
      where: {
        userId,
        id: mediaId
      }
    });
    if (media) {
      await media.destroy();
    }
    return {};
  }
}
