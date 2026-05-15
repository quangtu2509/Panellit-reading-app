/**
 * Integration Tests: Novel API
 * Kiểm tra luồng lấy danh sách và chi tiết truyện chữ (Light Novel).
 *
 * Coverage:
 * - GET /api/novels         — Lấy toàn bộ danh sách novel
 * - GET /api/novels/:slug   — Lấy chi tiết novel theo slug
 *
 * ℹ️  Novel là public route (không cần auth).
 * ℹ️  Upload novel (POST /api/novels/upload) yêu cầu file PDF nên bỏ qua ở đây.
 */
require('./setup');
const request = require('supertest');
const app = require('../app');

// ─── GET ALL NOVELS (GET /api/novels) ────────────────────────────────────────
describe('GET /api/novels', () => {
  it('✅ Trả về danh sách novel (array)', async () => {
    const res = await request(app).get('/api/novels');

    expect(res.statusCode).toBe(200);
    expect(Array.isArray(res.body)).toBe(true);
  });

  it('✅ Mỗi novel có đầy đủ các trường cần thiết', async () => {
    const res = await request(app).get('/api/novels');

    // Chỉ kiểm tra nếu DB có ít nhất 1 novel
    if (res.body.length > 0) {
      const first = res.body[0];
      expect(first).toHaveProperty('title');
      expect(first).toHaveProperty('slug');
    }

    // Dù rỗng hay không, status phải là 200
    expect(res.statusCode).toBe(200);
  });
});

// ─── GET NOVEL BY SLUG (GET /api/novels/:slug) ───────────────────────────────
describe('GET /api/novels/:slug', () => {
  it('❌ Báo lỗi 404 nếu slug không tồn tại', async () => {
    const res = await request(app).get('/api/novels/slug-khong-ton-tai-12345');

    expect(res.statusCode).toBe(404);
    expect(res.body).toHaveProperty('message');
  });

  it('✅ Lấy chi tiết novel thành công nếu slug tồn tại', async () => {
    // Lấy danh sách trước để có slug thực
    const listRes = await request(app).get('/api/novels');
    
    if (listRes.body.length === 0) {
      // Bỏ qua test này nếu DB chưa có novel nào
      console.log('ℹ️  [Novel Test] Bỏ qua — DB chưa có novel nào.');
      return;
    }

    const existingSlug = listRes.body[0].slug;
    const res = await request(app).get(`/api/novels/${existingSlug}`);

    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('slug', existingSlug);
    expect(res.body).toHaveProperty('title');
  });
});
