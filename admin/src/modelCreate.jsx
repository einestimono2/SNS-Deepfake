import { Create, SimpleForm, TextInput, DateInput, ImageInput } from 'react-admin';

export const UserCreate = (props) => (
  <Create {...props}>
    <SimpleForm>
      <TextInput source="email" />
      <TextInput source="username" />
      <TextInput source="status" />
      <TextInput source="coins" />
      <DateInput source="createdAt" />
      <DateInput source="updatedAt" />
    </SimpleForm>
  </Create>
);

export const PostCreate = (props) => (
  <Create {...props}>
    <SimpleForm>
      <TextInput source="authorId" />
      <TextInput source="description" />
      <TextInput source="status" />
      <TextInput source="categoryId" />
      <TextInput source="groupId" />
      <TextInput source="rate" />
      <DateInput source="createdAt" />
      <DateInput source="updatedAt" />
    </SimpleForm>
  </Create>
);

export const GroupCreate = (props) => (
  <Create {...props}>
    <SimpleForm>
      <TextInput source="groupName" />
      <TextInput source="description" />
      <ImageInput source="coverPhoto" />
      <TextInput source="creatorId" />
      <DateInput source="createdAt" />
      <DateInput source="updatedAt" />
    </SimpleForm>
  </Create>
);