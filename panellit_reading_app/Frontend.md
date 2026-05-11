## 🚧 Current Focus (Mục tiêu hiện tại)
- **Task đang thực hiện**: Phase 16 — Backend & Frontend Sync (Light Novels & Bugs)
- **Trạng thái**: Hoàn thành
- **Tệp đang tác động chính**: `library_page.dart`
- **Vấn đề đang gặp (Nếu có)**: Đã hoàn tất và fix xong lỗi `Null Check`.

# Frontend Development Progress - Panellit Reading App

## 📋 Tổng Quan (Overview)

**Tên Dự Án**: Panellit Reading App  
**Mô Tả**: Ứng dụng di động cho phép người dùng đọc và theo dõi truyện tranh (Comics) và Light Novels  
**Tech Stack**:

- **Framework**: Flutter + Dart
- **UI Library**: Material 3
- **Navigation**: Navigator dengan Custom Route Transitions
- **State Management**: StatefulWidget (setState)
- **Architecture**: Feature-based Clean Code (data/models, data, presentation/theme, presentation/widgets, presentation/pages)

---

## 🎯 Trạng Thái Hiện Tại (Current State)

### ✅ Modules Đã Hoàn Thành

#### 1. **Home Module** (`lib/features/home/`)

- **Pages**:
  - `home_page.dart` - Shell page với top bar, content, bottom nav
- **Widgets**:
  - `home_top_bar.dart` - Top bar với bell icon (thông báo) có badge đỏ
  - `home_bottom_nav.dart` - Bottom navigation với 4 tabs (Home, Library, Search, Profile)
  - `home_page_content.dart` - Composed content widget
  - `home_featured_banner.dart` - Featured banner section
  - `home_updates_section.dart` - Updates section
  - `home_popular_manga_section.dart` - Popular manga section
  - `home_top_webnovels_section.dart` - Top webnovels section
- **Data**:
  - `home_content_models.dart` - HomeUpdateItem, HomeRankItem, HomeNovelItem, HomeNotificationItem
  - `home_mock_data.dart` - Mock data với kHomeNotifications
- **Features**:
  - ✅ Bottom navigation với routing
  - ✅ Notification bell với red dot badge (chỉ hiện khi có chapter mới)
  - ✅ Smooth page transitions
  - ✅ Sections layout cleanly separated
  - ✅ Tapping featured banner/Read Now/updates/popular/webnovels → Detail screen

#### 2. **Library Module** (`lib/features/library/`)

- **Pages**:
  - `library_page.dart` - Shell page với 3 tabs (Following, Reading, Completed)
- **Widgets**:
  - `library_top_bar.dart` - Top bar với bell icon clickable
  - `library_bottom_nav.dart` - Bottom navigation (Home, Library, Search, Profile)
  - `library_tab_section.dart` - Shared scaffold cho các tab
  - `library_recommend_banner.dart` - Banner phía trên danh sách Following
  - `library_item.dart`, `library_reading_item.dart`, `library_completed_item.dart` - Item models
  - `library_card.dart`, `library_reading_card.dart`, `library_completed_card.dart` - Card widgets
- **Data**:
  - `library_item.dart`, `library_reading_item.dart`, `library_completed_item.dart` - Library models
  - `library_mock_data.dart` - Mock data cho 3 tabs
- **Features**:
  - ✅ Tab navigation (Following, Reading, Completed)
  - ✅ Sort functionality cho mỗi tab
  - ✅ Bell icon routing đến Notifications
  - ✅ Bottom nav routing đến Home/Search/Profile
  - ✅ Tapping any Library item → Detail screen

#### 3. **Discover Module** (`lib/features/discover/`)

##### 3.1 Search Feature

- **Pages**:
  - `search_page.dart` - Stateful search page với input, suggestions, results
- **Widgets** (`presentation/widgets/search/`):
  - `search_top_bar.dart` - Top bar với back button
  - `search_input_bar.dart` - Input field để nhập query
  - `search_suggestion_panel.dart` - Dropdown với suggestions
  - `search_results_section.dart` - Danh sách kết quả tìm kiếm
  - `search_default_section.dart` - Section hiện khi chưa tìm gì
  - `search_bottom_nav.dart` - Bottom navigation
- **Data**:
  - `search_models.dart` - SearchResultModel, SearchSuggestionModel
  - `search_mock_data.dart` - kSearchResultsCatalog, kSearchSuggestionSeeds, kSearchRecentKeywords
- **Theme**:
  - `search_colors.dart` - Search color palette
- **Features**:
  - ✅ Query input với TextEditingController
  - ✅ Suggestion dropdown khi typing
  - ✅ Filtered results based on query
  - ✅ Navigation đến detail page khi tap result

##### 3.2 Notifications Feature

- **Pages**:
  - `notifications_page.dart` - Notifications screen khi bell được tap
- **Features**:
  - ✅ App-bar-like header
  - ✅ Notifications list
  - ✅ Floating action button
  - ✅ Bottom nav

##### 3.3 Detail Feature (Title Detail Page)

- **Pages**:
  - `title_detail_page.dart` - Main detail shell page
