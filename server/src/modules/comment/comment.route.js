import { Router } from 'express';

import { CommentControllers } from './comment.controller.js';

import { isAuthenticated } from '#middlewares';

const router = Router();
router.get('/get_mark_comment/:postId', isAuthenticated, CommentControllers.getMarkComment);
router.post('/set_mark_comment/:postId', isAuthenticated, CommentControllers.setMarkComment);
router.post('/feel/:postId', isAuthenticated, CommentControllers.feel);
router.get('/get_list_feels/:postId', isAuthenticated, CommentControllers.getListFeels);
router.delete('/delete_feel/:postId', isAuthenticated, CommentControllers.deleteFeel);
export const commentRouter = router;
