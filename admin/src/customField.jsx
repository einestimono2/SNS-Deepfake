import { useRecordContext } from "react-admin";
import { ImageField } from "react-admin";

export const CustomImageField = (props) => {
  const record = useRecordContext(props);
  const url = record.url;
  const fullUrl = `http://localhost:8888/api/v1${url}`;

  return (
    <img
      src={fullUrl}
      style={{
        width: 150,
        objectFit: "contain",
      }}
    />
  );
};

export const VideoField = (props) => {
  const record = useRecordContext(props);
  return (
    <video width="200" height="150" controls>
      <source src={record.url} type="video/mp4" />
    </video>
  );
};

VideoField.defaultProps = { label: "Video" };