- **Widgets** (`presentation/widgets/detail/`):
  - `detail_header_hero.dart` - Hero section với cover, back/share/more buttons, status badge, author/title
  - `detail_stats_genres_actions.dart` - Stats row, horizontally scrollable genres, action buttons
  - `detail_synopsis_section.dart` - **[NEW]** Synopsis với "Read more / Show less" expand/collapse (chỉ hiện khi text dài)
  - `detail_chapters_section.dart` - **[UPDATED]** Chapters list vertical scroll, sort Newest/Oldest popup menu
  - `detail_reviews_section.dart` - **[NEW]** Community Reviews với larger composer, guest/login prompt, See All under title
  - `detail_related_section.dart` - **[NEW]** "Related comics" horizontal swipe, centered cards
  - `detail_bottom_nav.dart` - Bottom navigation
- **Data**:
  - `title_detail_model.dart` - TitleDetailModel, ChapterUpdateModel, ReviewSummaryModel, CommunityReviewModel, RelatedStoryModel, ChapterSortOption enum
  - `title_detail_mock_data.dart` - Mock data cho "The Beginning After The End" (có extended chapters)
- **Theme**:
  - `title_detail_colors.dart` - Detail color palette
- **Features**:
  - ✅ Hero header với cover & controls
  - ✅ Stats, genres (horizontal scroll), action buttons
  - ✅ Read Now opens Manga reading screen
  - ✅ Chapter list tap → open reading screen for that chapter
  - ✅ Saved chapter highlighted in yellow
  - ✅ **[NEW]** Synopsis expand/collapse (Read more / Show less)
  - ✅ **[NEW]** Chapters vertical scrollable list (không còn horizontal)
  - ✅ **[NEW]** Chapter sort popup (Newest / Oldest)
  - ✅ **[NEW]** Community Reviews section với larger composer
  - ✅ **[NEW]** Guest vs logged-in review states
  - ✅ **[NEW]** Related comics (thay vì Related Stories)
  - ✅ **[NEW]** Related comics centered horizontal swipe layout
  - ✅ **[NEW]** **PDF Novel Support**: Tự động nhận diện trường `pdfUrl`. Nếu có, nút "Read Now" sẽ mở `PdfReadingPage` thay vì Manga/Novel text reader.

#### 4. **Profile Module** (`lib/features/profile/`)

- **Pages**:
  - `profile_page.dart` - Shell page với guest vs logged-in modes
- **Widgets**:
  - `profile_bottom_nav.dart` - Bottom navigation (Home, Library, Search)
  - `profile_top_bar.dart` - Top bar với settings icon (part of profile_page)
  - `_GuestSection` - Guest login prompt component
  - `_ProfileContent` - Logged-in profile UI component
- **Data**:
  - (No specific data files - Profile state controlled via `isGuest` flag)
- **Theme**:
  - `profile_colors.dart` - Profile color palette
- **Features**:
  - ✅ Guest mode - Shows "You are browsing as a guest" + Login button
  - ✅ Logged-in mode - Shows avatar, stats, profile sections, logout
  - ✅ Seamless navigation from Home/Library/Search/Detail

#### 5. **Auth Module** (`lib/features/auth/`)

- **Pages**:
  - `login_page.dart` - Auth entry point
- **Features**:
  - ✅ Email/Password login form
  - ✅ Mock account: user123@gmail.com / user123
  - ✅ Sign Up / Forgot Password links
  - ✅ Social login buttons
  - ✅ **[NEW]** "Login as Guest" button
  - ✅ Guest continuation - Passes `isGuest: true` to HomePage
  - ✅ Login success - Passes `isGuest: false` to HomePage

#### 7. **Reading Module** (`lib/features/reading/`)
...
#### 8. **Network Layer** (`lib/core/network/`)

- **Components**:
  - `api_client.dart` - Singleton Dio client với base URL (support emulator/localhost)
  - `manga_repository.dart` - Repository điều phối dữ liệu giữa API thực và Mock fallback
  - `services/manga_api_service.dart` - Service gọi các endpoint manga/chapter từ Backend
  - `services/novel_api_service.dart` - **[NEW]** Service gọi các endpoint `/api/novels`
  - `models/manga_api_model.dart` - DTO models cho API response (ApiMangaDetail, ApiChapter, etc.)
  - `models/novel_api_model.dart` - **[NEW]** DTO model cho Novel data (ApiNovelModel)
- **Features**:
  - ✅ Tích hợp thư viện `dio` để gọi API.
  - ✅ Cơ chế **Graceful Fallback**: Tự động dùng MockData nếu Backend không phản hồi.
  - ✅ Extract Chapter ID từ URL linh hoạt.
  - ✅ Mapping dữ liệu từ OTruyen API JSON sang Flutter models.


#### 7. **Shared/Common** (`lib/app/`, `lib/shared/`)

- **Router**:
  - `smooth_page_route.dart` - Custom page route builder với fade + slide transitions
- **Features**:
  - ✅ Smooth transitions giữa các screens

---

## 🚀 Task Timeline

### Phase 1: Library Tabs & Home Alignment ✅

- [x] Implement Reading tab với sort logic
- [x] Implement Completed tab với sort logic
- [x] Unify Home & Library bottom navigation style
- [x] Add smooth page transitions
- [x] Implement notification bell badge logic

### Phase 2: Code Refactoring ✅

- [x] Split Home page thành HomePageContent + sections
- [x] Split Library page thành tab-based structure
- [x] Create shared LibraryTabSection widget
- [x] Remove deprecated `withOpacity`, use `withValues(alpha: ...)`
- [x] Analyzer cleanup

### Phase 3: Search Feature ✅

