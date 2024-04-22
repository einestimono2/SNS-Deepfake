import express from 'express';

import { StatusCode } from '#constants';
import { omitIsNil } from '#utils';

express.response.ok = function ({ message, data, extra } = {}) {
  let _data = data;
  if (typeof _data !== 'object') {
    _data = {
      data
    };
  }

  return this.status(StatusCode.OK_200).json(omitIsNil({ status: 'success', message, data: _data, extra }));
};

express.response.created = function ({ message, data, extra } = {}) {
  let _data = data;
  if (typeof _data !== 'object') {
    _data = {
      data
    };
  }

  return this.status(StatusCode.CREATED_201).json(omitIsNil({ status: 'success', message, data: _data, extra }));
};

export const myResponse = {};

// export const myResponse = Object.create(express.response, {
//   sendOK: {
//     value: function ({ message, data, extra } = {}) {
//       return this.status(StatusCode.OK_200).json(omitIsNil({ status: 'success', message, data, extra }));
//     }
//   },
//   sendCREATED: {
//     value: function ({ message, data, extra } = {}) {
//       return this.status(StatusCode.CREATED_201).json(omitIsNil({ status: 'success', message, data, extra }));
//     }
//   }
// });
