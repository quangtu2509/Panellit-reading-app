const express = require('express');
const historyController = require('../controllers/history.controller');
const authMiddleware = require('../middlewares/auth.middleware');
const router = express.Router();

// All history routes require authentication
router.use(authMiddleware);

/**
 * @swagger
 * /api/history/sync:
 *   post:
 *     summary: Sync reading progress
 *     tags: [History]
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
 *               - chapterId
 *             properties:
 *               mangaSlug:
 *                 type: string
 *               chapterId:
 *                 type: string
 *               lastPageIndex:
 *                 type: integer
 *     responses:
 *       200:
 *         description: Progress synced successfully
 */
router.post('/sync', (req, res) => historyController.sync(req, res));

/**
 * @swagger
 * /api/history/me:
 *   get:
 *     summary: Get user's reading history
 *     tags: [History]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: User history fetched successfully
 */
router.get('/me', (req, res) => historyController.getMyHistory(req, res));

module.exports = router;
