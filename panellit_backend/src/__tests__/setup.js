/**
 * Jest Global Setup
 * Chạy trước tất cả các test suite.
 * Dùng để khởi tạo môi trường test (database, biến env).
 */
process.env.NODE_ENV = 'test';
process.env.JWT_SECRET = 'test-jwt-secret-for-testing-only';
