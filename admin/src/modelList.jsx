import {
  UserDatagrid,
  PostDatagrid,
  GroupDatagrid,
  ImageDatagrid,
  VideoDatagrid,
} from "./components/DataGrid.jsx";

import { List } from "./components/List";

export const UserList = () => (
  <List dataGrid={<UserDatagrid/>} title="DANH SÁCH NGƯỜI DÙNG"/>
);

export const PostList = () => (
  <List dataGrid={<PostDatagrid/>} title="DANH SÁCH BÀI ĐĂNG"/>
);

export const GroupList = () => (
  <List dataGrid={<GroupDatagrid/>} title="DANH SÁCH NHÓM"/>
);

export const ImageList = () => (
  <List dataGrid={<ImageDatagrid/>} title="DANH SÁCH HÌNH ẢNH"/>
);

export const VideoList = () => (
  <List dataGrid={<VideoDatagrid/>} title="DANH SÁCH VIDEO"/>
);
