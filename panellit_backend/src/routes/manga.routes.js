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
 * /api/manga/search:
 *   get:
 *     summary: Search manga by keyword
 *     tags: [Manga]
 *     parameters:
 *       - in: query
 *         name: keyword
 *         required: true
 *         schema:
 *           type: string
 *         description: Search keyword
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *         description: Page number (default 1)
 *     responses:
 *       200:
 *         description: Search results
 */
router.get('/search', (req, res) => mangaController.searchManga(req, res));

/**
 * @swagger
 * /api/manga/image-proxy:
 *   get:
 *     summary: Proxy an image from OTruyen CDN (bypasses hotlink protection)
 *     tags: [Manga]
 *     parameters:
 *       - in: query
 *         name: url
 *         required: true
 *         schema:
 *           type: string
 *         description: The full CDN image URL to proxy
 *     responses:
 *       200:
 *         description: Image streamed successfully
 *         content:
 *           image/*:
 *             schema:
 *               type: string
 *               format: binary
 */
router.get('/image-proxy', (req, res) => mangaController.proxyImage(req, res));

/**
 * @swagger
 * /api/manga/category/{slug}:
 *   get:
 *     summary: Get manga list by category/genre slug
 *     tags: [Manga]
 *     parameters:
 *       - in: path
 *         name: slug
 *         required: true
 *         schema:
 *           type: string
 *         description: The category slug (e.g., action, romance, manhwa)
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *         description: Page number (default 1)
 *     responses:
 *       200:
 *         description: Category manga list fetched successfully
 */
router.get('/category/:slug', (req, res) => mangaController.getCategoryManga(req, res));

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
