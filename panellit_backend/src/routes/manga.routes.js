const express = require('express');
const mangaController = require('../controllers/manga.controller');
const router = express.Router();

/**
 * @swagger
 * /api/manga/home:
 *   get:
 *     summary: Get home feed (newly updated manga list)
 *     tags: [Manga]
 *     parameters:
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *         description: Page number (default 1)
 *     responses:
 *       200:
 *         description: Home feed fetched successfully
 */
// ⚠️ IMPORTANT: Specific routes MUST be registered before dynamic /:slug
router.get('/home', (req, res) => mangaController.getHomeFeed(req, res));

/**
 * @swagger
 * /api/manga/chapter/{chapterId}:
 *   get:
 *     summary: Get chapter images by ID
 *     tags: [Manga]
 *     parameters:
 *       - in: path
 *         name: chapterId
 *         required: true
 *         schema:
 *           type: string
 *         description: The chapter ID from manga details
 *     responses:
 *       200:
 *         description: Chapter images fetched successfully
 */
router.get('/chapter/:chapterId', (req, res) => mangaController.getChapter(req, res));

/**
 * @swagger
 * /api/manga/{slug}:
 *   get:
 *     summary: Get manga details by slug
 *     tags: [Manga]
 *     parameters:
 *       - in: path
 *         name: slug
 *         required: true
 *         schema:
 *           type: string
 *         description: The manga slug (e.g., toi-thang-cap-mot-minh)
 *     responses:
 *       200:
 *         description: Manga details fetched successfully
 */
router.get('/:slug', (req, res) => mangaController.getDetails(req, res));

module.exports = router;
