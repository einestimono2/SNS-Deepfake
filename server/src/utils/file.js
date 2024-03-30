import fs from 'fs';
import path from 'path';

import { UnprocessableEntityError } from '../modules/core/index.js';

import { getStandardPath } from './path.js';

import { Message, Strings } from '#constants';

export const unlinkFileFromPath = (_path) => {
  if (!_path) return;

  if (fs.existsSync(_path)) {
    fs.unlinkSync(_path);
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

export const genFilename = (file, userKey) => {
  /**
   * const filename = 'hello.html';
   * path.parse(filename).name;     // => "hello"
   * path.parse(filename).ext;      // => ".html"
   * path.parse(filename).base;     // => "hello.html"
   */
  const { name: fileNameWithoutExtension, ext } = path.parse(file.originalname);

  return `${Strings.UNUSED_FILE_KEY}___${userKey ?? Math.floor(Math.random() * 1e9).toString(36)}-${fileNameWithoutExtension}${ext}`;
};

/**
 * Truyền vào path thu được sau khi gọi upload API
 *
 * Với ảnh:     /resources/images/filename
 *
 * Với video:   /resources/video/filename
 *  */
export const setFileUsed = (filePath) => {
  const fileParts = filePath.split('/');
  const newFilename = fileParts[3].substring(Strings.UNUSED_FILE_KEY.length + 3); // + 3 do ___ phân cách

  const oldPath = getStandardPath(`../../uploads/${fileParts[2]}/${fileParts[3]}`);
  const newPath = getStandardPath(`../../uploads/${fileParts[2]}/${newFilename}`);

  fs.rename(oldPath, newPath, (err) => {
    // Có thể xảy ra lỗi vào trường hợp trình dọn rác xóa mất file đó trước khi thực hiện đổi tên
    if (err) {
      throw new UnprocessableEntityError(Message.FILE_BROKEN);
    }
  });

  //      / resources / images / filename
  return `/${fileParts[1]}/${fileParts[2]}/${newFilename}`;
};

// Khi up anh / video bi loi --> reset ten file ve ban dau
export const setFileUnused = (filePath) => {
  const fileParts = filePath.split('/');
  const newFilename = `${Strings.UNUSED_FILE_KEY}___${fileParts[3]}`; // + 3 do ___ phân cách

  const oldPath = getStandardPath(`../../uploads/${fileParts[2]}/${fileParts[3]}`);
  const newPath = getStandardPath(`../../uploads/${fileParts[2]}/${newFilename}`);

  fs.rename(oldPath, newPath, (err) => {
    // Có thể xảy ra lỗi vào trường hợp trình dọn rác xóa mất file đó trước khi thực hiện đổi tên
    if (err) {
      throw new UnprocessableEntityError(Message.FILE_BROKEN);
    }
  });

  //      / resources / images / filename
  return `/${fileParts[1]}/${fileParts[2]}/${newFilename}`;
};
