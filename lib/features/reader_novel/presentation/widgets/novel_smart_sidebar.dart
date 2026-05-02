import 'package:flutter/material.dart';

import '../theme/novel_reading_colors.dart';

/// Smart sidebar for the novel reader.
///
/// Layout:
/// • A thin handle strip anchored to the left edge of the screen.
/// • Long-press (or horizontal drag rightward) on the handle opens a full-height
///   rectangular panel that slides in from the left.
/// • Dragging back or tapping the backdrop closes it.
///
/// The panel interior is intentionally left empty — content will be added later.
class NovelSmartSidebar extends StatefulWidget {
  final Animation<double> animation;
  final bool isOpen;
  final VoidCallback onOpen;
  final VoidCallback onClose;

  const NovelSmartSidebar({
    super.key,
    required this.animation,
    required this.isOpen,
    required this.onOpen,
    required this.onClose,
  });

  @override
  State<NovelSmartSidebar> createState() => _NovelSmartSidebarState();
}

class _NovelSmartSidebarState extends State<NovelSmartSidebar> {
  // Panel width as a fraction of screen width.
  static const double _panelWidthFraction = 0.72;

  // Minimum horizontal drag distance to trigger open.
  static const double _dragThreshold = 18.0;

  double _dragStartX = 0.0;

  void _onDragStart(DragStartDetails details) {
    _dragStartX = details.globalPosition.dx;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (widget.isOpen) return;
    final delta = details.globalPosition.dx - _dragStartX;
    if (delta >= _dragThreshold) {
      widget.onOpen();
    }
  }

  void _onDragEnd(DragEndDetails details) {
    // If user drags left quickly while open, close.
    if (widget.isOpen && details.primaryVelocity != null) {
      if (details.primaryVelocity! < -200) {
        widget.onClose();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final panelWidth = screenWidth * _panelWidthFraction;

    return Stack(
      children: [
        // ── Scrim / backdrop ──────────────────────────────────────────────
        if (widget.isOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: widget.onClose,
              child: AnimatedBuilder(
                animation: widget.animation,
                builder: (context, _) {
                  return ColoredBox(
                    color: Colors.black
                        .withValues(alpha: 0.35 * widget.animation.value),
                  );
                },
              ),
            ),
          ),

        // ── Sliding panel ─────────────────────────────────────────────────
        AnimatedBuilder(
          animation: widget.animation,
          builder: (context, child) {
            final offsetX = panelWidth * (widget.animation.value - 1.0);
            return Positioned(
              left: offsetX,
              top: 0,
              bottom: 0,
              width: panelWidth,
              child: child!,
            );
          },
          child: _SidebarPanel(panelWidth: panelWidth, onClose: widget.onClose),
        ),

        // ── Handle strip (always visible on the left edge) ────────────────
        if (!widget.isOpen)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              onLongPress: widget.onOpen,
              onHorizontalDragStart: _onDragStart,
              onHorizontalDragUpdate: _onDragUpdate,
              onHorizontalDragEnd: _onDragEnd,
              child: const _SidebarHandle(),
            ),
          ),
      ],
    );
  }
}

// ── Handle strip ──────────────────────────────────────────────────────────────

class _SidebarHandle extends StatelessWidget {
  const _SidebarHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      decoration: const BoxDecoration(
        color: NovelReadingColors.sidebarHandle,
        borderRadius: BorderRadius.horizontal(right: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 8,
            offset: Offset(2, 0),
          ),
        ],
      ),
      child: const Center(
        child: RotatedBox(
          quarterTurns: 1,
          child: Icon(
            Icons.drag_handle_rounded,
            size: 16,
            color: NovelReadingColors.sidebarHandleIcon,
          ),
        ),
      ),
    );
  }
}

// ── Sidebar panel ─────────────────────────────────────────────────────────────

class _SidebarPanel extends StatelessWidget {
  final double panelWidth;
  final VoidCallback onClose;

  const _SidebarPanel({required this.panelWidth, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: panelWidth,
      decoration: const BoxDecoration(
        color: NovelReadingColors.sidebarPanel,
        border: Border(
          right: BorderSide(
            color: NovelReadingColors.sidebarPanelBorder,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: NovelReadingColors.sidebarPanelShadow,
            blurRadius: 24,
            offset: Offset(8, 0),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Panel header with close button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: NovelReadingColors.topBarTitle,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    color: NovelReadingColors.topBarIcon,
                    onPressed: onClose,
                  ),
                ],
              ),
            ),
            const Divider(
              color: NovelReadingColors.chapterDivider,
              height: 24,
              indent: 20,
              endIndent: 20,
            ),
            // Placeholder — content will be added later
            const Expanded(
              child: Center(
                child: Text(
                  'Content coming soon…',
                  style: TextStyle(
                    fontSize: 14,
                    color: NovelReadingColors.topBarSubtitle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
