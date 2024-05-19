import multer from 'multer';

import { audioAccepted, imageAccepted, videoAccepted } from '#configs';
import { Message } from '#constants';
import { UnsupportedMediaTypeError } from '#modules';
import { genFilename, getOrCreateDestination } from '#utils';

const memoryStorage = multer.memoryStorage();

const imageStorage = multer.diskStorage({
  destination(_req, _file, callback) {
    callback(null, getOrCreateDestination('../../uploads/images'));
  },
  filename(_req, file, callback) {
    callback(null, genFilename(file));
  }
});

const videoStorage = multer.diskStorage({
  destination(_req, _file, callback) {
    callback(null, getOrCreateDestination('../../uploads/videos'));
  },
  filename(_req, file, callback) {
    callback(null, genFilename(file));
  }
});

const audioStorage = multer.diskStorage({
  destination(_req, _file, callback) {
    callback(null, getOrCreateDestination('../../uploads/audios'));
  },
  filename(_req, file, callback) {
    callback(null, genFilename(file));
  }
});

const imageFilter = (_req, file, callback) => {
  if (imageAccepted.fileTypes.includes(file.mimetype)) {
    callback(null, true);
  } else {
    callback(new UnsupportedMediaTypeError(Message.UNSUPPORTED_IMAGE_FORMAT));
  }
};

const videoFilter = (_req, file, callback) => {
  if (videoAccepted.fileTypes.includes(file.mimetype)) {
    callback(null, true);
  } else {
    callback(new UnsupportedMediaTypeError(Message.UNSUPPORTED_VIDEO_FORMAT));
  }
};
const audioFilter = (_req, file, callback) => {
  if (audioAccepted.fileTypes.includes(file.mimetype)) {
    callback(null, true);
  } else {
    callback(new UnsupportedMediaTypeError(Message.UNSUPPORTED_AUDIO_FORMAT));
  }
};
export const uploadImage = multer({
  storage: imageStorage,
  fileFilter: imageFilter,
  limits: { fileSize: imageAccepted.fileMaxSize }
});

export const uploadVideo = multer({
  storage: videoStorage,
  fileFilter: videoFilter,
  limits: { fileSize: videoAccepted.fileMaxSize }
});

export const uploadAudio = multer({
  storage: audioStorage,
  fileFilter: audioFilter,
  limits: { fileSize: audioAccepted.fileMaxSize }
});

export const uploadMemory = multer({ storage: memoryStorage });
