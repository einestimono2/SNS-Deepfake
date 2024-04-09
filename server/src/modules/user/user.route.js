import { Router } from 'express';

import { UserControllers } from './user.controller.js';

import { isAuthenticated } from '#middlewares';

const router = Router();
router.post('/register', UserControllers.register);
router.post('/login', UserControllers.login);
router.get('/get_verify_code', UserControllers.getVerifyCode);

router.post('/check_verify_code', UserControllers.checkVerifyCode);
router.post('/logout', UserControllers.logout);

router.put('/change_password', isAuthenticated, UserControllers.changePassword);
router.get('/get_user_info', isAuthenticated, UserControllers.getUserInfo);
router.put('/set_user_info', isAuthenticated, UserControllers.setUserInfo);
router.put('/change_profile_after_signup', isAuthenticated, UserControllers.changeProfileAfterSignup);

export const userRouter = router;
