import {
  List,
  Datagrid,
  TextField,
  DateField,
  ImageField,
  BooleanField,
  ReferenceField,
  ReferenceManyField,
  FunctionField,
  EditButton,
  DeleteButton,
  DeleteWithConfirmButton,
  DatagridConfigurable,
} from "react-admin";

import { CustomImageField, VideoField } from "../customField";
export const UserDatagrid = () => (
  <DatagridConfigurable rowClick="edit">
    <TextField source="id" />
    <CustomImageField
      source="avatar"
    />
    <TextField source="email" />
    <TextField source="username" />
    <TextField source="status" />
    <TextField source="coins" />
    {/* <DateField source="createdAt" />
    <DateField source="updatedAt" /> */}
  </DatagridConfigurable>
);

export const PostDatagrid = () => (
  <DatagridConfigurable rowClick="show">
    <TextField source="id" />
    <ReferenceField
      label="Author"
      source="authorId"
      reference="users"
      link={(record) => `/users/${record.id}/show`}
    >
      <FunctionField render={(record) => record.email} />
    </ReferenceField>
    <TextField source="description" />
    <TextField source="status" />
    {/* <BooleanField source="edited" /> */}
    {/* <ReferenceField source="groupId" reference="groups" target="id"/> */}
    <ReferenceField
      label="Group"
      source="groupId"
      reference="groups"
      link={(record) => `/groups/${record.id}/show`}
    >
      <FunctionField render={(record) => record.groupName} />
    </ReferenceField>

    <TextField source="categoryId" />
    <TextField source="rate" />
    <DateField source="createdAt" />
    <DateField source="updatedAt" />
  </DatagridConfigurable>
);

export const GroupDatagrid = () => (
  <DatagridConfigurable rowClick="show">
    <TextField source="id" />
    <TextField source="groupName" />
    <TextField source="description" />
    <CustomImageField source="coverPhoto" />
    <ReferenceField
      label="Creator"
      source="creatorId"
      reference="users"
      link={(record) => `/users/${record.id}/show`}
    >
      <FunctionField render={(record) => record.email} />
    </ReferenceField>
    <DateField source="createdAt" />
    <DateField source="updatedAt" />
  </DatagridConfigurable>
);

export const ImageDatagrid = () => (
  <DatagridConfigurable>
    <TextField source="id" />
    <ReferenceField
      source="postId"
      label="Post"
      reference="posts"
      link={(record) => `/posts/${record.id}/show`}
    >
      <FunctionField
        render={(record) => `Post #${record.id}: ${record.description}`}
      />
    </ReferenceField>
    <CustomImageField
      source="url"
      // sx={{ '& img': { height: 150, objectFit: 'contain' } }}
      />
    <TextField source="order" label="Order in Post" />
    <DateField source="createdAt" />
    <DateField source="updatedAt" />
  </DatagridConfigurable>
);

export const VideoDatagrid = () => (
  <DatagridConfigurable rowClick="show">
    <TextField source="id" />
    <ReferenceField source="postId" reference="posts" label="Post">
      <FunctionField
        render={(record) => `Post #${record.id}: ${record.description}`}
      />
    </ReferenceField>
    <VideoField source="url" />
    <DateField source="createdAt" />
    <DateField source="updatedAt" />
  </DatagridConfigurable>
);
