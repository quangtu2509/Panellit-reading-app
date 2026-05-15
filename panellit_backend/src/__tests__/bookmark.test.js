/**
 * Integration Tests: Bookmark API
 * Kiểm tra luồng thêm/xoá bookmark của user.
 *
 * Coverage:
 * - POST   /api/bookmarks/toggle  — Thêm hoặc bỏ bookmark
 * - GET    /api/bookmarks/me      — Lấy danh sách bookmark
 * - DELETE /api/bookmarks/:slug   — Xoá một bookmark cụ thể
 *
 * ⚠️  Tất cả routes đều yêu cầu xác thực (Bearer Token).
 */
require('./setup');
const request = require('supertest');
const app = require('../app');

// ─── Helpers ─────────────────────────────────────────────────────────────────

/** Đăng ký + đăng nhập → trả về token */
async function getAuthToken() {
  const email = `bookmark_test_${Date.now()}@panellit.test`;
  const password = 'Test@123456';
  await request(app)
    .post('/api/auth/register')
    .send({ email, password, name: 'Bookmark Tester' });
  const res = await request(app)
    .post('/api/auth/login')
    .send({ email, password });
  return res.body.token;
}

// ─── State ────────────────────────────────────────────────────────────────────
let token = '';
const testSlug = 'test-manga-bookmark';

beforeAll(async () => {
  token = await getAuthToken();
});

// ─── TOGGLE (POST /api/bookmarks/toggle) ─────────────────────────────────────
describe('POST /api/bookmarks/toggle', () => {
  it('✅ Thêm bookmark thành công (lần đầu toggle)', async () => {
    const res = await request(app)
      .post('/api/bookmarks/toggle')
      .set('Authorization', `Bearer ${token}`)
      .send({
        mangaSlug: testSlug,
        mangaTitle: 'Test Manga Bookmark',
        coverUrl: 'https://example.com/cover.jpg',
      });

    expect(res.statusCode).toBe(200);
    // Lần đầu toggle → tạo mới hoặc trả về trạng thái bookmarked
    expect(res.body).toBeDefined();
  });

  it('✅ Bỏ bookmark thành công (toggle lần 2 → xoá)', async () => {
    const res = await request(app)
      .post('/api/bookmarks/toggle')
      .set('Authorization', `Bearer ${token}`)
      .send({ mangaSlug: testSlug });

    expect(res.statusCode).toBe(200);
  });

  it('✅ Toggle với novelSlug thay vì mangaSlug', async () => {
    // novelSlug phải tồn tại trong bảng Novel (FK constraint)
    const novelRes = await request(app).get('/api/novels');
    if (novelRes.body.length === 0) {
      console.log('ℹ️  [Bookmark Test] Bỏ qua — DB chưa có novel nào.');
      return;
    }
    const existingNovelSlug = novelRes.body[0].slug;

    const res = await request(app)
      .post('/api/bookmarks/toggle')
      .set('Authorization', `Bearer ${token}`)
      .send({ novelSlug: existingNovelSlug });

    expect(res.statusCode).toBe(200);
  });

  it('❌ Báo lỗi 422 nếu thiếu cả mangaSlug lẫn novelSlug (Zod)', async () => {
    const res = await request(app)
      .post('/api/bookmarks/toggle')
      .set('Authorization', `Bearer ${token}`)
      .send({ mangaTitle: 'Chỉ có title, không có slug' });

    expect(res.statusCode).toBe(422);
  });

  it('❌ Báo lỗi 401 nếu không có token', async () => {
    const res = await request(app)
      .post('/api/bookmarks/toggle')
      .send({ mangaSlug: testSlug });

    expect(res.statusCode).toBe(401);
  });
});

// ─── GET MY BOOKMARKS (GET /api/bookmarks/me) ────────────────────────────────
describe('GET /api/bookmarks/me', () => {
  beforeAll(async () => {
    // Đảm bảo có ít nhất 1 bookmark trước khi test GET
    await request(app)
      .post('/api/bookmarks/toggle')
      .set('Authorization', `Bearer ${token}`)
      .send({ mangaSlug: 'bookmark-for-get-test' });
  });

  it('✅ Lấy danh sách bookmark thành công (trả về array)', async () => {
    const res = await request(app)
      .get('/api/bookmarks/me')
      .set('Authorization', `Bearer ${token}`);

    expect(res.statusCode).toBe(200);
    expect(Array.isArray(res.body)).toBe(true);
  });

  it('✅ Danh sách chứa manga vừa bookmark', async () => {
    const res = await request(app)
      .get('/api/bookmarks/me')
      .set('Authorization', `Bearer ${token}`);

    const found = res.body.some((item) => item.mangaSlug === 'bookmark-for-get-test');
    expect(found).toBe(true);
  });

  it('❌ Báo lỗi 401 nếu không có token', async () => {
    const res = await request(app).get('/api/bookmarks/me');
    expect(res.statusCode).toBe(401);
  });
});

// ─── DELETE BOOKMARK (DELETE /api/bookmarks/:mangaSlug) ──────────────────────
describe('DELETE /api/bookmarks/:mangaSlug', () => {
  const slugToDelete = 'bookmark-to-delete';

  beforeAll(async () => {
    // Tạo bookmark trước để có gì mà xoá
    await request(app)
      .post('/api/bookmarks/toggle')
      .set('Authorization', `Bearer ${token}`)
      .send({ mangaSlug: slugToDelete });
  });

  it('✅ Xoá bookmark thành công', async () => {
    const res = await request(app)
      .delete(`/api/bookmarks/${slugToDelete}`)
      .set('Authorization', `Bearer ${token}`);

    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('message');
  });

  it('✅ Sau khi xoá, không còn trong danh sách', async () => {
    const res = await request(app)
      .get('/api/bookmarks/me')
      .set('Authorization', `Bearer ${token}`);

    const found = res.body.some((item) => item.mangaSlug === slugToDelete);
    expect(found).toBe(false);
  });

  it('❌ Báo lỗi 401 nếu không có token', async () => {
    const res = await request(app)
      .delete(`/api/bookmarks/${slugToDelete}`);

    expect(res.statusCode).toBe(401);
  });
});
