import {
  Admin,
  Resource,
  useStore,
  localStorageStore,
  StoreContextProvider,
} from "react-admin";
import { dataProvider } from "./dataProvider";
import { authProvider } from "./authProvider";
import {
  UserList,
  PostList,
  GroupList,
  ImageList,
  VideoList,
} from "./modelList";
import { themes } from "./themes/themes";
import { GroupEdit, PostEdit, UserEdit } from "./modelEdit";
import { GroupShow, PostShow, UserShow } from "./modelShow";
import UserIcon from "@mui/icons-material/Person";
import GroupIcon from "@mui/icons-material/People";
import PostIcon from "@mui/icons-material/Article";
import ImageIcon from "@mui/icons-material/Image";
import { Layout } from "./components/Layout";


const store = localStorageStore(undefined, "SNS-Deepfake");

const App = () => {
  const [themeName] = useStore("themeName", "house");
  const lightTheme = themes.find((theme) => theme.name === themeName)?.light;
  const darkTheme = themes.find((theme) => theme.name === themeName)?.dark;

  return (
    <Admin
      store={store}
      dataProvider={dataProvider}
      authProvider={authProvider}
      layout={Layout}
      lightTheme={lightTheme}
      darkTheme={darkTheme}
      defaultTheme="light"
    >
      <Resource name="users" list={UserList} icon={UserIcon} show={UserShow}></Resource>
      <Resource
        name="posts"
        list={PostList}
        edit={PostEdit}
        show={PostShow}
        icon={PostIcon}
      ></Resource>
      <Resource
        name="groups"
        list={GroupList}
        edit={GroupEdit}
        show={GroupShow}
        icon={GroupIcon}
      ></Resource>
      <Resource name="post_images" list={ImageList} icon={ImageIcon} />
      <Resource name="post_videos" list={VideoList} />
    </Admin>
  );
};

const AppWrapper = () => (
  <StoreContextProvider value={store}>
      <App />
  </StoreContextProvider>
);

export default AppWrapper;
