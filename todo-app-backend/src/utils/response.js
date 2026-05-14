export const success = (res, data, status = 200) => {
  const response = {
    success: true
  };

  if (data && typeof data === 'object' && data.data && data.meta) {
    response.data = data.data;
    response.meta = data.meta;
  } else {
    response.data = data;
  }

  return res.status(status).json(response);
};

export const message = (res, msg, status = 200) => {
  return res.status(status).json({
    success: true,
    message: msg
  });
};

export const error = (res, { message, error_code, errors }, status = 500) => {
  return res.status(status).json({
    success: false,
    message,
    error_code,
    ...(errors ? { errors } : {})
  });
};