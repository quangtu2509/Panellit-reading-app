const prisma = require('../config/database');

class HistoryService {
  async syncProgress(userId, { mangaSlug, novelSlug, chapterId, lastPageIndex, mangaTitle, coverUrl }) {
    if (mangaSlug) {
      await prisma.manga.upsert({
        where: { slug: mangaSlug },
        update: {
          ...(mangaTitle && { title: mangaTitle }),
          ...(coverUrl && { cover: coverUrl }),
        },
        create: {
          slug: mangaSlug,
          title: mangaTitle || mangaSlug,
          cover: coverUrl || null,
        },
      });

      return await prisma.history.upsert({
        where: { userId_mangaSlug: { userId, mangaSlug } },
        update: { chapterId, lastPageIndex },
        create: { userId, mangaSlug, chapterId, lastPageIndex },
      });
    } else if (novelSlug) {
      return await prisma.history.upsert({
        where: { userId_novelSlug: { userId, novelSlug } },
        update: { lastPageIndex },
        create: { userId, novelSlug, lastPageIndex },
      });
    }
    throw new Error('mangaSlug or novelSlug is required');
  }

  async getUserHistory(userId) {
    return await prisma.history.findMany({
      where: { userId },
      include: {
        manga: true,
        novel: true,
      },
      orderBy: {
        updatedAt: 'desc',
      },
    });
  }

  async deleteHistory(userId, slug) {
    return await prisma.history.deleteMany({
      where: {
        userId,
        OR: [
          { mangaSlug: slug },
          { novelSlug: slug },
        ],
      },
    });
  }
}

module.exports = new HistoryService();
