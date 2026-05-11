import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/network/models/novel_api_model.dart';
import '../../../../core/network/services/history_api_service.dart';
import '../../../../core/services/user_stats_service.dart';

class PdfReadingPage extends StatefulWidget {
  final ApiNovelModel novel;
  final bool isGuest;

  const PdfReadingPage({
    super.key,
    required this.novel,
    required this.isGuest,
  });

  @override
  State<PdfReadingPage> createState() => _PdfReadingPageState();
}

class _PdfReadingPageState extends State<PdfReadingPage>
    with SingleTickerProviderStateMixin {
  // ── State ─────────────────────────────────────────────────────────────────
  String? _localPath;
  bool _isLoading = true;
  String? _errorMessage;
  double _downloadProgress = 0.0;

  // PDF viewer state
  final PdfViewerController _pdfViewerController = PdfViewerController();
  int _currentPage = 0;
  int _totalPages = 0;

  // Top bar animation
  bool _topBarVisible = true;
  Timer? _topBarTimer;

  @override
  void initState() {
    super.initState();
    _downloadAndOpenPdf();
    UserStatsService.instance.startSession();
  }

  @override
  void dispose() {
    _topBarTimer?.cancel();
    _syncTimer?.cancel();
    _pdfViewerController.dispose();
    UserStatsService.instance.endSession();
    super.dispose();
  }

  // ── Download PDF ─────────────────────────────────────────────────────────

  Future<void> _downloadAndOpenPdf() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _downloadProgress = 0.0;
      });

      final dir = await getTemporaryDirectory();
      // Sanitise filename to avoid special chars breaking the path
      final safeSlug = widget.novel.slug.replaceAll(RegExp(r'[^\w\-]'), '_');
      final filePath = '${dir.path}/$safeSlug.pdf';
      final file = File(filePath);

      // Skip re-download if cached
      if (!await file.exists()) {
        final dio = Dio();
        await dio.download(
          widget.novel.pdfUrl,
          filePath,
          onReceiveProgress: (received, total) {
            if (total > 0 && mounted) {
              setState(() {
                _downloadProgress = received / total;
              });
            }
          },
        );
      }

      if (!mounted) return;
      setState(() {
        _localPath = filePath;
        _isLoading = false;
      });
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Failed to download PDF.\nPlease check your connection.\n(${e.message})';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Unexpected error: $e';
      });
    }
  }

  // ── Top bar auto-hide ────────────────────────────────────────────────────

  void _toggleTopBar() {
    setState(() => _topBarVisible = !_topBarVisible);
    if (_topBarVisible) {
      _topBarTimer?.cancel();
      _topBarTimer = Timer(const Duration(seconds: 4), () {
        if (mounted) setState(() => _topBarVisible = false);
      });
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      body: Stack(
        children: [
          // ── Main Content ──────────────────────────────────────────────────
          _buildBody(),

          // ── Top Bar ───────────────────────────────────────────────────────
          AnimatedSlide(
            offset: _topBarVisible ? Offset.zero : const Offset(0, -1),
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            child: _buildTopBar(context),
          ),

          // ── Bottom Page Indicator ─────────────────────────────────────────
          if (_localPath != null && _totalPages > 0)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedSlide(
                offset: _topBarVisible ? Offset.zero : const Offset(0, 1),
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                child: _buildBottomBar(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return _buildLoading();
    if (_errorMessage != null) return _buildError();
    return _buildPdfViewer();
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circular progress + percentage
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: _downloadProgress > 0 ? _downloadProgress : null,
                  color: const Color(0xFF8B5CF6),
                  strokeWidth: 4,
                  backgroundColor: const Color(0xFF3A3A3C),
                ),
                if (_downloadProgress > 0)
                  Text(
                    '${(_downloadProgress * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF5F5F5),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _downloadProgress > 0 ? 'Downloading...' : 'Preparing...',
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFFAEAEB2),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.novel.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF636366),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 64, color: Color(0xFFFF453A)),
            const SizedBox(height: 16),
            const Text(
              'Cannot open PDF',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF5F5F5),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Unknown error',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFFAEAEB2),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _downloadAndOpenPdf,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Timer? _syncTimer;

  void _syncProgress(int page) {
    if (widget.isGuest) return;
    
    _syncTimer?.cancel();
    _syncTimer = Timer(const Duration(seconds: 2), () async {
      try {
        await HistoryApiService().syncProgress(
          novelSlug: widget.novel.slug,
          lastPageIndex: page,
        );
      } catch (e) {
        debugPrint('Failed to sync progress: $e');
      }
    });
  }

  Widget _buildPdfViewer() {
    return GestureDetector(
      onTap: _toggleTopBar,
      child: SfPdfViewer.file(
        File(_localPath!),
        controller: _pdfViewerController,
        canShowScrollHead: false,
        canShowScrollStatus: false,
        enableTextSelection: true,
        pageLayoutMode: PdfPageLayoutMode.continuous,
        onDocumentLoaded: (PdfDocumentLoadedDetails details) {
          if (mounted) {
            setState(() {
              _totalPages = details.document.pages.count;
              _currentPage = 1;
            });
          }
        },
        onPageChanged: (PdfPageChangedDetails details) {
          if (mounted) {
            setState(() => _currentPage = details.newPageNumber);
            _syncProgress(details.newPageNumber);
          }
        },
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xE61C1C1E), Color(0x001C1C1E)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 16, 24),
          child: Row(
            children: [
              // Back button
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                color: const Color(0xFFF5F5F5),
              ),
              const SizedBox(width: 4),
              // Title + author
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.novel.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFF5F5F5),
                      ),
                    ),
                    Text(
                      widget.novel.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFAEAEB2),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    final progress = _totalPages > 0 ? _currentPage / _totalPages : 0.0;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Color(0xE61C1C1E), Color(0x001C1C1E)],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFF3A3A3C),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
              minHeight: 3,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Page $_currentPage of $_totalPages',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFAEAEB2),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF8B5CF6),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
