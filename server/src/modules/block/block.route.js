import { Router } from 'express';

import { BlockControllers } from './block.controller.js';

import { isAuthenticated } from '#middlewares';

const router = Router();
router.get('/get_list_blocks', isAuthenticated, BlockControllers.getListBlocks);
router.post('/set_block/:targetId', isAuthenticated, BlockControllers.setBlock);
router.post('/unblock/:targetId', isAuthenticated, BlockControllers.unBlock);

export const blockRouter = router;
