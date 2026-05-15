## 🚧 Current Focus (Mục tiêu hiện tại)
- **Task đang thực hiện**: Phase 22 — Refactor Code Controllers
- **Trạng thái**: Hoàn thành. Đã áp dụng `catchAsync` cho toàn bộ các file Controller, loại bỏ hoàn toàn `try-catch` lặp lại.
- **Tệp đang tác động chính**: `manga.controller.js`, `novel.controller.js`, `history.controller.js`, `bookmark.controller.js`
- **Vấn đề đang gặp (Nếu có)**: Không có lỗi. Mọi thứ đã sạch sẽ và thống nhất.

# Panellit Backend Documentation

Hệ thống Backend cho ứng dụng Panellit được xây dựng theo kiến trúc MVC Layered, tập trung vào hiệu suất và khả năng tích hợp dữ liệu từ bên thứ ba (OTruyen).

## 1. Kiến trúc thư mục (Folder Structure)
```
panellit_backend/
├── prisma/
│   └── schema.prisma      # Định nghĩa các Model Database
├── src/
│   ├── config/            # Cấu hình DB (Prisma Client)
│   ├── controllers/       # Xử lý Request/Response (Tầng Controller)
│   ├── middlewares/       # Các Middleware xử lý trung gian (Auth, Validate)
│   ├── routes/            # Định nghĩa các luồng API (Tầng Route)
│   ├── services/          # Xử lý logic nghiệp vụ và gọi API ngoài (Tầng Service)
│   ├── utils/             # Các công cụ tiện ích (Axios client, backoff logic)
│   ├── validators/        # Zod Schemas cho từng module (Auth, History, Bookmark)
│   ├── app.js             # Khởi tạo Express app và đăng ký middleware/route
│   ├── server.js          # Entry point khởi động server
├── public/                # Thư mục lưu trữ file tĩnh (Local Storage)
│   └── uploads/
│       ├── novels/        # Lưu trữ file PDF Light Novel
│       └── covers/        # Lưu trữ ảnh bìa novel
├── logs/              # ✅ MỚI: Lưu trữ log hệ thống (error.log, combined.log)
├── .env                   # Chứa các biến môi trường (Database URL, JWT Secret)
└── README.md              # Hướng dẫn cài đặt và vận hành
```

## 2. Chi tiết hoạt động các Module

### A. Manga Data Aggregation (OTruyen Integration)
- **Service**: `otruyen.service.js`
- **Hoạt động**: 
    - Lấy dữ liệu từ `https://otruyenapi.com/v1/api/truyen-tranh/{slug}`.
    - Chuyển đổi toàn bộ đường dẫn ảnh tương đối thành URL tuyệt đối thông qua CDN.
    - Cấu trúc dữ liệu trả về được chuẩn hóa để App Flutter dễ dàng hiển thị.
- **Resiliency**: Tích hợp `axios-retry` với chiến lược **Exponential Backoff**. Khi gặp lỗi `429 (Too Many Requests)` từ server OTruyen, backend sẽ tự động chờ và thử lại (tối đa 3 lần) trước khi trả lỗi về cho user.

### B. Authentication Module (JWT & Bcrypt)
- **Models**: `User`
- **Security**: 
    - Mật khẩu được mã hóa bằng **Bcrypt** trước khi lưu vào DB.
    - Sử dụng **JWT (JSON Web Token)** để xác thực. Token có thời hạn 7 ngày.
- **Endpoints**:
    - `POST /api/auth/register`: Đăng ký tài khoản.
    - `POST /api/auth/login`: Đăng nhập, nhận token và thông tin user.

### C. History & Bookmark Module
- **Models**: `History`, `Bookmark`, `Manga`, `Novel`
- **Logic**: Sử dụng kỹ thuật `upsert`. 
    - Hỗ trợ lưu trữ đa thực thể (Manga & Novel) thông qua `mangaSlug` và `novelSlug`.
    - Khi App gửi tiến độ đọc, Backend sẽ kiểm tra xem bản ghi đã tồn tại chưa. Nếu có rồi thì cập nhật số chương/số trang, nếu chưa có thì tạo mới.
- **Endpoint**: `POST /api/history/sync` và `POST /api/bookmarks/toggle` (Yêu cầu Token trong header `Authorization`).

### D. Novel & PDF Storage Module
- **Models**: `Novel`
- **Storage Strategy**: Local Storage (Thư mục `public/uploads`).
- **Features**:
    - **Upload**: Sử dụng `multer` để nhận file PDF (giới hạn 50MB) và ảnh bìa.
    - **Static Serving**: Cấu hình Express phục vụ file tĩnh qua prefix `/static`.
    - **Database**: Lưu metadata và đường dẫn tuyệt đối (Public URL) vào PostgreSQL.
