import { AppBar, TitlePortal } from "react-admin";
import { Box } from "@mui/material";
import { AppBarToolbar } from "./AppBarToolbar";
const CustomAppBar = () => {
  return (
    <AppBar color="secondary" toolbar={<AppBarToolbar />}>
      <TitlePortal />
      {/* {isLargeEnough && <Logo />} */}
      <Box component="span" sx={{ flex: 1 }} />
    </AppBar>
  );
};

export default CustomAppBar;