- [x] Create Search page từ đầu
- [x] Implement search input với TextEditingController
- [x] Add suggestion dropdown
- [x] Add results filtering
- [x] Wire search navigation từ Home/Library
- [x] Clean code refactor Search thành widgets riêng

### Phase 4: Notifications Feature ✅

- [x] Create Notifications page
- [x] Wire bell icon navigation từ Home/Library

### Phase 5: Detail Page & UX Polish ✅

- [x] Create Detail page shell
- [x] Implement hero header
- [x] Implement stats, genres, actions row
- [x] Create synopsis section
- [x] Create chapters section (horizontal)
- [x] Create reviews section
- [x] Create related stories section
- [x] **[NEW]** Implement "Read more / Show less" toggle ở Synopsis
- [x] **[NEW]** Change chapters từ horizontal sang vertical scroll
- [x] **[NEW]** Improve Community Reviews layout
- [x] **[NEW]** Rename "Related Stories" → "Related comics"
- [x] **[NEW]** Fix chapter box spacing (remove extra whitespace)

### Phase 6: Profile & Guest State Management ✅

- [x] Create Profile module (feature-based architecture)
- [x] Implement guest mode UI (login prompt)
- [x] Implement logged-in profile UI (avatar, stats, sections, logout)
- [x] Implement ProfilePage với isGuest flag support
- [x] Update LoginPage với "Login as Guest" button
- [x] Wire isGuest state through Home/Library/Search/Notifications/Detail routes
- [x] Update HomePage với isGuest parameter
- [x] Update LibraryPage với isGuest parameter
- [x] Update SearchPage với isGuest parameter
- [x] Update NotificationsPage với isGuest parameter
- [x] Update TitleDetailPage với isGuest parameter
- [x] Add profile navigation callbacks to all bottom nav widgets
- [x] Ensure seamless profile navigation from all screens
- [x] Fix all navigation wiring: onProfileTap propagation

### Phase 7: Manga Reading Screen ✅

- [x] Create MangaReadingPage UI
- [x] Add animated magic button (expand upward)
- [x] Add brightness + translate quick actions
- [x] Wire Read Now button to reading screen
- [x] Enable chapter selector + prev/next controls
- [x] Add save chapter bookmark + highlight in detail list

### Phase 8: Novel Reading Screen ✅

- [x] Create `NovelReadingColors` — novel-specific color palette (`novel_reading_colors.dart`)
- [x] Create `NovelReadingModel` + `NovelChapter` data models (`novel_reading_model.dart`)
- [x] Create rich mock data — "Elara and the Forgotten Kingdom" with 5 full prose chapters (`novel_mock_data.dart`)
- [x] Create `NovelReaderTopBar` — ← back arrow (replaces hamburger), centred title/chapter, bookmark icon identical to manga reader
- [x] Create `NovelReaderContent` — scrollable chapter text (header, paragraph body, word-count footer)
- [x] Create `NovelReaderControlBar` — prev/next + chapter picker bottom bar, mirrors manga reader
- [x] Create `NovelSmartSidebar` — thin handle strip on left edge; long-press or drag-right opens full-height panel with smooth slide animation + scrim; tap scrim or close button to dismiss
- [x] Wire `TitleDetailPage` "Read Now" button to route correctly to `NovelReadingPage` (instead of MangaReadingPage) for novel genres
- [x] Create `NovelReadingPage` — composes all widgets, manages chapter state, save/bookmark state, sidebar open/close, guest-hint logic

### Phase 16: Backend & Frontend Sync (Light Novels & Bugs) ✅

- [x] Sửa lỗi null check khi truy xuất `manga.title` và `manga.cover` trong `library_page.dart`.
- [x] Hiển thị chính xác tiến trình và metadata của Light Novel trong các tab "Bookmarks" và "Continue Reading" (sử dụng Null-safe operators).
- [x] Sửa lỗi Syntax (trùng biến `mangaSlug`) trong `history.controller.js` ở Backend.
- [x] Tích hợp `UserStatsService` vào `PdfReadingPage` để tính giờ đọc và chuỗi streak cho Novel.
- [x] Tích hợp `HistoryApiService` vào `PdfReadingPage` để tự động lưu vị trí trang PDF (progress sync) lên Database.
- [x] Cập nhật API Search để kết hợp và phân loại kết quả Manga và Novel (`isNovel: true`).

### Phase 15: PDF Reading Support (Light Novels) ✅

- [x] Tích hợp thư viện `flutter_pdfview` để hiển thị file PDF.
- [x] Tích hợp thư viện `path_provider` để lưu tạm (cache) file PDF đã tải về.
- [x] Create `PdfReadingPage` — Trang đọc PDF chuyên dụng:
    - [x] Hiển thị tiến trình tải file (Download Progress %) bằng `Dio.download`.
    - [x] Giao diện Premium: Tự động ẩn Top bar sau 4 giây, cử chỉ chạm để hiện lại.
    - [x] Page Indicator & Progress Bar ở dưới cùng.
- [x] Cập nhật `TitleDetailModel`: Thêm trường `pdfUrl`.
- [x] Cập nhật `TitleDetailPage`: Logic `_openReading` ưu tiên mở PDF nếu `pdfUrl` tồn tại.
- [x] Create `NovelApiService` + `ApiNovelModel` để kết nối với backend novel endpoints.

### Phase 13: Fix Cover Image, Chapter Ordering & Reading Screen ✅

