import { Router } from 'express';

import { MediaControllers } from './media.controller.js';

import { isAuthenticated, uploadAudio, uploadImage, uploadVideo } from '#middlewares';

const router = Router();

router.post('/images', uploadImage.array('images'), MediaControllers.uploadImages);

router.delete('/images/:filename', MediaControllers.deleteImage);

router.post('/videos', uploadVideo.array('videos'), MediaControllers.uploadVideos);

router.delete('/videos/:filename', MediaControllers.deleteVideo);

router.post('/audios', uploadAudio.array('audios'), MediaControllers.uploadAudios);

router.delete('/audios/:filename', MediaControllers.deleteAudio);

router.get('/videos', MediaControllers.getVideo);

router.get('/images/:fileName', MediaControllers.getImage);
// router.delete('/:path', UploadControllers.deleteFile);
router.post('/create_media', isAuthenticated, MediaControllers.createMedia);

router.get('/get_list_media', isAuthenticated, MediaControllers.getListMedia);

router.delete('/delete_media', isAuthenticated, MediaControllers.deleteMedia);
export const mediaRouter = router;
