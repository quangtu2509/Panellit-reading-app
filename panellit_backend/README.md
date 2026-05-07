# Panellit Backend

A production-ready Node.js backend for the Panellit mobile manga reading app.

## Tech Stack
- **Runtime:** Node.js
- **Framework:** Express.js
- **ORM:** Prisma 7
- **Database:** PostgreSQL
- **Authentication:** JWT & Bcrypt
- **API Client:** Axios with Resiliency (Exponential Backoff)

## Project Structure
```
src/
├── config/         # Database connection (Prisma client)
├── controllers/    # Request handlers (Auth, Manga, History)
├── middlewares/    # Custom middlewares (Auth)
├── routes/         # Express routes
├── services/       # Business logic (OTruyen API, Auth, History)
├── utils/          # Utility functions (Axios client)
├── app.js          # Express app configuration
└── server.js       # Entry point
prisma/
└── schema.prisma   # Database models
```

## Getting Started

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Configure Environment:**
   Edit the `.env` file and set your `DATABASE_URL` and `JWT_SECRET`.

3. **Database Migration:**
   ```bash
   npx prisma migrate dev --name init
   ```

4. **Run the server:**
   ```bash
   npm run dev
   ```

## Features
- **Auth:** Register and Login with password hashing and JWT.
- **Manga Data:** Fetches metadata and chapter images from OTruyen API.
- **Resiliency:** Handles HTTP 429 (Too Many Requests) automatically with exponential backoff.
- **History Sync:** Syncs reading progress (manga, chapter, page index) per user.
