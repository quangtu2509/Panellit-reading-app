const express = require('express');
const authController = require('../controllers/auth.controller');
const authMiddleware = require('../middlewares/auth.middleware');
const { validate } = require('../middlewares/validate.middleware');
const {
  registerSchema,
  loginSchema,
  updateNameSchema,
  updatePasswordSchema,
} = require('../validators/auth.validator');
const rateLimit = require('express-rate-limit');
const router = express.Router();

// Strict Rate Limiter cho thao tác Đăng nhập/Đăng ký
const authLimiter = rateLimit({
  max: 10,
  windowMs: 15 * 60 * 1000,
  message: { status: 'fail', message: 'Bạn thao tác quá nhiều lần. Vui lòng thử lại sau 15 phút!' },
  skip: () => process.env.NODE_ENV === 'test', // Tắt khi chạy test
});

/**
 * @swagger
 * /api/auth/register:
 *   post:
 *     summary: Register a new user
 *     tags: [Auth]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - email
 *               - password
 *             properties:
 *               email:
 *                 type: string
 *               password:
 *                 type: string
 *     responses:
 *       201:
 *         description: User registered successfully
 *       400:
 *         description: Error registering user
 */
router.post('/register', authLimiter, validate(registerSchema), (req, res, next) => authController.register(req, res, next));

/**
 * @swagger
 * /api/auth/login:
 *   post:
 *     summary: Login a user
 *     tags: [Auth]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - email
 *               - password
 *             properties:
 *               email:
 *                 type: string
 *               password:
 *                 type: string
 *     responses:
 *       200:
 *         description: User logged in successfully
 *       401:
 *         description: Invalid credentials
 */
router.post('/login', authLimiter, validate(loginSchema), (req, res, next) => authController.login(req, res, next));

/**
 * @swagger
 * /api/auth/update-name:
 *   put:
 *     summary: Update user display name
 *     tags: [Auth]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - name
 *             properties:
 *               name:
 *                 type: string
 *     responses:
 *       200:
 *         description: Name updated successfully
 *       400:
 *         description: Error updating name
 *       401:
 *         description: Unauthorized
 */
router.put('/update-name', authMiddleware, validate(updateNameSchema), (req, res, next) => authController.updateName(req, res, next));

/**
 * @swagger
 * /api/auth/update-password:
 *   put:
 *     summary: Update user password
 *     tags: [Auth]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - currentPassword
 *               - newPassword
 *             properties:
 *               currentPassword:
 *                 type: string
 *               newPassword:
 *                 type: string
 *     responses:
 *       200:
 *         description: Password updated successfully
 *       400:
 *         description: Error updating password
 *       401:
 *         description: Unauthorized
 */
router.put('/update-password', authMiddleware, validate(updatePasswordSchema), (req, res, next) => authController.updatePassword(req, res, next));

// GET /api/auth/me - Lấy thông tin user đang đăng nhập
router.get('/me', authMiddleware, (req, res, next) => authController.getMe(req, res, next));

module.exports = router;
