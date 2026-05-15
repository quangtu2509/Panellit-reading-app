const historyService = require('../services/history.service');
const catchAsync = require('../utils/catch-async');
const { BadRequestError } = require('../utils/app-error');

class HistoryController {
  sync = catchAsync(async (req, res) => {
    const userId = req.user.id;
    const { mangaSlug, novelSlug, chapterId } = req.body;

    if (!mangaSlug && !novelSlug) {
      throw new BadRequestError('mangaSlug or novelSlug is required');
    }
    if (mangaSlug && !chapterId) {
      throw new BadRequestError('chapterId is required for manga');
    }

    const history = await historyService.syncProgress(userId, req.body);

    res.json(history);
  });

  getMyHistory = catchAsync(async (req, res) => {
    const userId = req.user.id;
    const history = await historyService.getUserHistory(userId);
    res.json(history);
  });

  deleteHistory = catchAsync(async (req, res) => {
    const userId = req.user.id;
    const { mangaSlug } = req.params;
    
    if (!mangaSlug) {
      throw new BadRequestError('mangaSlug is required');
    }

    await historyService.deleteHistory(userId, mangaSlug);
    res.json({ message: 'History deleted successfully' });
  });
}

module.exports = new HistoryController();
