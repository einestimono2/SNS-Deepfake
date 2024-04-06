import { Router } from 'express';

import { SettingControllers } from './setting.controller.js';

import { isAuthenticated } from '#middlewares';

const router = Router();
router.post('/set_device_token', isAuthenticated, SettingControllers.setDevToken);
router.post('/buy_coins', isAuthenticated, SettingControllers.buyCoins);
router.get('/get_push_settings', isAuthenticated, SettingControllers.getPushSettings);
router.post('/set_push_settings', isAuthenticated, SettingControllers.setPushSettings);
router.get('/get_user_push_setting', isAuthenticated, SettingControllers.getUserPushSettings);
export const settingRouter = router;
