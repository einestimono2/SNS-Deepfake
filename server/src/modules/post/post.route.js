import { Router } from 'express';

import { PostControllers } from './post.controller.js';

import { isAuthenticated } from '#middlewares';

const router = Router();
router.post('/add_post', isAuthenticated, PostControllers.addPost);
router.get('/get_post/:postId', isAuthenticated, PostControllers.getPost);
// router.get('/get_list_posts', isAuthenticated, PostControllers.getListPosts);
// router.put('/edit_post', isAuthenticated, PostControllers.editPost);
// router.delete('/delete_post', isAuthenticated, PostControllers.deletePost);
// router.post('/report_post', isAuthenticated, PostControllers.reportPost);
// router.post('/check_verify_code', PostControllers.checkVerifyCode);
// router.post('/logout', PostControllers.logout);

export const postRouter = router;
