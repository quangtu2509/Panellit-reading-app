const historyService = require('../services/history.service');

class HistoryController {
  async sync(req, res) {
    try {
      const userId = req.user.id;
      const { mangaSlug, chapterId, lastPageIndex, mangaTitle, coverUrl } = req.body;

      if (!mangaSlug || !chapterId) {
        return res.status(400).json({ error: 'mangaSlug and chapterId are required' });
      }

      const history = await historyService.syncProgress(
        userId,
        mangaSlug,
        chapterId,
        lastPageIndex || 0,
        mangaTitle    || null,
        coverUrl      || null,
      );

      res.json(history);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  async getMyHistory(req, res) {
    try {
      const userId = req.user.id;
      const history = await historyService.getUserHistory(userId);
      res.json(history);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
}

module.exports = new HistoryController();
