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
│   └── server.js          # Entry point khởi động server
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

### C. History Sync Module
- **Models**: `History`, `Manga`
- **Logic**: Sử dụng kỹ thuật `upsert`. Khi App gửi tiến độ đọc, Backend sẽ kiểm tra xem bản ghi đã tồn tại chưa. Nếu có rồi thì cập nhật số chương/số trang, nếu chưa có thì tạo mới.
- **Endpoint**: `POST /api/history/sync` (Yêu cầu Token trong header `Authorization`).

## 3. Nhật ký cập nhật (Update Logs)
- **[2026-05-03]**: Khởi tạo Backend core structure.
- **[2026-05-03]**: Hạ cấp Prisma xuống v6 để tương thích tốt nhất với cấu hình direct connection và schema truyền thống.
- **[2026-05-03]**: Hoàn thiện tích hợp OTruyen API với xử lý mapping ảnh CDN.
- **[2026-05-03]**: Thêm route chào mừng (`/`) và endpoint `/health`.
- **[2026-05-03]**: Cài đặt `nodemon` và cấu hình lệnh `npm run dev`.
- **[2026-05-07]**: **Client Integration Started**: Flutter app đã hoàn thiện layer Network (Dio + Repository) và sẵn sàng kết nối với Backend.
- **[2026-05-07]**: **Home Feed Endpoint**: Thêm `GET /api/manga/home` — lấy danh sách truyện mới cập nhật từ OTruyen, trả về title, slug, cover, categories, chaptersLatest.

---
*Tài liệu này được cập nhật tự động bởi Assistant mỗi khi có thay đổi quan trọng.*
