import { Router } from 'express';

import { VideoController } from './video.controller.js';

const router = Router();

router.get('/', VideoController.getVideo);

export const videoRouter = router;
