import { List as RAList } from "react-admin";
import { useCallback, useEffect } from "react";
import {
  CreateButton,
  ExportButton,
  FilterButton,
  SelectColumnsButton,
  TopToolbar,
} from "react-admin";
import { Drawer } from "@mui/material";
import { SearchInput } from "react-admin";
import { matchPath, useLocation, useNavigate } from "react-router-dom";
import { UserEdit } from "../modelEdit";

const filter = [
  <SearchInput source="email" placeholder="Enter email" alwaysOn />,
];

const ListActions = () => (
  <TopToolbar>
    {/* <FilterButton /> */}
    <CreateButton />
    <SelectColumnsButton />
    <ExportButton />
  </TopToolbar>
);

export const List = ({ dataGrid, title }) => {
  const location = useLocation();
  const navigate = useNavigate();
  const match = matchPath("/users/:id", location.pathname);

  const handleClose = useCallback(() => {
    navigate("/users");
  }, [navigate]);

  useEffect(() => {
    if (match?.params.id)
    console.log(match.params.id);
  }, [match]);

  return (
    <>
      {/* <div
        style={{
          display: "flex",
          justifyContent: "center",
          margin: "30px 0px 10px 0px",
        }}
      >
        <h1 style={{ margin: "0px" }}>{title}</h1>
      </div> */}
      <RAList  actions={<ListActions />}>
        {dataGrid}
      </RAList>

      <Drawer
        variant="persistent"
        open={!!match}
        anchor="right"
        onClose={handleClose}
        sx={{ zIndex: 100 }}
      >
        {/* To avoid any errors if the route does not match, we don't render at all the component in this case */}
        {!!match && <UserEdit id={match.params.id} onCancel={handleClose}/>}
      </Drawer>
    </>
  );
};
