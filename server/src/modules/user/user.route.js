import { Router } from 'express';

// import { auth } from "../middleware/auth.middleware.js";
import { UserControllers } from './user.controller.js';

const router = Router();
router.post('/register', UserControllers.register);
router.post('/login', UserControllers.login);
router.get('/get_verify_code', UserControllers.getVerifyCode);

router.post('/check_verify_code', UserControllers.checkVerifyCode);
router.post('/logout', UserControllers.logout);

export const UserRouter = router;
