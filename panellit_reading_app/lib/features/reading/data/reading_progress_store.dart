class ReadingProgressStore {
  static const String _userEmail = 'user123@gmail.com';
  static final Map<String, int> _savedChapters = {};

  static Future<int?> loadSavedChapter(String title) async {
    return _savedChapters[_keyForTitle(title)];
  }

  static Future<void> saveChapter(String title, int? chapterNumber) async {
    final key = _keyForTitle(title);
    if (chapterNumber == null) {
      _savedChapters.remove(key);
    } else {
      _savedChapters[key] = chapterNumber;
    }
  }

  static String _keyForTitle(String title) {
    final normalized = title
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
    return 'saved_chapter_${normalized}_$_userEmail';
  }
}
