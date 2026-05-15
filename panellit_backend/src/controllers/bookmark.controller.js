const bookmarkService = require('../services/bookmark.service');
const catchAsync = require('../utils/catch-async');
const { BadRequestError } = require('../utils/app-error');

class BookmarkController {
  toggleBookmark = catchAsync(async (req, res) => {
    const userId = req.user.id;
    const { mangaSlug, novelSlug } = req.body;
    if (!mangaSlug && !novelSlug) {
      throw new BadRequestError('mangaSlug or novelSlug is required');
    }

    const result = await bookmarkService.toggleBookmark(userId, req.body);

    res.json(result);
  });

  getMyBookmarks = catchAsync(async (req, res) => {
    const userId = req.user.id;
    const bookmarks = await bookmarkService.getUserBookmarks(userId);
    res.json(bookmarks);
  });

  deleteBookmark = catchAsync(async (req, res) => {
    const userId = req.user.id;
    const { mangaSlug } = req.params;
    
    if (!mangaSlug) {
      throw new BadRequestError('mangaSlug is required');
    }

    await bookmarkService.deleteBookmark(userId, mangaSlug);
    res.json({ message: 'Bookmark deleted successfully' });
  });
}

module.exports = new BookmarkController();
