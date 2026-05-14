import { runtime } from '../../config/runtime.js';

export const setMode = (mode) => {
  runtime.appMode = mode;
  return runtime.appMode;
};

export const getMode = () => {
  return runtime.appMode;
};