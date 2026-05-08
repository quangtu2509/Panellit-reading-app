import 'dart:async';

import 'package:flutter/material.dart';

import 'package:panellit_reading_app/features/discover/data/models/title_detail_model.dart';
import '../theme/reading_colors.dart';
import '../../../../core/network/manga_repository.dart';

class MangaReadingPage extends StatefulWidget {
  final String title;
  final String chapterLabel;
  final int chapterNumber;
  final String? chapterApiData;
  final List<ChapterUpdateModel> allChapters;
  final bool isGuest;
  final ValueChanged<int?>? onSaveChapter;
  final bool isSaved;

  const MangaReadingPage({
    super.key,
    required this.title,
    required this.chapterLabel,
    required this.chapterNumber,
    this.chapterApiData,
    required this.allChapters,
    required this.isGuest,
    this.onSaveChapter,
    this.isSaved = false,
  });

  @override
  State<MangaReadingPage> createState() => _MangaReadingPageState();
}

class _MangaReadingPageState extends State<MangaReadingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _magicController;
  late final Animation<double> _magicExpand;
  bool _isExpanded = false;
  late bool _isSavedLocal;
  bool _showGuestHintVisible = false;
  Timer? _guestHintTimer;
  
  // Track current chapter state dynamically for navigation
  late String _currentChapterLabel;
  late int _currentChapterNumber;
  late String? _currentChapterApiData;
  late int _chapterIndex;

  final ScrollController _scrollController = ScrollController();
  
  List<String> _imageUrls = [];
  bool _isLoadingImages = false;


  @override
  void initState() {
    super.initState();
    _isSavedLocal = widget.isGuest ? false : widget.isSaved;

    _currentChapterLabel = widget.chapterLabel;
    _currentChapterNumber = widget.chapterNumber;
    _currentChapterApiData = widget.chapterApiData;

    // Find the index of current chapter in the full list
    _chapterIndex = widget.allChapters.indexWhere(
      (c) => c.chapterNumber == widget.chapterNumber,
    );
    if (_chapterIndex == -1) _chapterIndex = 0;

    _magicController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _magicExpand = CurvedAnimation(
      parent: _magicController,
      curve: Curves.easeOutCubic,
    );

    _fetchImages();
  }

  Future<void> _fetchImages() async {
    if (_currentChapterApiData == null || _currentChapterApiData!.isEmpty) {
      setState(() {
        _imageUrls = [];
        _isLoadingImages = false;
      });
      return;
    }
    
    setState(() => _isLoadingImages = true);
    final repo = MangaRepository();
    final images = await repo.getChapterImages(_currentChapterApiData!);
    
    if (mounted) {
      setState(() {
        _imageUrls = images;
        _isLoadingImages = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _magicController.dispose();
    _guestHintTimer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MangaReadingPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isGuest) {
      _isSavedLocal = false;
      return;
    }
    if (oldWidget.isSaved != widget.isSaved) {
      _isSavedLocal = widget.isSaved;
    }
  }

  void _showGuestHint() {
    _guestHintTimer?.cancel();
    setState(() {
      _showGuestHintVisible = true;
    });
    _guestHintTimer = Timer(const Duration(milliseconds: 1400), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _showGuestHintVisible = false;
      });
    });
  }

  bool get _canGoPrev => _chapterIndex < widget.allChapters.length - 1;
  bool get _canGoNext => _chapterIndex > 0;

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  void _updateChapterIndex(int nextIndex) {
    if (nextIndex < 0 || nextIndex >= widget.allChapters.length) return;

    final chapter = widget.allChapters[nextIndex];
    setState(() {
      _chapterIndex = nextIndex;
      _currentChapterLabel = chapter.title;
      _currentChapterNumber = chapter.chapterNumber;
      _currentChapterApiData = chapter.chapterApiData;
      _isSavedLocal = false; // Reset saved state for new chapter
    });
    _scrollToTop();
    _fetchImages();
  }


  void _goToNextChapter() {
    if (!_canGoNext) {
      return;
    }
    // In OTruyen, next chapter (higher number) is a smaller index
    _updateChapterIndex(_chapterIndex - 1);
  }

  void _goToPreviousChapter() {
    if (!_canGoPrev) {
      return;
    }
    // In OTruyen, previous chapter (lower number) is a larger index
    _updateChapterIndex(_chapterIndex + 1);
  }

  void _openChapterPicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            itemCount: widget.allChapters.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final chapter = widget.allChapters[index];
              final label = 'Chapter ${chapter.title}';
              final isSelected = index == _chapterIndex;
              return ListTile(
                title: Text(
                  label,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected
                        ? ReadingColors.magicPrimary
                        : ReadingColors.controlIcon,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        color: ReadingColors.magicPrimary,
                      )
                    : null,
                onTap: () {
                  Navigator.of(context).pop();
                  _updateChapterIndex(index);
                },
              );
            },
          ),
        );
      },
    );
  }

  void _toggleMagic() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    if (_isExpanded) {
      _magicController.forward();
    } else {
      _magicController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ReadingColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _ReaderTopBar(
                  title: widget.title,
                  chapterLabel: _currentChapterLabel,
                  isSaved: _isSavedLocal,
                  isGuest: widget.isGuest,
                  showGuestHint: _showGuestHintVisible,
                  onSaveTap: () {
                    if (widget.isGuest) {
                      _showGuestHint();
                      return;
                    }
                    setState(() {
                      _isSavedLocal = !_isSavedLocal;
                    });
                    final nextValue = _isSavedLocal
                        ? _currentChapterNumber
                        : null;
                    widget.onSaveChapter?.call(nextValue);
                  },
                ),
                Expanded(child: _buildPanels()),
              ],
            ),
            Positioned(
              left: 18,
              right: 18,
              bottom: 18,
              child: _ReaderControlBar(
                chapterLabel: _currentChapterLabel,
                onPrevTap: _goToPreviousChapter,
                onNextTap: _goToNextChapter,
                onChapterTap: _openChapterPicker,
                canGoPrev: _canGoPrev,
                canGoNext: _canGoNext,
              ),
            ),
            Positioned(
              right: 20,
              bottom: 96,
              child: _MagicActionStack(
                expand: _magicExpand,
                isExpanded: _isExpanded,
                onToggle: _toggleMagic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPanels() {
    if (_isLoadingImages) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: ReadingColors.magicPrimary),
            SizedBox(height: 16),
            Text(
              'Loading pages...',
              style: TextStyle(
                color: ReadingColors.topBarSubtle,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }
    
    if (_imageUrls.isNotEmpty) {
      return ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(bottom: 140),
        itemCount: _imageUrls.length,
        itemBuilder: (context, index) {
          return Image.network(
            _imageUrls[index],
            width: double.infinity,
            fit: BoxFit.fitWidth,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 300,
              width: double.infinity,
              color: Colors.grey[900],
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.broken_image, color: Colors.white54, size: 48),
                    const SizedBox(height: 8),
                    Text(
                      'Page ${index + 1} failed to load',
                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              final total = loadingProgress.expectedTotalBytes;
              final current = loadingProgress.cumulativeBytesLoaded;
              return Container(
                height: 400,
                width: double.infinity,
                color: const Color(0xFF141E30),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: ReadingColors.magicPrimary,
                        value: total != null ? current / total : null,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Page ${index + 1}',
                        style: const TextStyle(color: Colors.white38, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    }

    // No images available
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported_outlined, color: Colors.grey[400], size: 64),
          const SizedBox(height: 16),
          Text(
            'No pages available for this chapter',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReaderTopBar extends StatelessWidget {
  final String title;
  final String chapterLabel;
  final bool isSaved;
  final bool isGuest;
  final bool showGuestHint;
  final VoidCallback onSaveTap;

  const _ReaderTopBar({
    required this.title,
    required this.chapterLabel,
    required this.isSaved,
    required this.isGuest,
    required this.showGuestHint,
    required this.onSaveTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                color: ReadingColors.controlIcon,
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: ReadingColors.topBarText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      chapterLabel,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ReadingColors.topBarSubtle,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      isSaved ? Icons.bookmark_rounded : Icons.bookmark_border,
                    ),
                    color: isGuest
                        ? ReadingColors.controlIcon.withValues(alpha: 0.35)
                        : (isSaved
                              ? const Color(0xFFF2B705)
                              : ReadingColors.controlIcon),
                    onPressed: onSaveTap,
                  ),
                  AnimatedOpacity(
                    opacity: showGuestHint ? 1 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: const Text(
                      'login to use',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: ReadingColors.topBarSubtle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Pull down to see previous chapter',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ReadingColors.topBarSubtle,
            ),
          ),
        ],
      ),
    );
  }
}


class _ReaderControlBar extends StatelessWidget {
  final String chapterLabel;
  final VoidCallback onPrevTap;
  final VoidCallback onNextTap;
  final VoidCallback onChapterTap;
  final bool canGoPrev;
  final bool canGoNext;

  const _ReaderControlBar({
    required this.chapterLabel,
    required this.onPrevTap,
    required this.onNextTap,
    required this.onChapterTap,
    required this.canGoPrev,
    required this.canGoNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: ReadingColors.controlBar,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          _ControlIconButton(
            icon: Icons.skip_previous_rounded,
            onTap: onPrevTap,
            isEnabled: canGoPrev,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: InkWell(
              onTap: onChapterTap,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F4F8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.menu_book_rounded,
                      size: 18,
                      color: ReadingColors.controlIcon,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      chapterLabel,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: ReadingColors.controlIcon,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: ReadingColors.controlIcon,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          _ControlIconButton(
            icon: Icons.skip_next_rounded,
            onTap: onNextTap,
            isEnabled: canGoNext,
          ),
        ],
      ),
    );
  }
}

class _ControlIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isEnabled;

  const _ControlIconButton({
    required this.icon,
    required this.onTap,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isEnabled ? const Color(0xFFF1F4F8) : const Color(0xFFE1E7EF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          color: isEnabled
              ? ReadingColors.controlIcon
              : ReadingColors.controlIcon.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}

class _MagicActionStack extends StatelessWidget {
  final Animation<double> expand;
  final bool isExpanded;
  final VoidCallback onToggle;

  const _MagicActionStack({
    required this.expand,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      height: 200,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomRight,
        children: [
          _MagicActionButton(
            expand: expand,
            offset: 140,
            label: 'Brightness',
            icon: Icons.wb_sunny_rounded,
            tint: const Color(0xFF2A74F5),
          ),
          _MagicActionButton(
            expand: expand,
            offset: 76,
            label: 'Translate',
            icon: Icons.translate_rounded,
            tint: const Color(0xFF7C3AED),
          ),
          _MagicFab(isExpanded: isExpanded, onTap: onToggle),
        ],
      ),
    );
  }
}

class _MagicActionButton extends StatelessWidget {
  final Animation<double> expand;
  final double offset;
  final String label;
  final IconData icon;
  final Color tint;

  const _MagicActionButton({
    required this.expand,
    required this.offset,
    required this.label,
    required this.icon,
    required this.tint,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: expand,
      builder: (context, child) {
        final value = expand.value;
        final translateY = -offset * value;
        final scale = 0.65 + (0.35 * value);
        return IgnorePointer(
          ignoring: value == 0,
          child: Transform.translate(
            offset: Offset(0, translateY),
            child: Opacity(
              opacity: value.clamp(0.0, 1.0),
              child: Transform.scale(scale: scale, child: child),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: ReadingColors.actionShadow,
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: tint.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: tint, size: 20),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: ReadingColors.actionText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MagicFab extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onTap;

  const _MagicFab({required this.isExpanded, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [ReadingColors.magicPrimary, ReadingColors.magicSecondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: ReadingColors.magicGlow,
              blurRadius: 22,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: isExpanded
              ? const Icon(
                  Icons.close_rounded,
                  key: ValueKey('close'),
                  color: Colors.white,
                  size: 32,
                )
              : const Icon(
                  Icons.auto_fix_high_rounded,
                  key: ValueKey('magic'),
                  color: Colors.white,
                  size: 30,
                ),
        ),
      ),
    );
  }
}

