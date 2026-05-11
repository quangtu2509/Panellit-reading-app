const bookmarkService = require('../services/bookmark.service');

class BookmarkController {
  async toggleBookmark(req, res) {
    try {
      const userId = req.user.id;
      const { mangaSlug, novelSlug } = req.body;
      if (!mangaSlug && !novelSlug) {
        return res.status(400).json({ error: 'mangaSlug or novelSlug is required' });
      }

      const result = await bookmarkService.toggleBookmark(userId, req.body);

      res.json(result);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  async getMyBookmarks(req, res) {
    try {
      const userId = req.user.id;
      const bookmarks = await bookmarkService.getUserBookmarks(userId);
      res.json(bookmarks);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  async deleteBookmark(req, res) {
    try {
      const userId = req.user.id;
      const { mangaSlug } = req.params;
      
      if (!mangaSlug) {
        return res.status(400).json({ error: 'mangaSlug is required' });
      }

      await bookmarkService.deleteBookmark(userId, mangaSlug);
      res.json({ message: 'Bookmark deleted successfully' });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
}

module.exports = new BookmarkController();
