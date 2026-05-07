const otruyenService = require('../services/otruyen.service');

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
}

module.exports = new MangaController();
