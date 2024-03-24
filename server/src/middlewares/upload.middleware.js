import multer from 'multer';

import { diskStorage, imageFilter, memoryStorage } from '#configs';
import { avatarAccepted } from '#constants';

export const uploadImage = multer({
  storage: diskStorage,
  fileFilter: imageFilter,
  limits: { fileSize: avatarAccepted.fileMaxSize }
});

export const uploadMemory = multer({ storage: memoryStorage });
