const app = require('./app');
const logger = require('./utils/logger');

// 1. Handle Uncaught Exceptions (lỗi đồng bộ chưa được catch)
process.on('uncaughtException', (err) => {
  logger.error('UNCAUGHT EXCEPTION! 💥 Shutting down...', err);
  process.exit(1);
});

const PORT = process.env.PORT || 3000;

const server = app.listen(PORT, () => {
  logger.info(`🚀 Panellit Backend running on http://localhost:${PORT}`);
});

// 2. Handle Unhandled Rejections (lỗi bất đồng bộ - Promise - chưa được catch)
process.on('unhandledRejection', (err) => {
  logger.error('UNHANDLED REJECTION! 💥 Shutting down...', err);
  server.close(() => {
    process.exit(1);
  });
});