- [x] Thêm `coverUrl` (optional) vào `TitleDetailModel` để truyền URL ảnh bìa thật từ API.
- [x] Cập nhật `DetailHeaderHero` — hiển thị ảnh bìa thật bằng `Image.network` với loading/error fallback, thay vì chỉ hiện màu `coverColor`.
- [x] Fix thứ tự chapter trong `TitleDetailPage._fetchApiData`: dùng index tuần tự (1-based) thay vì đếm ngược (`idx--`) gây đảo số.
- [x] Hiển thị đúng `chapterName` từ API (ví dụ: "1.1", "2.1") thay vì số index giả.
- [x] Truyền `coverUrl` qua tất cả skeleton models: `home_page.dart`, `search_page.dart`, `category_results_page.dart`.
- [x] Fix `MangaReadingPage` chapter label: hiển thị tên chapter thật thay vì "Chapter N" giả.
- [x] Xóa hardcoded slug mapping (`solo_leveling` → `toi-thang-cap-mot-minh`) — slug đã đến trực tiếp từ API.
- [x] **Fix ảnh chapter trong reading screen**: Thêm backend endpoint `GET /api/manga/image-proxy?url=...` để proxy ảnh CDN với Referer header, bypass hotlink protection.
- [x] Cập nhật `MangaRepository.getChapterImages` — rewrite CDN URLs thành proxy URLs qua backend.
- [x] Cải thiện `MangaReadingPage._buildPanels()`: `BoxFit.fitWidth` (full-width), progress indicator với phần trăm, error state rõ ràng.
- [x] Xóa bỏ các widget mock panel cũ (`_PanelSpec`, `_ReadingPanel`, `_panels`, `dart:math` import).

### Phase 12: Xóa bỏ hoàn toàn Mock Data ✅

- [x] Gỡ bỏ các import và tham chiếu đến `MockDatabase`, `kSearchSuggestionSeeds`, `kSearchResultsCatalog`, `kHomeUpdates`, `kHomePopularManga`, `kLibraryFollowing`, v.v.
- [x] Xóa toàn bộ các file mock data (`mock_database.dart`, `search_mock_data.dart`, `title_detail_mock_data.dart`, `home_mock_data.dart`, `library_mock_data.dart`, `novel_mock_data.dart`).
- [x] Thay thế fallback UI tạm thời bằng các state rỗng (empty array `[]`) hoặc skeleton models (trong `category_results_page.dart`, `title_detail_page.dart`).
- [x] Xóa bỏ fallback của mock DB trong `MangaRepository`.

### Phase 11: Tích hợp API Search OTruyen ✅

- [x] Thêm `searchManga()` vào `OTruyenService` (Node.js) — gọi `/tim-kiem?keyword=`.
- [x] Thêm `searchManga()` vào `MangaController` (Node.js).
- [x] Đăng ký route `GET /api/manga/search` **trước** `/:slug` để tránh route collision.
- [x] Tạo `ApiSearchResult` + `ApiSearchResponse` models trong Flutter (`search_api_model.dart`).
- [x] Tạo `SearchApiService` gọi `GET /api/manga/search`.
- [x] Thêm `slug` + `coverUrl` vào `SearchResultModel`.
- [x] Cập nhật `_SearchResultCard` để hiển thị **ảnh bìa thật** bằng `Image.network`.
- [x] Viết lại `SearchPage`: thay filter mock bằng `_searchService.searchManga()` với **debounce 500ms**.
- [x] Loading spinner trong khi chờ API response.
- [x] **Graceful Fallback**: Nếu API thất bại, tự động filter mock catalog local.
- [x] Navigation từ kết quả tìm kiếm → `TitleDetailPage` (dùng skeleton model nếu không có trong mock DB).
- [x] `kSearchResultsCatalog` vẫn được giữ lại làm fallback, không xóa.

### Phase 10: "Thật hóa" Trang Chủ (Home Screen Live Data) ✅

- [x] Thêm Backend endpoint `GET /api/manga/home` lấy danh sách truyện mới cập nhật từ OTruyen.
- [x] Thêm `getHomeFeed()` vào `OTruyenService` (Node.js) trả về title, slug, cover, categories, chaptersLatest.
- [x] Thêm `getHomeFeed()` vào `MangaController` (Node.js).
- [x] Tạo `ApiHomeFeedItem` + `ApiLatestChapter` models trong Flutter (`home_feed_model.dart`).
- [x] Tạo `HomeFeedService` gọi `GET /api/manga/home`.
- [x] Thêm `coverUrl` vào `HomeUpdateItem` model.
- [x] Cập nhật `HomeUpdateCard` để hiển thị **ảnh bìa thật** bằng `Image.network` (có loading + error fallback).
- [x] Cập nhật `HomeUpdatesSection` nhận `items` từ ngoài thay vì đọc hardcoded mock.
- [x] Cập nhật `HomePopularMangaSection` nhận `items` từ ngoài.
- [x] Cập nhật `HomePageContent` nhận `updateItems` + `popularItems`.
- [x] Chuyển `HomePage` từ `StatelessWidget` → `StatefulWidget` với `_fetchHomeFeed()` async.
- [x] **Graceful Fallback**: Hiển thị Mock Data ngay khi load, tráo bằng API data sau khi nhận được.
- [x] Khi nhấn vào item API trên Home → Tạo skeleton `TitleDetailModel` → `TitleDetailPage` tự fetch data thật.
- [x] Thêm `INTERNET` permission + `android:usesCleartextTraffic="true"` vào `AndroidManifest.xml`.