- **Endpoints**:
    - `POST /api/novels/upload`: Upload PDF và metadata (Yêu cầu Auth).
    - `GET /api/novels`: Lấy danh sách toàn bộ novel.
    - `GET /api/novels/:slug`: Lấy chi tiết 1 novel theo slug.

## 3. Nhật ký cập nhật (Update Logs)
- **[2026-05-03]**: Khởi tạo Backend core structure, hạ cấp Prisma xuống v6, tích hợp OTruyen API.
- **[2026-05-07]**: **Home Feed Endpoint**: Thêm `GET /api/manga/home`.
- **[2026-05-08]**: **Search & Image Proxy**: Thêm API `/search` và `/image-proxy` để xử lý CDN.
- **[2026-05-11]**: **Novel & PDF Support & Real Device Optimization**: 
    - Thêm model `Novel` vào Prisma schema.
    - Cấu hình local storage cho file PDF bằng Multer.
    - Mở rộng model `History` và `Bookmark` hỗ trợ tùy chọn `novelSlug` bên cạnh `mangaSlug`.
    - Cập nhật `HistoryController` và `BookmarkController` để chấp nhận payload từ Flutter App cho cả Manga và Light Novel.
    - Mở rộng chức năng tìm kiếm kết hợp trả về cả Manga từ OTruyen và Novel từ Database nội bộ (có cờ `isNovel: true`).
    - Khắc phục lỗi `SyntaxError` trùng lặp biến trong `history.controller.js`.
    - **Optimization**: Đã xác nhận cơ chế phục vụ file tĩnh thông qua IP máy chủ để thiết bị thật tải được ảnh/PDF.
- **[2026-05-15]**: **Phase 19 — Input Validation (Zod)**:
    - Cài đặt thư viện `zod` vào `dependencies`.
    - Tạo `src/middlewares/validate.middleware.js`: hàm `validate(schema)` wrapper dùng chung cho mọi route.
    - Tạo `src/validators/auth.validator.js`: schema cho `register`, `login`, `updateName`, `updatePassword` (gồm kiểm tra định dạng email, min-length password, trim whitespace).
    - Tạo `src/validators/history.validator.js`: schema cho `syncHistory` với `.refine()` để kiểm tra điều kiện phụ thuộc lẫn nhau (ít nhất 1 trong `mangaSlug`/`novelSlug`).
    - Tạo `src/validators/bookmark.validator.js`: schema cho `toggleBookmark` với `.refine()` tương tự.
    - Cập nhật `auth.routes.js`, `history.routes.js`, `bookmark.routes.js` để gắn middleware `validate()` vào đúng vị trí (sau Auth middleware, trước Controller).
    - Kiểm tra `node -e "require('./src/app.js')"` → OK, không lỗi syntax.
- **[2026-05-15]**: **Phase 20 — Centralized Error Handling & Logging (Winston)**:
    - Cài đặt `winston` để quản lý log chuyên nghiệp.
    - Tạo `src/utils/logger.js`: Cấu hình log ra console (màu sắc) và file (`logs/error.log`).
    - Tạo `src/utils/app-error.js`: Hệ thống các Class lỗi (`BadRequest`, `Unauthorized`, `NotFound`, v.v.).
    - Tạo `src/utils/catch-async.js`: Wrapper loại bỏ `try-catch` dư thừa trong Controller.
    - Tạo `src/middlewares/error.middleware.js`: Xử lý tập trung các lỗi Zod, Prisma và Custom Error.
    - Cập nhật `server.js`: Thêm `uncaughtException` và `unhandledRejection` để bảo vệ server.
    - Refactor `auth.controller.js`: Áp dụng `catchAsync` làm sạch code.
- **[2026-05-15]**: **Phase 21 — Security (Helmet + Rate Limiting)**:
    - Cài đặt `helmet` và `express-rate-limit`.
    - Cấu hình `helmet` trong `app.js` với `crossOriginResourcePolicy` để không cản trở App Flutter lấy ảnh.
    - Cấu hình `Global Rate Limiter` trong `app.js`: Giới hạn 150 req/15 phút.
    - Cấu hình `Auth Rate Limiter` trong `auth.routes.js`: Giới hạn nghiêm ngặt 10 req/15 phút cho `/login` và `/register` để chống dò mật khẩu.
- **[2026-05-15]**: **Phase 22 — Refactor Code Controllers**:
    - Viết lại `manga.controller.js`, `novel.controller.js`, `history.controller.js`, `bookmark.controller.js` bằng cách sử dụng `catchAsync`.
    - Thay thế các khối `try-catch` dư thừa và các lệnh trả về lỗi thủ công (`res.status(400).json(...)`) bằng cách `throw new AppError(...)`.
    - Code ngắn gọn hơn, sạch sẽ hơn và được chuẩn hóa đồng bộ với Global Error Middleware.

---
*Tài liệu này được cập nhật tự động bởi Assistant mỗi khi có thay đổi quan trọng.*
