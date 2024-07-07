import { Router } from 'express';

import { NotificationControllers } from './notification.controller.js';

import { isAuthenticated } from '#middlewares';

const router = Router();
router.post('/create_notification', isAuthenticated, NotificationControllers.createNotification);
router.get('/get_list_notifications', isAuthenticated, NotificationControllers.getListNotifications);
router.post('/check_new_items', isAuthenticated, NotificationControllers.checkNewItems);
router.post('/notify_add_post', isAuthenticated, NotificationControllers.notifyAddPost);
router.post('/notify_edit_post', isAuthenticated, NotificationControllers.notifyEditPost);
router.post('/notify_play_video', isAuthenticated, NotificationControllers.notifyPlayVideo);
router.post('/send', NotificationControllers.sendMessage);

export const notificationRouter = router;
