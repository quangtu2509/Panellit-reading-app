const prisma = require('../config/database');

class BookmarkService {
  async toggleBookmark(userId, { mangaSlug, novelSlug, mangaTitle, novelTitle, coverUrl, chapterId, genres }) {
    if (mangaSlug) {
      await prisma.manga.upsert({
        where: { slug: mangaSlug },
        update: {
          ...(mangaTitle && { title: mangaTitle }),
          ...(coverUrl && { cover: coverUrl }),
          ...(genres && { genres }),
        },
        create: {
          slug: mangaSlug,
          title: mangaTitle || mangaSlug,
          cover: coverUrl || null,
          genres: genres || [],
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
      // Upsert novel metadata to ensure genres are up to date
      await prisma.novel.upsert({
        where: { slug: novelSlug },
        update: {
          ...(novelTitle && { title: novelTitle }),
          ...(coverUrl && { cover: coverUrl }),
          ...(genres && { genres }),
        },
        create: {
          slug: novelSlug,
          title: novelTitle || novelSlug,
          pdfUrl: '',
          cover: coverUrl || null,
          genres: genres || [],
        },
      });

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
