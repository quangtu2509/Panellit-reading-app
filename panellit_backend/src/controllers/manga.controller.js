const otruyenService = require('../services/otruyen.service');
const axios = require('axios');
const catchAsync = require('../utils/catch-async');
const { BadRequestError, AppError } = require('../utils/app-error');
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

class MangaController {
  getDetails = catchAsync(async (req, res) => {
    const { slug } = req.params;
    const metadata = await otruyenService.getMangaMetadata(slug);
    res.json(metadata);
  });

  getChapter = catchAsync(async (req, res) => {
    const { chapterId } = req.params;
    const images = await otruyenService.getChapterImages(chapterId);
    res.json(images);
  });

  getHomeFeed = catchAsync(async (req, res) => {
    const page = parseInt(req.query.page) || 1;
    const feed = await otruyenService.getHomeFeed(page);
    res.json(feed);
  });

  searchManga = catchAsync(async (req, res) => {
    const { keyword } = req.query;
    if (!keyword || keyword.trim() === '') {
      throw new BadRequestError('keyword query param is required');
    }
    const page = parseInt(req.query.page) || 1;
    
    // Search remote Manga
    const mangaResult = await otruyenService.searchManga(keyword.trim(), page);
    
    // Search local Novels
    const localNovels = await prisma.novel.findMany({
      where: {
        OR: [
          { title: { contains: keyword, mode: 'insensitive' } },
          { author: { contains: keyword, mode: 'insensitive' } },
        ]
      }
    });

    // Merge results
    const novelItems = localNovels.map(n => ({
      title: n.title,
      slug: n.slug,
      cover: n.cover,
      author: n.author,
      isNovel: true,
      categories: ['Light Novel'],
      chaptersLatest: []
    }));

    const mergedItems = [...novelItems, ...mangaResult.items];

    res.json({
      ...mangaResult,
      totalItems: (mangaResult.totalItems || 0) + novelItems.length,
      items: mergedItems
    });
  });

  getCategoryManga = catchAsync(async (req, res) => {
    const { slug } = req.params;
    const page = parseInt(req.query.page) || 1;
    const result = await otruyenService.getCategoryManga(slug, page);
    res.json(result);
  });

  proxyImage = catchAsync(async (req, res) => {
    const { url } = req.query;
    if (!url) {
      throw new BadRequestError('url query param is required');
    }

    try {
      const response = await axios.get(url, {
        responseType: 'stream',
        timeout: 15000,
        headers: {
          'Referer': 'https://www.nettruyenfull.com/',
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
      });

      const contentType = response.headers['content-type'] || 'image/jpeg';
      res.setHeader('Content-Type', contentType);
      res.setHeader('Cache-Control', 'public, max-age=86400');

      response.data.pipe(res);
    } catch (error) {
      throw new AppError('Failed to proxy image', 502);
    }
  });
}

module.exports = new MangaController();
