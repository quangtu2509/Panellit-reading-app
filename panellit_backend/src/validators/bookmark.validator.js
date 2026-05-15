const { z } = require('zod');

const toggleBookmarkSchema = z
  .object({
    mangaSlug: z.string().trim().optional(),
    novelSlug: z.string().trim().optional(),
    mangaTitle: z.string().trim().optional(),
    coverUrl: z.string().url('coverUrl must be a valid URL').optional(),
  })
  .refine((data) => data.mangaSlug || data.novelSlug, {
    message: 'mangaSlug or novelSlug is required',
    path: ['mangaSlug'],
  });

module.exports = { toggleBookmarkSchema };
