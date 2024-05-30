import {
  Edit,
  SimpleForm,
  TextInput,
  DateInput,
  ImageInput,
  ReferenceInput,
  SelectInput,
  EditBase,
  DateField,
  Labeled,
} from "react-admin";

import { Box, Grid, Stack, IconButton, Typography } from "@mui/material";
import CloseIcon from "@mui/icons-material/Close";

export const UserEdit = ({ id, onCancel }) => (
  // <Edit id={id}>
  //   <SimpleForm>
  //     <TextInput disabled source="id" fullWidth />
  //     <TextInput source="email" fullWidth />
  //     <TextInput source="username" fullWidth />
  //     <TextInput source="status" fullWidth />
  //     <TextInput source="coins" fullWidth />
  //     <DateInput source="createdAt" fullWidth />
  //     <DateInput source="updatedAt" fullWidth />
  //   </SimpleForm>
  // </Edit>
  <EditBase id={id}>
    <Box pt={5} width={{ xs: "100vW", sm: 400 }} mt={{ xs: 2, sm: 1 }}>
      <Stack direction="row" p={2}>
        <Typography variant="h6" flex="1">
          User Info
        </Typography>
        <IconButton onClick={onCancel} size="small">
          <CloseIcon />
        </IconButton>
      </Stack>
      {/* <SimpleForm sx={{ pt: 0, pb: 0 }}>
        <Grid container rowSpacing={1} mb={1}>
          <Grid item xs={6}>
            <Labeled>
              <CustomerReferenceField />
            </Labeled>
          </Grid>
          <Grid item xs={6}>
            <Labeled label="resources.reviews.fields.product_id">
              <ProductReferenceField />
            </Labeled>
          </Grid>
          <Grid item xs={6}>
            <Labeled>
              <DateField source="date" />
            </Labeled>
          </Grid>
          <Grid item xs={6}>
            <Labeled>
              <StarRatingField />
            </Labeled>
          </Grid>
        </Grid>
        <TextInput source="comment" maxRows={15} multiline fullWidth />
      </SimpleForm> */}
      <SimpleForm>
        <TextInput disabled source="id" fullWidth />
        <TextInput source="email" fullWidth />
        <TextInput source="username" fullWidth />
        <TextInput source="status" fullWidth />
        <TextInput source="coins" fullWidth />
        <DateInput source="createdAt" fullWidth />
        <DateInput source="updatedAt" fullWidth />
      </SimpleForm>
    </Box>
  </EditBase>
);

export const PostEdit = (props) => (
  <Edit {...props}>
    <SimpleForm>
      <TextInput disabled source="id" fullWidth />
      <ReferenceInput
        source="authorId"
        reference="users"
        label="Author"
        fullWidth
      >
        <SelectInput fullWidth optionText={(record) => record.email} />
      </ReferenceInput>
      <TextInput source="description" fullWidth />
      <TextInput source="status" fullWidth />
      <TextInput source="categoryId" fullWidth />
      <ReferenceInput
        source="groupId"
        reference="groups"
        label="Group"
        fullWidth
      >
        <SelectInput fullwidth optionText={(record) => record.groupName} />
      </ReferenceInput>
      <TextInput source="rate" fullWidth />
      <DateInput source="createdAt" fullWidth />
      <DateInput source="updatedAt" fullWidth />
    </SimpleForm>
  </Edit>
);

export const GroupEdit = (props) => (
  <Edit {...props}>
    <SimpleForm>
      <TextInput disabled source="id" />
      <TextInput source="groupName" />
      <TextInput source="description" />
      <ImageInput source="coverPhoto" />
      <TextInput source="creatorId" />
      <DateInput source="createdAt" />
      <DateInput source="updatedAt" />
    </SimpleForm>
  </Edit>
);
