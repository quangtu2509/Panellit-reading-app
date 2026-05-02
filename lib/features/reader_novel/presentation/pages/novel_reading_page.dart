import 'dart:async';

import 'package:flutter/material.dart';

import 'package:panellit_reading_app/features/reading/data/reading_progress_store.dart';
import '../../data/models/novel_reading_model.dart';
import '../theme/novel_reading_colors.dart';
import '../widgets/novel_reader_top_bar.dart';
import '../widgets/novel_reader_content.dart';
import '../widgets/novel_reader_control_bar.dart';
import '../widgets/novel_smart_sidebar.dart';

class NovelReadingPage extends StatefulWidget {
  final NovelReadingModel novel;
  final int initialChapterIndex;
  final bool isGuest;
  final ValueChanged<int?>? onSaveChapter;
  final bool isSaved;

  const NovelReadingPage({
    super.key,
    required this.novel,
    this.initialChapterIndex = 0,
    required this.isGuest,
    this.onSaveChapter,
    this.isSaved = false,
  });

  @override
  State<NovelReadingPage> createState() => _NovelReadingPageState();
}

class _NovelReadingPageState extends State<NovelReadingPage>
    with SingleTickerProviderStateMixin {
  late int _chapterIndex;
  late bool _isSavedLocal;
  bool _showGuestHint = false;
  Timer? _guestHintTimer;

  // Sidebar animation
  late final AnimationController _sidebarController;
  late final Animation<double> _sidebarAnimation;
  bool _isSidebarOpen = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _chapterIndex = widget.initialChapterIndex;
    _isSavedLocal = widget.isGuest ? false : widget.isSaved;

    _sidebarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 240),
    );
    _sidebarAnimation = CurvedAnimation(
      parent: _sidebarController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _sidebarController.dispose();
    _guestHintTimer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant NovelReadingPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isGuest) {
      _isSavedLocal = false;
      return;
    }
    if (oldWidget.isSaved != widget.isSaved) {
      _isSavedLocal = widget.isSaved;
    }
  }

  // ── Chapter helpers ──────────────────────────────────────────────────────

  NovelChapter get _currentChapter =>
      widget.novel.chapters[_chapterIndex];

  bool get _canGoPrev => _chapterIndex > 0;
  bool get _canGoNext =>
      _chapterIndex < widget.novel.chapters.length - 1;

  void _goToPrevChapter() {
    if (!_canGoPrev) return;
    _changeChapter(_chapterIndex - 1);
  }

  void _goToNextChapter() {
    if (!_canGoNext) return;
    _changeChapter(_chapterIndex + 1);
  }

  void _changeChapter(int index) {
    setState(() => _chapterIndex = index);
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  void _openChapterPicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            itemCount: widget.novel.chapters.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (ctx, index) {
              final chapter = widget.novel.chapters[index];
              final isSelected = index == _chapterIndex;
              return ListTile(
                title: Text(
                  '${chapter.label} — ${chapter.title}',
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected
                        ? NovelReadingColors.magicPrimary
                        : NovelReadingColors.controlIcon,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        color: NovelReadingColors.magicPrimary,
                      )
                    : null,
                onTap: () {
                  Navigator.of(ctx).pop();
                  _changeChapter(index);
                },
              );
            },
          ),
        );
      },
    );
  }

  // ── Save / bookmark ──────────────────────────────────────────────────────

  void _onSaveTap() {
    if (widget.isGuest) {
      _triggerGuestHint();
      return;
    }
    setState(() => _isSavedLocal = !_isSavedLocal);
    final nextValue =
        _isSavedLocal ? _currentChapter.number : null;
    widget.onSaveChapter?.call(nextValue);
    ReadingProgressStore.saveChapter(widget.novel.title, nextValue);
  }

  void _triggerGuestHint() {
    _guestHintTimer?.cancel();
    setState(() => _showGuestHint = true);
    _guestHintTimer = Timer(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      setState(() => _showGuestHint = false);
    });
  }

  // ── Sidebar ──────────────────────────────────────────────────────────────

  void _openSidebar() {
    setState(() => _isSidebarOpen = true);
    _sidebarController.forward();
  }

  void _closeSidebar() {
    _sidebarController.reverse().then((unused) {
      if (mounted) setState(() => _isSidebarOpen = false);
    });
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NovelReadingColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                NovelReaderTopBar(
                  title: widget.novel.title,
                  chapterLabel: _currentChapter.label,
                  isSaved: _isSavedLocal,
                  isGuest: widget.isGuest,
                  showGuestHint: _showGuestHint,
                  onSaveTap: _onSaveTap,
                ),
                Expanded(
                  child: NovelReaderContent(
                    chapter: _currentChapter,
                    scrollController: _scrollController,
                  ),
                ),
              ],
            ),
            // Bottom control bar
            Positioned(
              left: 18,
              right: 18,
              bottom: 18,
              child: NovelReaderControlBar(
                chapterLabel: _currentChapter.label,
                canGoPrev: _canGoPrev,
                canGoNext: _canGoNext,
                onPrevTap: _goToPrevChapter,
                onNextTap: _goToNextChapter,
                onChapterTap: _openChapterPicker,
              ),
            ),
            // Smart sidebar
            NovelSmartSidebar(
              animation: _sidebarAnimation,
              isOpen: _isSidebarOpen,
              onOpen: _openSidebar,
              onClose: _closeSidebar,
            ),
          ],
        ),
      ),
    );
  }
}
