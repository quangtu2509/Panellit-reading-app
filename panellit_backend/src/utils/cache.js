/**
 * In-Memory Cache Utility
 *
 * Dùng `node-cache` để lưu tạm kết quả từ API OTruyen.
 * Giúp giảm số lần gọi ra ngoài, tăng tốc độ response.
 *
 * Chiến lược TTL (Time To Live):
 * - Home Feed    : 5 phút  — Dữ liệu thay đổi thường xuyên
 * - Search       : 2 phút  — Kết quả search cần khá tươi
 * - Category     : 5 phút  — Ít thay đổi
 * - Manga Detail : 10 phút — Ổn định, ít cập nhật
 * - Chapter      : 60 phút — Hầu như không thay đổi
 */
const NodeCache = require('node-cache');
const logger = require('./logger');

// stdTTL=0 → không set default, mỗi route tự quản lý TTL
const cache = new NodeCache({ stdTTL: 0, checkperiod: 120 });

const TTL = {
  HOME: 5 * 60,       // 5 phút
  SEARCH: 2 * 60,     // 2 phút
  CATEGORY: 5 * 60,   // 5 phút
  MANGA_DETAIL: 10 * 60, // 10 phút
  CHAPTER: 60 * 60,   // 60 phút
};

/**
 * Express middleware factory để cache response theo route.
 *
 * @param {number} ttl - Thời gian cache (giây)
 * @returns {Function} Express middleware
 *
 * @example
 * router.get('/home', cacheMiddleware(TTL.HOME), controller.getHomeFeed);
 */
function cacheMiddleware(ttl) {
  return (req, res, next) => {
    // Không cache trong môi trường test
    if (process.env.NODE_ENV === 'test') return next();

    // Tạo cache key từ URL đầy đủ (bao gồm query params)
    const key = req.originalUrl;
    const cached = cache.get(key);

    if (cached !== undefined) {
      logger.info(`[Cache] HIT: ${key}`);
      return res.json(cached);
    }

    // Override res.json để interceptor lưu kết quả vào cache
    const originalJson = res.json.bind(res);
    res.json = (body) => {
      // Chỉ cache nếu request thành công (2xx)
      if (res.statusCode >= 200 && res.statusCode < 300) {
        cache.set(key, body, ttl);
        logger.info(`[Cache] MISS → SET: ${key} (TTL: ${ttl}s)`);
      }
      return originalJson(body);
    };

    next();
  };
}

module.exports = { cache, cacheMiddleware, TTL };
