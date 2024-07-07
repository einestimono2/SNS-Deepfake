import { Router } from 'express';

import { DeepfakeVideoControllers } from './deepfake_video.controller.js';

import { isAuthenticated } from '#middlewares';

const router = Router();

router.post('/create_deepfakevideo', DeepfakeVideoControllers.createDeepfakeVideo);

router.get('/get_list_deepfakevideo', isAuthenticated, DeepfakeVideoControllers.getListDeepfakeVideo);

router.delete('/delete_deepfakevideo/:videoId', isAuthenticated, DeepfakeVideoControllers.deleteDeepfakeVideo);
export const deepfakeVideoRouter = router;
