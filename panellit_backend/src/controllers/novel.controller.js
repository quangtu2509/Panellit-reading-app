const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

class NovelController {
  async uploadNovel(req, res) {
    try {
      const { slug, title, author, description } = req.body;
      const files = req.files || {};
      
      if (!slug || !title) {
        return res.status(400).json({ error: 'slug and title are required' });
      }

      if (!files.pdf || files.pdf.length === 0) {
        return res.status(400).json({ error: 'pdf file is required' });
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
    } catch (error) {
      console.error('Error uploading novel:', error);
      res.status(500).json({ error: error.message });
    }
  }

  async getNovels(req, res) {
    try {
      const novels = await prisma.novel.findMany({
        orderBy: { createdAt: 'desc' }
      });
      res.json(novels);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  async getNovelBySlug(req, res) {
    try {
      const { slug } = req.params;
      const novel = await prisma.novel.findUnique({
        where: { slug }
      });

      if (!novel) {
        return res.status(404).json({ error: 'Novel not found' });
      }

      res.json(novel);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
}

module.exports = new NovelController();