### Phase 9: Integration & Network Layer ✅

- [x] Thêm dependency `dio` vào dự án.
- [x] Tạo `ApiClient` (singleton) cấu hình `baseUrl` cho localhost/emulator.
- [x] Tạo `MangaApiModel` để parse dữ liệu từ Backend.
- [x] Triển khai `MangaApiService` cho các endpoint Manga & Chapter.
- [x] Xây dựng `MangaRepository` với logic "API First, Mock Fallback".
- [x] Kiểm tra và fix lỗi import/analyze toàn bộ layer network.


## 🛠️ Issues & Fixes

### Resolved Issues

1. **Missing Route Helper** → Restored `smooth_page_route.dart`
2. **Deprecated API** → Replaced `withOpacity` → `withValues(alpha: ...)`
3. **Chapter Box Extra Whitespace** → Changed từ fixed height → ConstrainedBox với maxHeight
4. **Synopsis Not Expandable** → Implemented real TextPainter overflow detection + toggle
5. **Chapters Horizontal Instead of Vertical** → Changed scrollDirection & layout

### Phase 17: Fix Network Connectivity (Real Device vs Emulator) ✅

- [x] **Xác định nguyên nhân**: App dùng `http://10.0.2.2:3000` (URL chỉ dành cho Android Emulator), không hoạt động khi test trên thiết bị thật (real device).
- [x] **Sửa `api_client.dart`**: Đổi `baseUrl` sang `http://172.16.3.106:3000` (IP máy tính trên Wi-Fi).
- [x] **Thêm comment hướng dẫn**: Cấu trúc rõ ràng 3 môi trường (Emulator / Real Device / Web).
- [x] **Thêm debug logging**: Thay `catch (_) {}` bằng `debugPrint` trong `_fetchHomeFeed()` để lỗi mạng hiển thị trong Flutter console.

> ⚠️ **Lưu ý quan trọng**: Mỗi khi IP máy tính thay đổi (đổi mạng Wi-Fi), phải cập nhật `baseUrl` trong `api_client.dart`. IP hiện tại: `172.16.3.106`.

### Validation Status

- ✅ `flutter analyze` → No issues found (Latest check: April 30, 2026)
- ✅ All Discover module files formatted & error-checked
- ✅ Navigation wiring verified across Home/Library/Search/Notifications/Detail
- ✅ Guest state (isGuest flag) propagated through all navigation routes
- ✅ Profile module integrated with bottom nav across all screens
- ✅ **[2026-05-11]**: **Light Novel PDF Support**: 
    - Hoàn thành trình đọc PDF Premium (`PdfReadingPage`) với download progress.
    - Tích hợp `NovelApiService` để fetch dữ liệu novel từ PostgreSQL.
    - Cập nhật `TitleDetailPage` tự động chuyển chế độ đọc PDF/Manga dựa trên dữ liệu backend.
- ✅ LoginPage wiring: Guest mode & Login mode both navigate correctly
- ✅ All bottom nav widgets accept and use onProfileTap callback

---

## 📱 Navigation Architecture

### State Management Pattern

```
LoginPage
  ├─ Login as Guest → HomePage(isGuest: true)
  └─ Login Success → HomePage(isGuest: false)

HomePage(isGuest)
  ├─ Bottom Nav: Home/Library/Search/Profile
  ├─ Bell Icon → Notifications
  ├─ onProfileTap → ProfilePage
  └─ onDetailTap → TitleDetailPage

LibraryPage(isGuest)
  ├─ Bottom Nav: Home/Library/Search/Profile
  ├─ Bell Icon → Notifications
  ├─ Taps → TitleDetailPage(isGuest)
  └─ onProfileTap → ProfilePage

SearchPage(isGuest)
  ├─ Result tap → TitleDetailPage(isGuest)
  └─ onProfileTap → ProfilePage

NotificationsPage(isGuest)
  └─ onProfileTap → ProfilePage

TitleDetailPage(isGuest)
  ├─ Read Now → MangaReadingPage
  └─ onProfileTap → ProfilePage

ProfilePage(isGuest)
  ├─ Guest Mode: Login button → LoginPage
  └─ Logged-in Mode: Logout → LoginPage
```

### Guest vs Logged-in Behavior

- **Guest Mode**:
  - `isGuest = true` throughout navigation stack
  - Reviews section shows login/signup prompt
  - Profile screen shows "You are browsing as a guest" + Login button
  - Tapping Login → Returns to LoginPage → Login/Register flow

- **Logged-in Mode**:
  - `isGuest = false` throughout navigation stack
  - Full UI features enabled (reviews composer, favorites, etc.)
  - Profile screen shows user avatar, stats, sections, logout button
  - Tapping Logout → Returns to LoginPage

---

## 📝 Code Organization

### File Structure Pattern

Each feature follows:

```
lib/features/{feature_name}/
├── data/
│   ├── models/
│   │   └── {model}.dart
│   └── {feature}_mock_data.dart
├── presentation/
│   ├── pages/
│   │   ├── {page}_page.dart
│   │   └── {feature}_page.dart
│   ├── widgets/
│   │   ├── {feature}_bottom_nav.dart
│   │   ├── {feature}_top_bar.dart
│   │   └── {sub_section}/
│   ├── theme/
│   │   └── {feature}_colors.dart
│   └── ...
└── ...
```

### Navigation Callback Pattern

