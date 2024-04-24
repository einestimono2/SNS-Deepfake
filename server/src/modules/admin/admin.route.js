import { Router } from 'express';

import { AdminControllers } from './admin.controller.js';

// import { Roles } from '#constants';
// import { authorizeRoles, isAuthenticated } from '#middlewares';

const router = Router();
// Đăng nhập với admin
router.post('/login', AdminControllers.login);
router.get('/get_all_post', AdminControllers.getAllPosts);
router.post('/rate_post', AdminControllers.ratePost);

router.get('/get_all_user', AdminControllers.getAllUser);
router.get('/get_all_group', AdminControllers.getAllGroup);
// Lấy danh sách các bài post
router.get('/get_all_post', AdminControllers.getAllPost);
router.post('/rate_post', AdminControllers.ratePost);
router.get('/get_all_user', AdminControllers.getAllUser);
router.get('/get_all_group', AdminControllers.getAllGroup);

// Lấy danh sách các người dùng
// router.get('/list', isAuthenticated, authorizeRoles(Roles.Admin), AdminControllers.getUsers);

// router
//   .route('/details/:id')
//   .put(isAuthenticated, authorizeRoles(Roles.Admin), AdminControllers.updateRole)
//   .delete(isAuthenticated, authorizeRoles(Roles.Admin), AdminControllers.deletePost)
//   .get(isAuthenticated, authorizeRoles(Roles.Admin), AdminControllers.getUser);
export const adminRouter = router;
