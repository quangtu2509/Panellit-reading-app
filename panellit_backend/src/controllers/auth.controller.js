const authService = require('../services/auth.service');
const catchAsync = require('../utils/catch-async');

class AuthController {
  register = catchAsync(async (req, res) => {
    const { email, password } = req.body;
    // Zod middleware already validated the input
    const result = await authService.register(email, password);
    res.status(201).json(result);
  });

  login = catchAsync(async (req, res) => {
    const { email, password } = req.body;
    const result = await authService.login(email, password);
    res.json(result);
  });

  updateName = catchAsync(async (req, res) => {
    const { name } = req.body;
    const userId = req.user.id;
    const result = await authService.updateName(userId, name);
    res.json(result);
  });

  updatePassword = catchAsync(async (req, res) => {
    const { currentPassword, newPassword } = req.body;
    const userId = req.user.id;
    const result = await authService.updatePassword(userId, currentPassword, newPassword);
    res.json(result);
  });

  getMe = catchAsync(async (req, res) => {
    // req.user đã được gắn vào bởi auth.middleware.js
    res.json(req.user);
  });
}

module.exports = new AuthController();
