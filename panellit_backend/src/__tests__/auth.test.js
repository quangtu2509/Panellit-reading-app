/**
 * Integration Tests: Auth API
 * Kiểm tra toàn bộ luồng Đăng ký & Đăng nhập thông qua HTTP request thực.
 *
 * Coverage:
 * - POST /api/auth/register
 * - POST /api/auth/login
 * - GET  /api/auth/me
 */
require('./setup');
const request = require('supertest');
const app = require('../app');

// User tạm để test (random email để tránh conflict)
const testUser = {
  email: `testuser_${Date.now()}@panellit.test`,
  password: 'Test@123456',
  name: 'Test User'
};

let authToken = ''; // Lưu JWT sau khi đăng nhập

// ─── REGISTER ────────────────────────────────────────────────────────────────
describe('POST /api/auth/register', () => {
  it('✅ Đăng ký thành công với dữ liệu hợp lệ', async () => {
    const res = await request(app)
      .post('/api/auth/register')
      .send(testUser);

    expect(res.statusCode).toBe(201);
    expect(res.body).toHaveProperty('token');
    expect(res.body).toHaveProperty('user');
    expect(res.body.user.email).toBe(testUser.email);
  });

  it('❌ Báo lỗi 400 nếu email đã tồn tại', async () => {
    const res = await request(app)
      .post('/api/auth/register')
      .send(testUser); // Gửi lại cùng email vừa đăng ký

    expect(res.statusCode).toBe(400);
    expect(res.body).toHaveProperty('message');
  });

  it('❌ Báo lỗi 422 nếu email không hợp lệ (Zod Validation)', async () => {
    const res = await request(app)
      .post('/api/auth/register')
      .send({ email: 'not-an-email', password: '123456' });

    expect(res.statusCode).toBe(422);
    expect(res.body).toHaveProperty('errors');
  });

  it('❌ Báo lỗi 422 nếu mật khẩu quá ngắn (Zod Validation)', async () => {
    const res = await request(app)
      .post('/api/auth/register')
      .send({ email: 'valid@test.com', password: '123' }); // < 6 ký tự

    expect(res.statusCode).toBe(422);
    expect(res.body).toHaveProperty('errors');
  });

  it('❌ Báo lỗi 422 nếu body rỗng (Zod Validation)', async () => {
    const res = await request(app)
      .post('/api/auth/register')
      .send({});

    expect(res.statusCode).toBe(422);
  });
});

// ─── LOGIN ────────────────────────────────────────────────────────────────────
describe('POST /api/auth/login', () => {
  it('✅ Đăng nhập thành công và nhận được token', async () => {
    const res = await request(app)
      .post('/api/auth/login')
      .send({ email: testUser.email, password: testUser.password });

    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('token');
    expect(res.body.user.email).toBe(testUser.email);

    authToken = res.body.token; // Lưu token để dùng cho các test sau
  });

  it('❌ Báo lỗi 401 nếu sai mật khẩu', async () => {
    const res = await request(app)
      .post('/api/auth/login')
      .send({ email: testUser.email, password: 'WrongPassword' });

    expect(res.statusCode).toBe(401);
    expect(res.body).toHaveProperty('message');
  });

  it('❌ Báo lỗi 401 nếu email chưa đăng ký', async () => {
    const res = await request(app)
      .post('/api/auth/login')
      .send({ email: 'nonexistent@panellit.test', password: 'Test@123456' });

    expect(res.statusCode).toBe(401);
  });

  it('❌ Báo lỗi 422 nếu thiếu password (Zod Validation)', async () => {
    const res = await request(app)
      .post('/api/auth/login')
      .send({ email: testUser.email }); // Thiếu password

    expect(res.statusCode).toBe(422);
  });
});

// ─── ME (Lấy thông tin user hiện tại) ───────────────────────────────────────
describe('GET /api/auth/me', () => {
  it('✅ Lấy thông tin thành công khi có token hợp lệ', async () => {
    const res = await request(app)
      .get('/api/auth/me')
      .set('Authorization', `Bearer ${authToken}`);

    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('email', testUser.email);
  });

  it('❌ Báo lỗi 401 nếu không có token', async () => {
    const res = await request(app)
      .get('/api/auth/me');

    expect(res.statusCode).toBe(401);
  });

  it('❌ Báo lỗi 401 nếu token giả mạo', async () => {
    const res = await request(app)
      .get('/api/auth/me')
      .set('Authorization', 'Bearer fake.token.here');

    expect(res.statusCode).toBe(401);
  });
});
