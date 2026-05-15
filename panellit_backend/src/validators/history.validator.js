const { z } = require('zod');

// Used for both POST /history/sync
// At least one of mangaSlug or novelSlug must be present (enforced with .refine)
const syncHistorySchema = z
  .object({
    mangaSlug: z.string().trim().optional(),
    novelSlug: z.string().trim().optional(),
    chapterId: z.string().trim().optional(),
    lastPageIndex: z.number().int().nonnegative().optional(),
    mangaTitle: z.string().trim().optional(),
    coverUrl: z.string().url('coverUrl must be a valid URL').optional(),
  })
  .refine((data) => data.mangaSlug || data.novelSlug, {
    message: 'mangaSlug or novelSlug is required',
    path: ['mangaSlug'],
  })
  .refine((data) => !(data.mangaSlug && !data.chapterId), {
    message: 'chapterId is required when syncing manga progress',
    path: ['chapterId'],
  });

module.exports = { syncHistorySchema };
