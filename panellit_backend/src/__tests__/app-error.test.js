/**
 * Unit Tests: AppError Classes
 * Kiểm tra các class lỗi tùy chỉnh hoạt động đúng.
 */
require('./setup');
const {
  AppError,
  BadRequestError,
  UnauthorizedError,
  NotFoundError,
  ForbiddenError,
} = require('../utils/app-error');

describe('AppError', () => {
  it('✅ Tạo AppError với statusCode và message đúng', () => {
    const err = new AppError('Something went wrong', 503);
    expect(err.message).toBe('Something went wrong');
    expect(err.statusCode).toBe(503);
    expect(err.isOperational).toBe(true);
    expect(err).toBeInstanceOf(Error);
  });
});

describe('BadRequestError', () => {
  it('✅ Có statusCode = 400 và status = "fail"', () => {
    const err = new BadRequestError('Invalid data');
    expect(err.statusCode).toBe(400);
    expect(err.status).toBe('fail');
    expect(err.message).toBe('Invalid data');
  });
});

describe('UnauthorizedError', () => {
  it('✅ Có statusCode = 401', () => {
    const err = new UnauthorizedError('Not logged in');
    expect(err.statusCode).toBe(401);
    expect(err.message).toBe('Not logged in');
  });
});

describe('NotFoundError', () => {
  it('✅ Có statusCode = 404', () => {
    const err = new NotFoundError('Resource not found');
    expect(err.statusCode).toBe(404);
    expect(err.message).toBe('Resource not found');
  });
});

describe('ForbiddenError', () => {
  it('✅ Có statusCode = 403', () => {
    const err = new ForbiddenError('Access denied');
    expect(err.statusCode).toBe(403);
    expect(err.message).toBe('Access denied');
  });
});
