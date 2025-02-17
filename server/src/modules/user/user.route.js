import { Router } from 'express';

import { UserControllers } from './user.controller.js';

import { isAuthenticated } from '#middlewares';

const router = Router();

router.get('/verify', isAuthenticated, UserControllers.verifyToken);

router.post('/register', UserControllers.register);
router.post('/login', UserControllers.login);
router.get('/get_verify_code', UserControllers.getVerifyCode);

router.post('/check_verify_code', UserControllers.checkVerifyCode);
router.post('/logout', isAuthenticated, UserControllers.logout);

router.put('/change_password', isAuthenticated, UserControllers.changePassword);
router.get('/get_user_info/:userId', isAuthenticated, UserControllers.getUserInfo);
router.put('/set_user_info', isAuthenticated, UserControllers.setUserInfo);
router.patch('/change_profile_after_signup', UserControllers.changeProfileAfterSignup);
router.get('/get_children_info', isAuthenticated, UserControllers.getChildrenInfo);

router.get('/forgot_password/:email', UserControllers.forgotPassword);
router.post('/reset_password', UserControllers.resetPassword);

export const userRouter = router;
