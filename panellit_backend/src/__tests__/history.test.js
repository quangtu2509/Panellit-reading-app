/**
 * Integration Tests: History API
 * Kiểm tra luồng đọc/xoá lịch sử đọc của user.
 *
 * Coverage:
 * - POST /api/history/sync       — Lưu tiến độ đọc
 * - GET  /api/history/me         — Lấy lịch sử của user
 * - DELETE /api/history/:slug    — Xoá một mục lịch sử
 *
 * ⚠️  Tất cả routes đều yêu cầu xác thực (Bearer Token).
 */
require('./setup');
const request = require('supertest');
const app = require('../app');

// ─── Helpers ─────────────────────────────────────────────────────────────────

/** Đăng ký + đăng nhập → trả về token */
async function getAuthToken() {
  const email = `history_test_${Date.now()}@panellit.test`;
  const password = 'Test@123456';
  await request(app)
    .post('/api/auth/register')
    .send({ email, password, name: 'History Tester' });
  const res = await request(app)
    .post('/api/auth/login')
    .send({ email, password });
  return res.body.token;
}

// ─── State ────────────────────────────────────────────────────────────────────
let token = '';
const testSlug = 'test-manga-history';
const testChapterId = 'chapter-test-001';

beforeAll(async () => {
  token = await getAuthToken();
});

// ─── SYNC (POST /api/history/sync) ───────────────────────────────────────────
describe('POST /api/history/sync', () => {
  it('✅ Lưu tiến độ đọc thành công với dữ liệu hợp lệ', async () => {
    const res = await request(app)
      .post('/api/history/sync')
      .set('Authorization', `Bearer ${token}`)
      .send({
        mangaSlug: testSlug,
        chapterId: testChapterId,
        lastPageIndex: 5,
        mangaTitle: 'Test Manga Title',
        coverUrl: 'https://example.com/cover.jpg',
      });

    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('mangaSlug', testSlug);
    expect(res.body).toHaveProperty('chapterId', testChapterId);
  });

  it('❌ Báo lỗi 401 nếu không có token', async () => {
    const res = await request(app)
      .post('/api/history/sync')
      .send({ mangaSlug: testSlug, chapterId: testChapterId });

    expect(res.statusCode).toBe(401);
  });

  it('❌ Báo lỗi 422 nếu thiếu cả mangaSlug lẫn novelSlug (Zod)', async () => {
    const res = await request(app)
      .post('/api/history/sync')
      .set('Authorization', `Bearer ${token}`)
      .send({ chapterId: 'some-chapter' }); // Thiếu slug

    expect(res.statusCode).toBe(422);
  });

  it('❌ Báo lỗi 422 nếu có mangaSlug nhưng thiếu chapterId (Zod)', async () => {
    const res = await request(app)
      .post('/api/history/sync')
      .set('Authorization', `Bearer ${token}`)
      .send({ mangaSlug: testSlug }); // Thiếu chapterId

    expect(res.statusCode).toBe(422);
  });

  it('✅ Cho phép sync lịch sử Novel (chỉ cần novelSlug)', async () => {
    // novelSlug phải là slug của novel thực trong DB (FK constraint)
    // Lấy novel đầu tiên từ DB để dùng slug thực
    const novelRes = await request(app).get('/api/novels');
    if (novelRes.body.length === 0) {
      console.log('ℹ️  [History Test] Bỏ qua — DB chưa có novel nào.');
      return;
    }
    const existingNovelSlug = novelRes.body[0].slug;

    const res = await request(app)
      .post('/api/history/sync')
      .set('Authorization', `Bearer ${token}`)
      .send({
        novelSlug: existingNovelSlug,
        lastPageIndex: 10,
      });

    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('novelSlug', existingNovelSlug);
  });
});

// ─── GET MY HISTORY (GET /api/history/me) ────────────────────────────────────
describe('GET /api/history/me', () => {
  it('✅ Lấy lịch sử thành công (trả về array)', async () => {
    const res = await request(app)
      .get('/api/history/me')
      .set('Authorization', `Bearer ${token}`);

    expect(res.statusCode).toBe(200);
    expect(Array.isArray(res.body)).toBe(true);
  });

  it('✅ Lịch sử chứa mục vừa sync', async () => {
    const res = await request(app)
      .get('/api/history/me')
      .set('Authorization', `Bearer ${token}`);

    const found = res.body.some((item) => item.mangaSlug === testSlug);
    expect(found).toBe(true);
  });

  it('❌ Báo lỗi 401 nếu không có token', async () => {
    const res = await request(app).get('/api/history/me');

    expect(res.statusCode).toBe(401);
  });
});

// ─── DELETE HISTORY (DELETE /api/history/:mangaSlug) ─────────────────────────
describe('DELETE /api/history/:mangaSlug', () => {
  it('✅ Xoá lịch sử thành công', async () => {
    const res = await request(app)
      .delete(`/api/history/${testSlug}`)
      .set('Authorization', `Bearer ${token}`);

    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('message');
  });

  it('✅ Sau khi xoá, không còn trong danh sách', async () => {
    const res = await request(app)
      .get('/api/history/me')
      .set('Authorization', `Bearer ${token}`);

    const found = res.body.some((item) => item.mangaSlug === testSlug);
    expect(found).toBe(false);
  });

  it('❌ Báo lỗi 401 nếu không có token', async () => {
    const res = await request(app)
      .delete(`/api/history/${testSlug}`);

    expect(res.statusCode).toBe(401);
  });
});
