const otruyenService = require('../services/otruyen.service');
const axios = require('axios');

class MangaController {
  async getDetails(req, res) {
    try {
      const { slug } = req.params;
      const metadata = await otruyenService.getMangaMetadata(slug);
      res.json(metadata);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  async getChapter(req, res) {
    try {
      const { chapterId } = req.params;
      const images = await otruyenService.getChapterImages(chapterId);
      res.json(images);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  async getHomeFeed(req, res) {
    try {
      const page = parseInt(req.query.page) || 1;
      const feed = await otruyenService.getHomeFeed(page);
      res.json(feed);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  async searchManga(req, res) {
    try {
      const { keyword } = req.query;
      if (!keyword || keyword.trim() === '') {
        return res.status(400).json({ error: 'keyword query param is required' });
      }
      const page = parseInt(req.query.page) || 1;
      
      // Search remote Manga
      const mangaResult = await otruyenService.searchManga(keyword.trim(), page);
      
      // Search local Novels (only on first page for now, or simple filter)
      const { PrismaClient } = require('@prisma/client');
      const prisma = new PrismaClient();
      const localNovels = await prisma.novel.findMany({
        where: {
          OR: [
            { title: { contains: keyword, mode: 'insensitive' } },
            { author: { contains: keyword, mode: 'insensitive' } },
          ]
        }
      });

      // Merge results
      // Note: We might want to wrap novels to match the manga structure
      const novelItems = localNovels.map(n => ({
        title: n.title,
        slug: n.slug,
        cover: n.cover,
        author: n.author,
        isNovel: true, // Flag for frontend
        categories: ['Light Novel'],
        chaptersLatest: []
      }));

      const mergedItems = [...novelItems, ...mangaResult.items];

      res.json({
        ...mangaResult,
        totalItems: (mangaResult.totalItems || 0) + novelItems.length,
        items: mergedItems
      });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  /**
   * Get manga list by category/genre slug.
   * Query: ?page=<page>
   */
  async getCategoryManga(req, res) {
    try {
      const { slug } = req.params;
      const page = parseInt(req.query.page) || 1;
      const result = await otruyenService.getCategoryManga(slug, page);
      res.json(result);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  /**
   * Proxy an image from OTruyen CDN with proper Referer header.
   * This bypasses CDN hotlink protection that blocks direct requests.
   * Query: ?url=<encoded image URL>
   */
  async proxyImage(req, res) {
    try {
      const { url } = req.query;
      if (!url) {
        return res.status(400).json({ error: 'url query param is required' });
      }

      const response = await axios.get(url, {
        responseType: 'stream',
        timeout: 15000,
        headers: {
          'Referer': 'https://www.nettruyenfull.com/',
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        },
      });

      // Forward content-type and cache headers
      const contentType = response.headers['content-type'] || 'image/jpeg';
      res.setHeader('Content-Type', contentType);
      res.setHeader('Cache-Control', 'public, max-age=86400'); // Cache 24h

      response.data.pipe(res);
    } catch (error) {
      console.error(`MangaController [proxyImage] Error:`, error.message);
      res.status(502).json({ error: 'Failed to proxy image' });
    }
  }
}

module.exports = new MangaController();
