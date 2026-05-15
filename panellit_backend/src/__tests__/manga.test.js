/**
 * Integration Tests: Manga API
 * Kiểm tra các endpoint tra cứu manga public (không cần đăng nhập).
 *
 * Coverage:
 * - GET /api/manga/home
 * - GET /api/manga/search
 * - GET /api/manga/image-proxy (validation)
 */
require('./setup');
const request = require('supertest');
const app = require('../app');

// ─── HOME FEED ────────────────────────────────────────────────────────────────
describe('GET /api/manga/home', () => {
  it('✅ Trả về danh sách manga trang 1', async () => {
    const res = await request(app)
      .get('/api/manga/home')
      .query({ page: 1 });

    expect(res.statusCode).toBe(200);
    expect(Array.isArray(res.body)).toBe(true);
  }, 15000); // Timeout 15s vì gọi API ngoài
});

// ─── SEARCH ─────────────────────────────────────────────────────────────────
describe('GET /api/manga/search', () => {
  it('✅ Tìm kiếm thành công và trả về items', async () => {
    const res = await request(app)
      .get('/api/manga/search')
      .query({ keyword: 'naruto' });

    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('items');
  }, 15000);

  it('❌ Báo lỗi 400 nếu thiếu keyword', async () => {
    const res = await request(app)
      .get('/api/manga/search');

    expect(res.statusCode).toBe(400);
    expect(res.body).toHaveProperty('message');
  });

  it('❌ Báo lỗi 400 nếu keyword là chuỗi rỗng', async () => {
    const res = await request(app)
      .get('/api/manga/search')
      .query({ keyword: '   ' }); // Chỉ có khoảng trắng

    expect(res.statusCode).toBe(400);
  });
});

// ─── IMAGE PROXY VALIDATION ──────────────────────────────────────────────────
describe('GET /api/manga/image-proxy', () => {
  it('❌ Báo lỗi 400 nếu không có query param url', async () => {
    const res = await request(app)
      .get('/api/manga/image-proxy');

    expect(res.statusCode).toBe(400);
    expect(res.body).toHaveProperty('message');
  });
});

// ─── 404 HANDLER ─────────────────────────────────────────────────────────────
describe('GET /api/route-khong-ton-tai', () => {
  it('❌ Báo lỗi 404 cho các route không tồn tại', async () => {
    const res = await request(app)
      .get('/api/duong-dan-nao-do-khong-co-that-99999');

    expect(res.statusCode).toBe(404);
    expect(res.body).toHaveProperty('message');
  });
});
