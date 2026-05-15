const express = require('express');
const router = express.Router();
const novelController = require('../controllers/novel.controller');
const authMiddleware = require('../middlewares/auth.middleware');
const multer = require('multer');
const path = require('path');

// Multer setup
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    if (file.fieldname === 'pdf') {
      cb(null, 'public/uploads/novels');
    } else if (file.fieldname === 'cover') {
      cb(null, 'public/uploads/covers');
    } else {
      cb(null, 'public/uploads');
    }
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, file.fieldname + '-' + uniqueSuffix + path.extname(file.originalname));
  }
});

const upload = multer({ 
  storage: storage,
  limits: { fileSize: 50 * 1024 * 1024 } // 50MB limit
});

/**
 * @swagger
 * /api/novels/upload:
 *   post:
 *     summary: Upload a novel PDF and optionally a cover image
 *     tags: [Novels]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             properties:
 *               slug:
 *                 type: string
 *               title:
 *                 type: string
 *               author:
 *                 type: string
 *               description:
 *                 type: string
 *               pdf:
 *                 type: string
 *                 format: binary
 *               cover:
 *                 type: string
 *                 format: binary
 *     responses:
 *       201:
 *         description: Novel created successfully
 */
router.post(
  '/upload',
  authMiddleware, // require login
  upload.fields([{ name: 'pdf', maxCount: 1 }, { name: 'cover', maxCount: 1 }]),
  (req, res, next) => novelController.uploadNovel(req, res, next)
);

/**
 * @swagger
 * /api/novels:
 *   get:
 *     summary: Get all novels
 *     tags: [Novels]
 *     responses:
 *       200:
 *         description: List of novels
 */
router.get('/', (req, res, next) => novelController.getNovels(req, res, next));

/**
 * @swagger
 * /api/novels/{slug}:
 *   get:
 *     summary: Get a novel by slug
 *     tags: [Novels]
 *     parameters:
 *       - in: path
 *         name: slug
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Novel details
 */
router.get('/:slug', (req, res, next) => novelController.getNovelBySlug(req, res, next));

module.exports = router;
