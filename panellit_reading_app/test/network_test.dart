import 'package:flutter_test/flutter_test.dart';
import 'package:panellit_reading_app/core/network/manga_repository.dart';

void main() {
  // Nhóm các bài test lại với nhau
  group('Manga Network Integration Test', () {
    final repository = MangaRepository();

    test('Lấy dữ liệu thật từ Backend (Solo Leveling)', () async {
      // 1. Gọi Repo
      final result = await repository.getMangaDetail(
        slug: 'toi-thang-cap-mot-minh',
        mockId: 'solo_leveling',
      );

      // 2. Kiểm chứng (Assertions)
      // Nếu Backend đang bật, result.isFromApi phải là true
      print('Kết quả từ API: ${result.isFromApi}');

      if (result.isFromApi) {
        print('--- DATA FETCHED ---');
        print('Title: ${result.apiData?.title}');
        print('Status: ${result.apiData?.status}');
        print('Chapters: ${result.apiData?.chapters.length}');

        expect(result.apiData, isNotNull);
        expect(result.apiData?.title, contains('thăng cấp'));
      } else {
        print('⚠️ LƯU Ý: Đang dùng MockData vì không thấy Backend.');
        expect(result.mockData, isNotNull);
      }
    });

    test('Lấy danh sách ảnh của một chương', () async {
      // Dùng một URL API chương thực tế từ OTruyen
      const testChapterUrl =
          "https://sv1.otruyencdn.com/v1/api/chapter/6568621ae120ddf21985fed6";

      final images = await repository.getChapterImages(testChapterUrl);

      print('Số lượng ảnh lấy được: ${images.length}');
      if (images.isNotEmpty) {
        print('Link ảnh đầu tiên: ${images.first}');
        expect(images, isNotEmpty);
      }
    });
  });
}
