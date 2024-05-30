import {
  Show,
  SimpleShowLayout,
  TextField,
  DateField,
  ImageField,
  ReferenceManyField,
  Datagrid,
  ReferenceField,
  TabbedShowLayout,
} from "react-admin";
import { VideoField } from "./customField";

export const UserShow = (props) => (
  <Show {...props}>
    <SimpleShowLayout>
      <TextField source="id" />
      <ImageField source="avatar" title="this is the avatar" />
      <TextField source="email" />
      <TextField source="username" />
      <TextField source="status" />
      <TextField source="coins" />
      <DateField source="createdAt" />
      <DateField source="updatedAt" />
    </SimpleShowLayout>
  </Show>
);

export const PostShow = (props) => (
  <Show {...props}>
    <TabbedShowLayout>
      <TabbedShowLayout.Tab label="summary">
        <TextField source="id" />
        <TextField source="authorId" />
        <TextField source="description" />
        <TextField source="status" />
        <TextField source="groupId" />
        <TextField source="categoryId" />
        <TextField source="rate" />
        <DateField source="createdAt" />
        <DateField source="updatedAt" />
      </TabbedShowLayout.Tab>
      {/* <ReferenceManyField

        label="Comments"
        reference="comments"
        target="postId"
        sort={{ field: "createdAt", order: "DESC" }}
      >
        <Datagrid>
          <TextField source="id" />
          <TextField source="postId" />
          <TextField source="name" />
          <TextField source="body" />
          <DateField source="createdAt" />
          <DateField source="updatedAt" />
        </Datagrid>
      </ReferenceManyField> */}
      <TabbedShowLayout.Tab label="videos">
        <ReferenceManyField
          label="Videos"
          reference="post_videos"
          target="postId"
        >
          <Datagrid>
            <TextField source="id" />
            <VideoField source="url" label="Video"/>
          </Datagrid>
        </ReferenceManyField>
      </TabbedShowLayout.Tab>

      <TabbedShowLayout.Tab label="images">
        <ReferenceManyField
          label="Images"
          reference="post_images"
          target="postId"
        >
          <Datagrid>
            <TextField source="id" />
            <ImageField source="url" label="Image" />
          </Datagrid>
        </ReferenceManyField>
      </TabbedShowLayout.Tab>
    </TabbedShowLayout>
  </Show>
);

export const GroupShow = (props) => (
  <Show {...props}>
    <SimpleShowLayout>
      <TextField source="id" />
      <TextField source="groupName" />
      <TextField source="description" />
      <ImageField source="coverPhoto" />
      <TextField source="creatorId" />
      <DateField source="createdAt" />
      <DateField source="updatedAt" />
    </SimpleShowLayout>
  </Show>
);
