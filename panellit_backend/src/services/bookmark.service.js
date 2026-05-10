const prisma = require('../config/database');

class BookmarkService {
  async toggleBookmark(userId, mangaSlug, mangaTitle, coverUrl, chapterId) {
    // Ensure the manga exists in our local record
    await prisma.manga.upsert({
      where: { slug: mangaSlug },
      update: {
        ...(mangaTitle && { title: mangaTitle }),
        ...(coverUrl   && { cover: coverUrl }),
      },
      create: {
        slug:  mangaSlug,
        title: mangaTitle || mangaSlug,
        cover: coverUrl   || null,
      },
    });

    const existingBookmark = await prisma.bookmark.findUnique({
      where: {
        userId_mangaSlug: {
          userId,
          mangaSlug,
        },
      },
    });

    if (existingBookmark) {
      // If no chapterId is provided, or the user clicks save again (toggling), delete it
      if (chapterId === null) {
        await prisma.bookmark.delete({
          where: { id: existingBookmark.id },
        });
        return { isSaved: false };
      } else {
        // Update the chapterId if it changed
        await prisma.bookmark.update({
          where: { id: existingBookmark.id },
          data: { chapterId },
        });
        return { isSaved: true, chapterId };
      }
    } else {
      if (chapterId !== null) {
        // Create new bookmark
        await prisma.bookmark.create({
          data: {
            userId,
            mangaSlug,
            chapterId,
          },
        });
        return { isSaved: true, chapterId };
      }
      return { isSaved: false };
    }
  }

  async getUserBookmarks(userId) {
    return await prisma.bookmark.findMany({
      where: { userId },
      include: {
        manga: true,
      },
      orderBy: {
        updatedAt: 'desc',
      },
    });
  }

  async deleteBookmark(userId, mangaSlug) {
    return await prisma.bookmark.deleteMany({
      where: {
        userId,
        mangaSlug,
      },
    });
  }
}

module.exports = new BookmarkService();
