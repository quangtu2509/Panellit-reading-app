const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Seeding novels...');

  // Build the pdfUrl and coverUrl from static path
  const baseUrl = 'http://localhost:3000';
  const pdfFilename = 'Classroom of the Elite_ Year 2 Vol. 1.pdf';
  const coverFilename = '7d4f0b27-6304-40d3-8808-1a9d703f6d6d.jpg';

  const pdfUrl = `${baseUrl}/static/uploads/novels/${encodeURIComponent(pdfFilename)}`;
  const coverUrl = `${baseUrl}/static/uploads/covers/${coverFilename}`;

  const novel = await prisma.novel.upsert({
    where: { slug: 'cote-year2-vol1' },
    update: {},
    create: {
      slug:        'cote-year2-vol1',
      title:       'Classroom of the Elite: Year 2 Vol. 1',
      author:      'Shōgo Kinugasa',
      cover:       coverUrl,
      pdfUrl:      pdfUrl,
      description: 'The new school year begins at Tokyo Metropolitan Advanced Nurturing School. Kiyotaka Ayanokōji enters his second year, and the advanced class students are entering new challenges to climb toward Class A.',
    },
  });

  console.log('✅ Novel seeded:', novel);
}

main()
  .catch((e) => {
    console.error('❌ Seed failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
