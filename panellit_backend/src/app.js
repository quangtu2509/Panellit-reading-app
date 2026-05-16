const express = require('express');
const cors = require('cors');
const path = require('path');
const swaggerUi = require('swagger-ui-express');
const swaggerJsdoc = require('swagger-jsdoc');
const logger = require('./utils/logger');
const errorMiddleware = require('./middlewares/error.middleware');
require('dotenv').config();

const authRoutes = require('./routes/auth.routes');
const mangaRoutes = require('./routes/manga.routes');
const historyRoutes = require('./routes/history.routes');
const bookmarkRoutes = require('./routes/bookmark.routes');
const novelRoutes = require('./routes/novel.routes');

const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const compression = require('compression');
const { NotFoundError } = require('./utils/app-error'); // Điểm 3: require ở top-level

const app = express();

// 1. Set security HTTP headers
// Cho phép tải resource từ cross-origin để App Flutter có thể load ảnh bìa tĩnh
app.use(helmet({ crossOriginResourcePolicy: { policy: "cross-origin" } }));

// 2. Limit requests from same API
const limiter = rateLimit({
  max: 5000, // Tăng lên 5000 để thoải mái debug
  windowMs: 15 * 60 * 1000,
  message: 'Quá nhiều yêu cầu từ IP này, vui lòng thử lại sau 15 phút!',
  skip: () => process.env.NODE_ENV === 'test' || process.env.NODE_ENV === 'development', // Tắt khi chạy test hoặc đang dev
});
app.use('/api', limiter);

app.use(cors());
app.use(express.json());

// 3. Compress all responses (Điểm 4)
app.use(compression());

// Simple request logger middleware (Disabled to keep console clean)
/*
app.use((req, res, next) => {
  logger.info(`${req.method} ${req.originalUrl}`);
  next();
});
*/

// Serve static files (PDFs, Images)
app.use('/static', express.static(path.join(__dirname, '../public')));

// Swagger Configuration
const swaggerOptions = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'Panellit API Documentation',
      version: '1.0.0',
      description: 'API for Panellit Manga Reading App',
    },
    servers: [
      {
        url: `http://localhost:${process.env.PORT || 3000}`,
      },
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT',
        },
      },
    },
  },
  apis: ['./src/routes/*.js'], // Path to the API docs
};

const swaggerDocs = swaggerJsdoc(swaggerOptions);
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocs));

// API Routes
app.use('/api/auth', authRoutes);
app.use('/api/manga', mangaRoutes);
app.use('/api/history', historyRoutes);
app.use('/api/bookmarks', bookmarkRoutes);
app.use('/api/novels', novelRoutes);

// Welcome route
app.get('/', (req, res) => {
  res.json({
    message: 'Welcome to Panellit API',
    version: '1.0.0',
    endpoints: ['/api/auth', '/api/manga', '/api/history', '/api/bookmarks', '/health']
  });
});

// Health check
app.get('/health', (req, res) => res.json({ status: 'OK' }));

// 404 handler for undefined routes
app.use((req, res, next) => {
  // Điểm 3: Không require() bên trong callback — đã import ở top-level
  next(new NotFoundError(`Can't find ${req.originalUrl} on this server!`));
});

// Global error handler
app.use(errorMiddleware);

module.exports = app;
