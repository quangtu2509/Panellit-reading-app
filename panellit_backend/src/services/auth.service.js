const prisma = require('../config/database');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { BadRequestError, UnauthorizedError, NotFoundError } = require('../utils/app-error');

class AuthService {
  async register(email, password) {
    const existingUser = await prisma.user.findUnique({ where: { email } });
    if (existingUser) throw new BadRequestError('Email này đã được đăng ký');

    const hashedPassword = await bcrypt.hash(password, 10);
    const user = await prisma.user.create({
      data: {
        email,
        password: hashedPassword,
      },
    });

    return this.generateToken(user);
  }

  async login(email, password) {
    const user = await prisma.user.findUnique({ where: { email } });
    // Dùng cùng một message để tránh lộ thông tin (email nào đã đăng ký)
    if (!user) throw new UnauthorizedError('Email hoặc mật khẩu không chính xác');

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) throw new UnauthorizedError('Email hoặc mật khẩu không chính xác');

    return this.generateToken(user);
  }

  async updateName(userId, name) {
    const user = await prisma.user.update({
      where: { id: userId },
      data: { name },
    });
    return { id: user.id, email: user.email, name: user.name };
  }

  async updatePassword(userId, currentPassword, newPassword) {
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) throw new NotFoundError('User not found');

    const isMatch = await bcrypt.compare(currentPassword, user.password);
    if (!isMatch) throw new UnauthorizedError('Mật khẩu hiện tại không đúng');

    const hashedPassword = await bcrypt.hash(newPassword, 10);
    await prisma.user.update({
      where: { id: userId },
      data: { password: hashedPassword },
    });
    return { success: true };
  }

  generateToken(user) {
    const token = jwt.sign({ id: user.id, email: user.email }, process.env.JWT_SECRET, {
      expiresIn: '7d',
    });
    return { token, user: { id: user.id, email: user.email, name: user.name } };
  }
}

module.exports = new AuthService();
