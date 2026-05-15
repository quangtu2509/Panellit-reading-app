const express = require('express');
const bookmarkController = require('../controllers/bookmark.controller');
const authMiddleware = require('../middlewares/auth.middleware');
const { validate } = require('../middlewares/validate.middleware');
const { toggleBookmarkSchema } = require('../validators/bookmark.validator');
const router = express.Router();

// All bookmark routes require authentication
router.use(authMiddleware);

/**
 * @swagger
 * /api/bookmarks/toggle:
 *   post:
 *     summary: Toggle bookmark / save reading progress
 *     tags: [Bookmarks]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - mangaSlug
 *             properties:
 *               mangaSlug:
 *                 type: string
 *               chapterId:
 *                 type: integer
 *               mangaTitle:
 *                 type: string
 *               coverUrl:
 *                 type: string
 *     responses:
 *       200:
 *         description: Bookmark toggled successfully
 */
router.post('/toggle', validate(toggleBookmarkSchema), (req, res, next) => bookmarkController.toggleBookmark(req, res, next));

/**
 * @swagger
 * /api/bookmarks/me:
 *   get:
 *     summary: Get user's bookmarks
 *     tags: [Bookmarks]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: User bookmarks fetched successfully
 */
router.get('/me', (req, res, next) => bookmarkController.getMyBookmarks(req, res, next));

/**
 * @swagger
 * /api/bookmarks/{mangaSlug}:
 *   delete:
 *     summary: Delete user's bookmark for a manga
 *     tags: [Bookmarks]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: mangaSlug
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Bookmark deleted successfully
 */
router.delete('/:mangaSlug', (req, res, next) => bookmarkController.deleteBookmark(req, res, next));

module.exports = router;
