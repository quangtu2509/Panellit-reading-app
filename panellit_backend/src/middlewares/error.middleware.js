const logger = require('../utils/logger');
const { AppError } = require('../utils/app-error');

/**
 * Global Error Handler Middleware
 */
module.exports = (err, req, res, next) => {
  err.statusCode = err.statusCode || 500;
  err.status = err.status || 'error';

  // Log the error using winston
  if (err.statusCode >= 500) {
    logger.error(`${err.message}`, { stack: err.stack, url: req.originalUrl, method: req.method });
  } else {
    logger.warn(`${err.message}`, { url: req.originalUrl, method: req.method });
  }

  // Development vs Production response
  if (process.env.NODE_ENV === 'development') {
    sendErrorDev(err, res);
  } else {
    // Handle specific DB or Validation errors for clean production messages
    let error = { ...err };
    error.message = err.message;

    if (err.name === 'ZodError') error = handleZodError(err);
    if (err.code === 'P2002') error = handlePrismaUniqueError(err);
    if (err.code === 'P2025') error = handlePrismaNotFoundError(err);

    sendErrorProd(error, res);
  }
};

function sendErrorDev(err, res) {
  res.status(err.statusCode).json({
    status: err.status,
    error: err,
    message: err.message,
    stack: err.stack,
  });
}

function sendErrorProd(err, res) {
  // Operational, trusted error: send message to client
  if (err.isOperational) {
    res.status(err.statusCode).json({
      status: err.status,
      message: err.message,
    });
  } 
  // Programming or other unknown error: don't leak error details
  else {
    res.status(500).json({
      status: 'error',
      message: 'Something went very wrong!',
    });
  }
}

// Helpers for specific error transformations
function handleZodError(err) {
  const message = 'Invalid input data.';
  const error = new AppError(message, 400);
  error.errors = err.issues.map(issue => ({
    field: issue.path.join('.'),
    message: issue.message
  }));
  return error;
}

function handlePrismaUniqueError(err) {
  const field = err.meta?.target || 'field';
  return new AppError(`Duplicate value for ${field}. Please use another value.`, 400);
}

function handlePrismaNotFoundError(err) {
  return new AppError('Record not found.', 404);
}
