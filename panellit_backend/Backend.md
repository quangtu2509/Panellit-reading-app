## 🚧 Current Focus (Mục tiêu hiện tại)
- **Task đang thực hiện**: Tối ưu hóa Backend cho Real Device Testing.
- **Trạng thái**: Hoàn thành đồng bộ hóa IP và fix lỗi mapping.
- **Tệp đang tác động chính**: `manga.controller.js`, `novel.controller.js`
- **Vấn đề đang gặp (Nếu có)**: Đã đảm bảo Backend có thể truy cập được từ thiết bị trong cùng mạng Wi-Fi.

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
│   ├── middlewares/       # Các Middleware xử lý trung gian (Auth)
│   ├── routes/            # Định nghĩa các luồng API (Tầng Route)
│   ├── services/          # Xử lý logic nghiệp vụ và gọi API ngoài (Tầng Service)
│   ├── utils/             # Các công cụ tiện ích (Axios client, backoff logic)
│   ├── app.js             # Khởi tạo Express app và đăng ký middleware/route
│   ├── server.js          # Entry point khởi động server
├── public/                # Thư mục lưu trữ file tĩnh (Local Storage)
│   └── uploads/
│       ├── novels/        # Lưu trữ file PDF Light Novel
│       └── covers/        # Lưu trữ ảnh bìa novel
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

---
*Tài liệu này được cập nhật tự động bởi Assistant mỗi khi có thay đổi quan trọng.*
