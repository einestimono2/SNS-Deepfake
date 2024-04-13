import { Router } from 'express';

import { GroupController } from './group.controller.js';

import { isAuthenticated } from '#middlewares';

const router = Router();

// - [POST] Create group
router.post('/create_group', isAuthenticated, GroupController.createGroup);

// - [GET] List my list group
router.get('/my_list_group', isAuthenticated, GroupController.getMyGroups);

// - [GET] Details Group
router.get('/detail_group/:groupId', isAuthenticated, GroupController.getGroupDetail);

// - [UPDATE] Update Group
router.put('/update_group/:groupId', isAuthenticated, GroupController.updateGroup);

// - [DELETE] Delete Group
router.delete('/delete_group/:groupId', isAuthenticated, GroupController.deleteGroup);

// - [POST] Add members
router.post('/add_members/:groupId', isAuthenticated, GroupController.addMembers);

// - [DELETE] Delete members
router.delete('/delete_members/:groupId', isAuthenticated, GroupController.deleteMembers);
export const groupRouter = router;
