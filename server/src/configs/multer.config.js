import fs from 'fs';
import multer from 'multer';
import path from 'path';

import { Message, avatarAccepted } from '#constants';
import { UnsupportedMediaTypeError } from '#modules';

export const memoryStorage = multer.memoryStorage();

export const diskStorage = multer.diskStorage({
  destination(_req, _file, callback) {
    const uploadsDir = path.join(path.resolve(), '../../uploads');
    if (!fs.existsSync(uploadsDir)) {
      fs.mkdirSync(uploadsDir);
    }

    callback(null, uploadsDir);
  },
  filename(_req, file, callback) {
    const uniqueSuffix = Math.floor(Math.random() * 1e9).toString(36);
    const fileNames = file.originalname.split('.');
    const validName = fileNames[0]
      .toLowerCase()
      .replace(/[^a-z0-9-_\s]/g, '')
      .replace(/\s+/g, '_')
      .substring(0, 50);

    callback(null, `${validName}_${uniqueSuffix}.${fileNames[fileNames.length - 1]}`);
  }
});

export const imageFilter = (_req, file, callback) => {
  if (avatarAccepted.fileTypes.includes(file.mimetype)) {
    callback(null, true);
  } else {
    callback(new UnsupportedMediaTypeError(Message.UNSUPPORTED_IMAGE_FORMAT));
  }
};
