import { Router } from 'express';

import { AdminControllers } from './admin.controller.js';

import { Roles } from '#constants';
import { authorizeRoles, isAuthenticated } from '#middlewares';

const router = Router();
// Đăng nhập với admin
router.post('/login', AdminControllers.login);

// Lấy danh sách các bài post
router.get('/list', isAuthenticated, authorizeRoles(Roles.Admin), AdminControllers.getPosts);
// Lấy danh sách các người dùng
router.get('/list', isAuthenticated, authorizeRoles(Roles.Admin), AdminControllers.getUsers);

router
  .route('/details/:id')
  .put(isAuthenticated, authorizeRoles(Roles.Admin), AdminControllers.updateRole)
  .delete(isAuthenticated, authorizeRoles(Roles.Admin), AdminControllers.deletePost)
  .get(isAuthenticated, authorizeRoles(Roles.Admin), AdminControllers.getUser);
export const adminRouter = router;
