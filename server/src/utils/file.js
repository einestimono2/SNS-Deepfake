import fs from 'fs';

export const unlinkFileFromPath = (path) => {
  if (!path) return;

  if (fs.existsSync(path)) {
    fs.unlinkSync(path);
  }
};

export const unlinkRequestFile = (file) => {
  if (!file) return;

  unlinkFileFromPath(file.path);
};

export const unlinkRequestFiles = (files) => {
  if (!files) return;

  if (Array.isArray(files)) {
    for (const file of files) {
      unlinkFileFromPath(file.path);
    }
  } else {
    Object.keys(files).forEach((key) => {
      for (const file of files[`${key}`]) {
        unlinkFileFromPath(file.path);
      }
    });
  }
};