All page constructors accept:

- `onHomeTap` - Go to Home
- `onLibraryTap` - Go to Library
- `onSearchTap` - Go to Search
- `onProfileTap` - Go to Profile
- `isGuest` - Current guest state (for UI conditionals)

Example:

```dart
class MyPage extends StatelessWidget {
  final bool isGuest;
  final VoidCallback onHomeTap;
  final VoidCallback onLibraryTap;
  final VoidCallback onSearchTap;
  final VoidCallback onProfileTap;

  const MyPage({
    required this.isGuest,
    required this.onHomeTap,
    required this.onLibraryTap,
    required this.onSearchTap,
    required this.onProfileTap,
  });
}
```

---

## 🎓 Development Guidelines

### Adding New Features - Checklist

1. **Create Feature Structure**:
   - [ ] `lib/features/{feature_name}/` folder
   - [ ] `data/models/{model}.dart` files
   - [ ] `data/{feature}_mock_data.dart` with kSampleData
   - [ ] `presentation/pages/{feature}_page.dart`
   - [ ] `presentation/widgets/` folder with component widgets
   - [ ] `presentation/theme/{feature}_colors.dart`

2. **Navigation Wiring**:
   - [ ] Accept `isGuest`, `onHomeTap`, `onLibraryTap`, `onSearchTap`, `onProfileTap` in constructor
   - [ ] Create `_openHome()`, `_openLibrary()`, `_openSearch()`, `_openProfile()` helper methods
   - [ ] Pass `isGuest` to child routes
   - [ ] Pass callbacks to bottom nav widget
   - [ ] Update all route calls to use `buildSmoothPageRoute()`

3. **Bottom Nav Widget**:
   - [ ] Create `{feature}_bottom_nav.dart`
   - [ ] Accept `onHomeTap`, `onLibraryTap`, `onSearchTap`, `onProfileTap`
   - [ ] Implement Material 3 bottom nav style

4. **Testing & Validation**:
   - [ ] Run `flutter analyze` - must be zero issues
   - [ ] Run `flutter format lib/` for consistency
   - [ ] Test all navigation transitions
   - [ ] Test guest vs logged-in states
   - [ ] Verify smooth page transitions

5. **Documentation**:

- [ ] Update Frontend.md after every screen change

### Common Patterns

#### Pattern 1: Page-to-Page Navigation

```dart
void _openDetailPage(DataModel data) {
  Navigator.of(context).push(
    buildSmoothPageRoute(
      DetailPage(
        data: data,
        isGuest: widget.isGuest,
        onHomeTap: _openHome,
        onLibraryTap: _openLibrary,
        onSearchTap: _openSearch,
        onProfileTap: _openProfile,
      ),
    ),
  );
}
```

#### Pattern 2: Bottom Nav Implementation

```dart
bottomNavigationBar: MyBottomNav(
  onHomeTap: _openHome,
  onLibraryTap: _openLibrary,
  onSearchTap: _openSearch,
  onProfileTap: _openProfile,
),
```

#### Pattern 3: Guest-Conditional UI

```dart
if (widget.isGuest)
  GuestLoginPrompt(onLoginTap: _openProfile)
else
  LoggedInContent()
```

#### Pattern 4: Mock Data Usage

```dart
class MyPage extends StatelessWidget {
  final MyModel item;

  const MyPage({
    required this.item,
    // ... other params
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          // Use item.field to display data
        ],
      ),
    );
  }
}

// Usage - pass mock data constant
MyPage(item: kDefaultMockItem)
```

### Colors Convention

Each feature has `{feature}_colors.dart` with:

```dart
class {Feature}Colors {
  static const Color primary = Color(0xFF0F6F9B);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF31363A);
  // ...
}
```

Use throughout feature UI instead of hardcoded colors.

### Widget Decomposition Pattern

Break down large screens into logical widget files:

```dart
// ✅ Good: Split by section
// detail_header_hero.dart
// detail_synopsis_section.dart
// detail_chapters_section.dart

// ❌ Avoid: Monolithic page file with 2000+ lines
```

### State Management Pattern for Navigation

```dart
class MyPage extends StatefulWidget {
  final bool isGuest;
  final VoidCallback onHomeTap;
  // ...

  const MyPage({
    required this.isGuest,
    required this.onHomeTap,
    // ...
  });

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  // Local state (UI state)
  late bool _isExpanded = false;

  // Navigation helpers
  void _openHome() {
    Navigator.of(context).pushReplacement(
      buildSmoothPageRoute(HomePage(isGuest: widget.isGuest)),
    );
  }

  void _openDetail(DataModel data) {
    Navigator.of(context).push(
      buildSmoothPageRoute(
        DetailPage(
          data: data,
          isGuest: widget.isGuest,
          onHomeTap: _openHome,
          // Pass all callbacks down
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(),
      bottomNavigationBar: MyBottomNav(
        onHomeTap: _openHome,
        // Pass all callbacks
      ),
    );
  }

  Widget _buildContent() {
    // Separate build method keeps things clean
    return ListView(
      children: [
        // Content here
      ],
    );
  }
}
```

---

## 📊 Module Structure

