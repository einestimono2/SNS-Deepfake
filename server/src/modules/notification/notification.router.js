import { Router } from 'express';

import { CommentControllers } from './comment.controller.js';

import { isAuthenticated } from '#middlewares';

const router = Router();
router.get('/get_mark_comment', isAuthenticated, CommentControllers.getMarkComment);
router.post('/set_mark_comment', isAuthenticated, CommentControllers.setMarkComment);
router.post('/feel', isAuthenticated, CommentControllers.unBlock);
router.post('/get_list_feels', isAuthenticated, CommentControllers.unBlock);
router.post('/delete_feel', isAuthenticated, CommentControllers.unBlock);
export const commentRouter = router;
