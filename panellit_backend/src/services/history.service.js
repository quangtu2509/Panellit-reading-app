const prisma = require('../config/database');

class HistoryService {
  async syncProgress(userId, mangaSlug, chapterId, lastPageIndex) {
    // Ensure the manga exists in our local record (slug as primary key)
    // In a real app, you might fetch metadata from OTruyen if it doesn't exist
    await prisma.manga.upsert({
      where: { slug: mangaSlug },
      update: {},
      create: {
        slug: mangaSlug,
        title: mangaSlug, // Placeholder, title should be updated from metadata service
      },
    });

    // Upsert the reading history for the user
    return await prisma.history.upsert({
      where: {
        userId_mangaSlug: {
          userId,
          mangaSlug,
        },
      },
      update: {
        chapterId,
        lastPageIndex,
      },
      create: {
        userId,
        mangaSlug,
        chapterId,
        lastPageIndex,
      },
    });
  }

  async getUserHistory(userId) {
    return await prisma.history.findMany({
      where: { userId },
      include: {
        manga: true,
      },
      orderBy: {
        updatedAt: 'desc',
      },
    });
  }
}

module.exports = new HistoryService();