```
lib/
├── app/
│   └── router/
│       └── smooth_page_route.dart ✅
├── features/
│   ├── home/
│   │   ├── data/
│   │   │   ├── home_content_models.dart ✅
│   │   │   └── home_mock_data.dart ✅
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── home_page.dart ✅
│   │       ├── theme/ (inherited from app theme)
│   │       └── widgets/ ✅
│   │           ├── home_top_bar.dart
│   │           ├── home_bottom_nav.dart
│   │           ├── home_page_content.dart
│   │           ├── home_featured_banner.dart
│   │           ├── home_updates_section.dart
│   │           ├── home_popular_manga_section.dart
│   │           └── home_top_webnovels_section.dart
│   ├── library/
│   │   ├── data/
│   │   │   ├── library_item.dart ✅
│   │   │   ├── library_reading_item.dart ✅
│   │   │   ├── library_completed_item.dart ✅
│   │   │   └── library_mock_data.dart ✅
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── library_page.dart ✅
│   │       └── widgets/ ✅
│   │           ├── library_top_bar.dart
│   │           ├── library_bottom_nav.dart
│   │           ├── library_tab_section.dart
│   │           ├── library_recommend_banner.dart
│   │           ├── library_card.dart
│   │           ├── library_reading_card.dart
│   │           └── library_completed_card.dart
│   └── discover/
│       ├── data/
│       │   ├── models/ ✅
│       │   │   ├── search_models.dart
│       │   │   ├── title_detail_model.dart (+ ChapterSortOption)
│       │   └── *.dart
│       │       ├── search_mock_data.dart
│       │       └── title_detail_mock_data.dart
│       └── presentation/
│           ├── pages/
│           │   ├── search_page.dart ✅
│           │   ├── notifications_page.dart ✅
│           │   └── title_detail_page.dart ✅
│           ├── theme/
│           │   ├── search_colors.dart
│           │   └── title_detail_colors.dart
│           └── widgets/
│               ├── search/ ✅
│               │   ├── search_top_bar.dart
│               │   ├── search_input_bar.dart
│               │   ├── search_suggestion_panel.dart
│               │   ├── search_results_section.dart
│               │   ├── search_default_section.dart
│               │   └── search_bottom_nav.dart
│               └── detail/ ✅
│                   ├── detail_header_hero.dart
│                   ├── detail_stats_genres_actions.dart
│                   ├── detail_synopsis_section.dart (Read more/Show less)
│                   ├── detail_chapters_section.dart (Vertical scroll + Sort)
│                   ├── detail_reviews_section.dart (Larger composer)
│                   ├── detail_related_section.dart (Related comics)
│                   └── detail_bottom_nav.dart
│   ├── reading/
│   │   ├── data/
│   │   │   └── reading_progress_store.dart ✅
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── manga_reading_page.dart ✅
│   │       └── theme/
│   │           └── reading_colors.dart ✅
│   └── reader_novel/
│       ├── data/
│       │   ├── models/
│       │   │   └── novel_reading_model.dart ✅
│       │   └── novel_mock_data.dart ✅
│       └── presentation/
│           ├── pages/
│           │   └── novel_reading_page.dart ✅
│           ├── theme/
│           │   └── novel_reading_colors.dart ✅
│           └── widgets/
│               ├── novel_reader_top_bar.dart ✅ (← back, title, bookmark)
│               ├── novel_reader_content.dart ✅ (scrollable prose)
│               ├── novel_reader_control_bar.dart ✅ (prev/next/picker)
│               └── novel_smart_sidebar.dart ✅ (drag/long-press left panel)
├── core/
│   ├── network/
│   │   ├── api_client.dart ✅
│   │   ├── manga_repository.dart ✅
│   │   ├── models/
│   │   │   └── manga_api_model.dart ✅
│   │   └── services/
│   │       └── manga_api_service.dart ✅

```

---

## 📝 Key Features Implemented

### Navigation & Routing

- ✅ Bottom navigation routing (Home ↔ Library ↔ Search)
- ✅ Notification bell routing → Notifications page
- ✅ Search result → Detail page
- ✅ Home/Library items → Detail page
- ✅ Read Now → Manga reading screen
- ✅ Smooth page transitions (fade + slide)

### Home Screen

- ✅ Featured banner
- ✅ Updates section (Latest manga releases)
- ✅ Popular manga section (Ranked list)
- ✅ Top webnovels section
- ✅ Notification badge on bell icon
- ✅ Tapping featured banner/Read Now/items → Detail page with per-title data

### Library Screen

- ✅ Following tab (Bookmarked titles)
- ✅ Reading tab (In-progress titles with sort)
- ✅ Completed tab (Finished titles with sort)
- ✅ Unified bottom navigation
- ✅ Tapping items in all tabs → Detail page with per-title data

### Search Screen

- ✅ Query input field
- ✅ Suggestion dropdown (Shows related keywords)
- ✅ Filtered results display
- ✅ Result item with cover, title, author
- ✅ Navigation to detail page

### Notifications Screen

- ✅ List of notifications
- ✅ Floating action button
- ✅ Bottom navigation

### Detail Page

- ✅ Hero cover image + back/share/more buttons
- ✅ Status badge (Ongoing/Completed)
- ✅ Title + Author
- ✅ Rating + stats row
- ✅ Genre pills (horizontal scroll)
- ✅ Action buttons (Read Now, Add to Library)
- ✅ **[NEW]** Synopsis with "Read more / Show less" toggle
- ✅ **[NEW]** Chapters list (vertical scroll with newest/oldest sort)
- ✅ **[NEW]** Community reviews (larger composer, guest/login states)
- ✅ **[NEW]** Related comics (horizontal swipe, centered layout)
- ✅ **[NEW]** Bottom navigation

