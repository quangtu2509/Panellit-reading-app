const bookmarkService = require('../services/bookmark.service');

class BookmarkController {
  async toggleBookmark(req, res) {
    try {
      const userId = req.user.id;
      const { mangaSlug, chapterId, mangaTitle, coverUrl } = req.body;

      if (!mangaSlug) {
        return res.status(400).json({ error: 'mangaSlug is required' });
      }

      const result = await bookmarkService.toggleBookmark(
        userId,
        mangaSlug,
        mangaTitle    || null,
        coverUrl      || null,
        chapterId     !== undefined ? chapterId : null
      );

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
