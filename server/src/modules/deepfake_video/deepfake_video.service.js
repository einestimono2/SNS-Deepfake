import { UnauthorizedError } from '../core/error.response.js';
import { NotificationServices } from '../notification/notification.service.js';
import { User } from '../user/user.model.js';

import { DeepfakeVideo } from './deepfake_video.model.js';

// import { Media } from './media.model.js';
import { Message } from '#constants';

export class DeepfakeVideoService {
  // Tạo danh sách các đầu vào
  static async createDeepfakeVideo(body) {
    // if (!userId) throw new UnauthorizedError(Message.USER_IS_INVALID);
    const { videoUrl, userId, size } = { ...body };
    console.log(videoUrl);
    let deepfakeVideo = await DeepfakeVideo.create({
      size,
      url: videoUrl,
      userId
    });
    // Thực hiện việc notification
    await NotificationServices.notifyCreateVideo(userId, deepfakeVideo.id);
    deepfakeVideo = deepfakeVideo.toJSON();
    return deepfakeVideo;
  }

  // Lấy danh sách các media liên quan tới người dùng
  static async getListDeepfakeVideo({ userId, offset, limit }) {
    if (!userId) throw new UnauthorizedError(Message.USER_IS_INVALID);
    const deepfakeVideos = await DeepfakeVideo.findAndCountAll({
      where: { userId },
      include: [
        {
          model: User,
          as: 'user',
          attributes: ['id', 'username', 'email', 'avatar', 'coverImage']
        }
      ],
      order: [['id', 'DESC']],
      offset,
      limit
    });
    return {
      rows: deepfakeVideos.rows.map((deepfakeVideo) => ({
        deepfakeVideo
      })),
      count: deepfakeVideos.count
    };
  }

  static async getDeepfakeVideoById(req) {
    const { id } = req.params;
    // Danh sách các thành viên
    let deepfakeVideo = await DeepfakeVideo.findOne({
      where: { id },
      include: [
        // Thông tin người gửi
        {
          model: User,
          as: 'user'
        }
      ]
    });
    console.log(deepfakeVideo.toJSON);
    deepfakeVideo = deepfakeVideo.toJSON;
    return {
      deepfakeVideo
    };
  }

  // Xóa thông tin
  static async deleteDeepfakeVideo(userId, videoId) {
    if (!userId) throw new UnauthorizedError(Message.USER_IS_INVALID);
    const deepfakeVideo = await DeepfakeVideo.findOne({
      where: {
        userId,
        id: videoId
      }
    });
    if (deepfakeVideo) {
      await deepfakeVideo.destroy();
    }
  }
}