### Manga Reading Screen

- ✅ Top bar with title + chapter
- ✅ Scrollable manga panels (placeholder gradients)
- ✅ Bottom chapter controls (prev/next + selector)
- ✅ Magic action button with smooth upward animation
- ✅ Quick actions: Brightness + Translate (UI only)

---

## 🔄 Code Quality

### Clean Code Practices Applied

- ✅ Feature-based folder structure
- ✅ Separation of concerns (data/presentation)
- ✅ Models in separate files
- ✅ Widgets in separate files by feature/section
- ✅ Theme/colors in separate files
- ✅ Reusable components (smooth_page_route, library_tab_section)
- ✅ Proper naming conventions
- ✅ `dart format` applied to all files
- ✅ `flutter analyze` passing with no issues

### State Management

- Currently using `StatefulWidget` + `setState`
- Suitable for current feature scope
- Future: Consider Provider/Riverpod if complexity increases

---

## 📋 Next Steps / Backlog

### High Priority

- [x] ~~Connect to backend APIs (replace mock data)~~ ✅ **DONE** - API integration complete
- [x] ~~Implement real login/authentication flow~~ → Backend ready, Flutter pending
- [ ] Tích hợp Search thật (gọi API OTruyen search)
- [ ] Đồng bộ lịch sử đọc qua Backend (Auth + History endpoints)
- [ ] Implement reading progress tracker with Backend sync

### Medium Priority

- [ ] Add animations to transitions
- [ ] Implement image caching/optimization
- [ ] Add error handling screens (network errors, etc.)
- [ ] Implement pagination/infinite scroll for lists
- [ ] Add dark mode support

### Low Priority

- [ ] Localization (i18n)
- [ ] Accessibility improvements
- [ ] Performance optimization
- [ ] Unit tests
- [ ] Widget tests

---

## 📌 Last Updated

**Date**: May 2, 2026  
**Latest Changes**:

- Added `typeLabel` field (Novel/Manga) to `SearchResultModel`
- Updated `kSearchResultsCatalog` — all 5 titles have `typeLabel` + type in genres; Elara added
- Added `_TypeBadge` widget in `search_results_section.dart` — purple pill for Novel, blue for Manga
- Updated `kSearchSuggestionSeeds` — Novel/Manga + Elara added as searchable keywords
- Created `CategoryResultsPage` — shows all titles matching a genre with "All "X" Results:" header
- Updated `HomeTopBar` — added ☰ hamburger icon left of brand; `PopupMenuButton` dropdown with Novel/Manga first, icons per category, distinct colors
- Updated `HomePage` — added `_openCategory()` helper, wired `onCategoryTap` to `HomeTopBar`

- Built NovelReadingPage with ← back arrow top bar, save bookmark (guest-aware), chapter picker
- Created NovelSmartSidebar: thin left-edge handle, long-press or drag-right to open, tap backdrop or close button to dismiss
- Created NovelReaderContent: scrollable prose with paragraph rendering and word-count footer
- Created NovelReaderControlBar: prev/next + chapter picker, mirrors manga reader
- Created NovelReadingColors palette for novel reader
- Created NovelReadingModel + NovelChapter data models
- Created rich 5-chapter mock data — "Elara and the Forgotten Kingdom"
- Updated Frontend.md module structure and phase log

- Resume prompt now appears on Detail screen entry
- Temporary in-memory store for saved chapters (no SharedPreferences)
- Persist saved chapter by title for logged-in users (mock account)
- Guest save icon is disabled with hint text
- Added resume prompt when opening a saved chapter
- Reader bookmark icon now toggles immediately on tap
- Save chapter now toggles off when tapped again
- Added chapter save bookmark + highlight in detail list
- Chapter list taps now open the selected chapter in reader
- Clean-code refactor for MangaReadingPage
- Chapter controls now functional (prev/next + picker)
- Built MangaReadingPage and reading palette
- Added magic button with animated actions (Brightness/Translate)
- Wired Read Now → Manga reading screen
- Added Profile module with guest/logged-in UI states
- Wired `isGuest` through Home, Library, Search, Notifications, and Detail routes
- Added LoginPage guest/login routing to HomePage
- Updated bottom nav callbacks to include Profile navigation
- Fixed chapter box spacing (removed extra whitespace with ConstrainedBox)
- Changed chapters from horizontal to vertical scroll layout
- Enabled Home/Library items to open Detail screen
- Passed per-title detail models from Home/Library items
- All files formatted & analyzer-validated ✅

---

## 📞 Developer Notes

### Important Patterns Used

1. **Page Shell Pattern**: Main page composes top bar + content + bottom nav
2. **Tab Section Pattern**: Shared LibraryTabSection widget used by all 3 tabs
3. **Smooth Transitions**: Custom PageRouteBuilder in smooth_page_route.dart
4. **Mock Data**: All data sourced from mock files (kXxx constants)
5. **Color Theming**: Centralized color files per feature (search_colors.dart, title_detail_colors.dart)

### Tips for Continuation

- When adding new features, follow the feature-based folder structure
- Always format with `dart format` before committing
- Run `flutter analyze` to catch issues early
- Update mock data as needed; actual backend will replace these later
- Keep bottom navigation consistent across all pages
- Smooth transitions enhance UX significantly—maintain the pattern

---

**Status**: 🟢 Production-Ready Frontend (MVP Phase)
