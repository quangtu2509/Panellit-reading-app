const express = require('express');
const cors = require('cors');
const path = require('path');
const swaggerUi = require('swagger-ui-express');
const swaggerJsdoc = require('swagger-jsdoc');
require('dotenv').config();

const authRoutes = require('./routes/auth.routes');
const mangaRoutes = require('./routes/manga.routes');
const historyRoutes = require('./routes/history.routes');
const bookmarkRoutes = require('./routes/bookmark.routes');
const novelRoutes = require('./routes/novel.routes');

const app = express();

app.use(cors());
app.use(express.json());

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

// Global error handler
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Internal Server Error' });
});

module.exports = app;
