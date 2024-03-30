import fs from 'fs';

import { NotFoundError } from '../core/index.js';

import { Message } from '#constants';
import { getStandardPath } from '#utils';

export class UploadControllers {
  //
  static uploadImages = async (req, res, next) => {
    console.log(req);
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
    // console.log(files);
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

  // static deleteFile = async (req, res, next) => {
  //   if (!req.params.path) {
  //     next(new NotFoundError(Message.PATH_EMPTY));
  //     return;
  //   }

  //   const _path = req.params.filename.split('/');
  //   console.log(_path);

  //   fs.unlink(getStandardPath(`../../uploads/${_path}`), (err) => {
  //     if (err !== null) {
  //       next(new NotFoundError(Message.VIDEO_NOT_FOUND));
  //       return;
  //     }

  //     res.ok();
  //   });
  // };
}
