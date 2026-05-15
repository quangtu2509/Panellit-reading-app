const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
const catchAsync = require('../utils/catch-async');
const { BadRequestError, NotFoundError } = require('../utils/app-error');

class NovelController {
  uploadNovel = catchAsync(async (req, res) => {
    const { slug, title, author, description } = req.body;
    const files = req.files || {};
    
    if (!slug || !title) {
      throw new BadRequestError('slug and title are required');
    }

    if (!files.pdf || files.pdf.length === 0) {
      throw new BadRequestError('pdf file is required');
    }

    const host = req.protocol + '://' + req.get('host');
    const pdfUrl = `${host}/static/uploads/novels/${files.pdf[0].filename}`;
    
    let coverUrl = null;
    if (files.cover && files.cover.length > 0) {
      coverUrl = `${host}/static/uploads/covers/${files.cover[0].filename}`;
    }

    const novel = await prisma.novel.upsert({
      where: { slug },
      update: {
        title,
        author,
        description,
        pdfUrl,
        ...(coverUrl && { cover: coverUrl })
      },
      create: {
        slug,
        title,
        author,
        description,
        pdfUrl,
        cover: coverUrl
      }
    });

    res.status(201).json(novel);
  });

  getNovels = catchAsync(async (req, res) => {
    const novels = await prisma.novel.findMany({
      orderBy: { createdAt: 'desc' }
    });
    res.json(novels);
  });

  getNovelBySlug = catchAsync(async (req, res) => {
    const { slug } = req.params;
    const novel = await prisma.novel.findUnique({
      where: { slug }
    });

    if (!novel) {
      throw new NotFoundError('Novel not found');
    }

    res.json(novel);
  });
}

module.exports = new NovelController();
