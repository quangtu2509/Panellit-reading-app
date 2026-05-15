const jwt = require('jsonwebtoken');
const { UnauthorizedError } = require('../utils/app-error');

const authMiddleware = (req, res, next) => {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return next(new UnauthorizedError('You are not logged in. Please log in to get access.'));
  }

  const token = authHeader.split(' ')[1];

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (error) {
    return next(new UnauthorizedError('Invalid or expired token. Please log in again.'));
  }
};

module.exports = authMiddleware;
