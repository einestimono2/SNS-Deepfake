import { Router } from 'express';

import { MediaControllers } from './media.controller.js';

import { uploadImage, uploadVideo } from '#middlewares';

const router = Router();

router.post('/images', uploadImage.array('images'), MediaControllers.uploadImages);

router.delete('/images/:filename', MediaControllers.deleteImage);

router.post('/videos', uploadVideo.array('videos'), MediaControllers.uploadVideos);

router.delete('/videos/:filename', MediaControllers.deleteVideo);

router.get('/videos', MediaControllers.getVideo);
// router.delete('/:path', UploadControllers.deleteFile);

export const mediaRouter = router;
