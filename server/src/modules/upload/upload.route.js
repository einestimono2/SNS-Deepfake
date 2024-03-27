import { Router } from 'express';

import { UploadControllers } from './upload.controller.js';

import { uploadImage, uploadVideo } from '#middlewares';

const router = Router();

router.post('/images', uploadImage.array('images'), UploadControllers.uploadImages);

router.delete('/images/:filename', UploadControllers.deleteImage);

router.post('/videos', uploadVideo.array('videos'), UploadControllers.uploadVideos);

router.delete('/videos/:filename', UploadControllers.deleteVideo);

// router.delete('/:path', UploadControllers.deleteFile);

export const uploadRouter = router;
