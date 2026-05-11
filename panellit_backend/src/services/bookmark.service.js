const prisma = require('../config/database');

class BookmarkService {
  async toggleBookmark(userId, { mangaSlug, novelSlug, mangaTitle, novelTitle, coverUrl, chapterId }) {
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

      const existingBookmark = await prisma.bookmark.findUnique({
        where: { userId_mangaSlug: { userId, mangaSlug } },
      });

      if (existingBookmark) {
        if (chapterId === null) {
          await prisma.bookmark.delete({ where: { id: existingBookmark.id } });
          return { isSaved: false };
        } else {
          await prisma.bookmark.update({
            where: { id: existingBookmark.id },
            data: { chapterId },
          });
          return { isSaved: true, chapterId };
        }
      } else {
        if (chapterId !== null) {
          await prisma.bookmark.create({
            data: { userId, mangaSlug, chapterId },
          });
          return { isSaved: true, chapterId };
        }
        return { isSaved: false };
      }
    } else if (novelSlug) {
      // Novel metadata is already in our DB usually, but let's ensure it's there
      // (Novel is local, Manga is remote-synced)
      const existingBookmark = await prisma.bookmark.findUnique({
        where: { userId_novelSlug: { userId, novelSlug } },
      });

      if (existingBookmark) {
        await prisma.bookmark.delete({ where: { id: existingBookmark.id } });
        return { isSaved: false };
      } else {
        await prisma.bookmark.create({
          data: { userId, novelSlug },
        });
        return { isSaved: true };
      }
    }
    throw new Error('mangaSlug or novelSlug is required');
  }

  async getUserBookmarks(userId) {
    return await prisma.bookmark.findMany({
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

  async deleteBookmark(userId, slug) {
    return await prisma.bookmark.deleteMany({
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

module.exports = new BookmarkService();
