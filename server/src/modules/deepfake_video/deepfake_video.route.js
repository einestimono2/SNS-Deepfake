import { Router } from 'express';

import { DeepfakeVideoControllers } from './deepfake_video.controller.js';

import { isAuthenticated, uploadVideo } from '#middlewares';

const router = Router();

router.post('/create', isAuthenticated, DeepfakeVideoControllers.createDeepfakeVideo);

router.post('/finish', uploadVideo.single('video'), DeepfakeVideoControllers.finishDeepfakeVideo);

router.get('/list', isAuthenticated, DeepfakeVideoControllers.getListDeepfakeVideo);

router.delete('/delete/:id', isAuthenticated, DeepfakeVideoControllers.deleteDeepfakeVideo);

export const deepfakeVideoRouter = router;
