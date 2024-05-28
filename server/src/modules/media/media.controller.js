import fs from 'fs';

import { NotFoundError } from '../core/index.js';

import { MediaService } from './media.service.js';

import { Message } from '#constants';
import { CatchAsyncError } from '#middlewares';
import { getPaginationAttributes, getPaginationSummary, getStandardPath } from '#utils';

export class MediaControllers {
  //
  static uploadImages = async (req, res, next) => {
    if (!req.files?.length) {
      next(new NotFoundError(Message.IMAGE_EMPTY));
      return;
    }

    const files = [];
    for (const file of req.files) {
      files.push({
        path: `/resources/images/${file.filename}`,
        name: file.filename
      });
    }

    res.created({
      data: files.length === 1 ? files[0] : files
    });
  };

  static deleteImage = async (req, res, next) => {
    if (!req.params.filename) {
      next(new NotFoundError(Message.IMAGE_EMPTY));
      return;
    }

    fs.unlink(getStandardPath(`../../uploads/images/${req.params.filename}`), (err) => {
      if (err !== null) {
        next(new NotFoundError(Message.IMAGE_NOT_FOUND));
        return;
      }
      res.ok();
    });
  };

  static uploadVideos = async (req, res, next) => {
    if (!req.files?.length) {
      next(new NotFoundError(Message.VIDEO_EMPTY));
      return;
    }

    const files = [];
    for (const file of req.files) {
      files.push({
        path: `/resources/videos/${file.filename}`,
        name: file.filename
      });
    }

    res.created({
      data: files.length === 1 ? files[0] : files
    });
  };

  static deleteVideo = async (req, res, next) => {
    if (!req.params.filename) {
      next(new NotFoundError(Message.VIDEO_EMPTY));
      return;
    }

    fs.unlink(getStandardPath(`../../uploads/videos/${req.params.filename}`), (err) => {
      if (err !== null) {
        next(new NotFoundError(Message.VIDEO_NOT_FOUND));
        return;
      }

      res.ok();
    });
  };

  // Cho phép upload nhiều file
  static uploadAudios = async (req, res, next) => {
    console.log(req);
    if (!req.files?.length) {
      next(new NotFoundError(Message.AUDIO_EMPTY));
      return;
    }
    const files = [];
    for (const file of req.files) {
      files.push({
        path: `/resources/audios/${file.filename}`,
        name: file.filename
      });
    }
    res.created({
      data: files.length === 1 ? files[0] : files
    });
  };

  static deleteAudio = async (req, res, next) => {
    if (!req.params.filename) {
      next(new NotFoundError(Message.AUDIO_EMPTY));
      return;
    }
    fs.unlink(getStandardPath(`../../uploads/audios/${req.params.filename}`), (err) => {
      if (err !== null) {
        next(new NotFoundError(Message.AUDIO_NOT_FOUND));
        return;
      }

      res.ok();
    });
  };

  // Được thiết kế để xử lý yêu cầu phát video từ một đường dẫn tới tập tin video trong ứng dụng(Streaming)
  static getVideo = CatchAsyncError(async (req, res) => {
    const filePath = getStandardPath('../../uploads/videos/4ljkk7-Wada pura kiya  #shorts #funny.mp4');
    const { range } = req.headers;
    if (!range) res.status(400).send('error');

    const videoPath = filePath;
    const videoSize = fs.statSync(videoPath).size;

    const chunkSize = 10 ** 6;
    const start = Number(range.replace(/\D/g, ''));
    const end = Math.min(start + chunkSize, videoSize - 1);
    const contentLength = end - start + 1;
    const headers = {
      'Content-Range': `bytes ${start}-${end}/${videoSize}`,
      'Accept-Ranges': 'bytes',
      'Content-Length': contentLength,
      'Content-Type': 'video/mp4',
      'Cross-Origin-Resource-Policy': 'cross-origin'
    };

    res.writeHead(206, headers);

    const videoStream = fs.createReadStream(videoPath, { start, end });

    videoStream.pipe(res);
  });

  static createMedia = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const media = await MediaService.createMedia(userId, req.body);
    res.created({
      data: media
    });
  });

  static getListMedia = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const result = await MediaService.getListMedia(userId, ...getPaginationAttributes(req.query));
    res.ok(
      getPaginationSummary({
        ...req.query,
        result
      })
    );
  });

  static deleteMedia = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    await MediaService.deleteMedia(userId, req.body);
    res.ok({
      Message: 'Xóa thành công!'
    });
  });
}
