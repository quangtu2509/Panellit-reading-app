const historyService = require('../services/history.service');

class HistoryController {
  async sync(req, res) {
    try {
      const userId = req.user.id;
      const { mangaSlug, novelSlug, chapterId, lastPageIndex, mangaTitle, coverUrl } = req.body;

      if (!mangaSlug && !novelSlug) {
        return res.status(400).json({ error: 'mangaSlug or novelSlug is required' });
      }
      if (mangaSlug && !chapterId) {
        return res.status(400).json({ error: 'chapterId is required for manga' });
      }

      const history = await historyService.syncProgress(userId, req.body);

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

  async deleteHistory(req, res) {
    try {
      const userId = req.user.id;
      const { mangaSlug } = req.params;
      
      if (!mangaSlug) {
        return res.status(400).json({ error: 'mangaSlug is required' });
      }

      await historyService.deleteHistory(userId, mangaSlug);
      res.json({ message: 'History deleted successfully' });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
}

module.exports = new HistoryController();
