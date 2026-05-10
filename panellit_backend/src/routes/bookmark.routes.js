const express = require('express');
const bookmarkController = require('../controllers/bookmark.controller');
const authMiddleware = require('../middlewares/auth.middleware');
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
router.post('/toggle', (req, res) => bookmarkController.toggleBookmark(req, res));

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
router.get('/me', (req, res) => bookmarkController.getMyBookmarks(req, res));

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
router.delete('/:mangaSlug', (req, res) => bookmarkController.deleteBookmark(req, res));

module.exports = router;
