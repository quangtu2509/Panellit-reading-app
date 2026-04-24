import 'package:flutter/material.dart';

import '../../../data/models/title_detail_model.dart';
import '../../theme/title_detail_colors.dart';

class DetailSynopsisSection extends StatefulWidget {
  final TitleDetailModel detail;

  const DetailSynopsisSection({super.key, required this.detail});

  @override
  State<DetailSynopsisSection> createState() => _DetailSynopsisSectionState();
}

class _DetailSynopsisSectionState extends State<DetailSynopsisSection> {
  static const int _collapsedLines = 4;
  bool _expanded = false;
  bool _canToggle = false;

  void _measureOverflow(BoxConstraints constraints, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: widget.detail.synopsis, style: style),
      textDirection: TextDirection.ltr,
      maxLines: _collapsedLines,
    )..layout(maxWidth: constraints.maxWidth);

    final canToggle = textPainter.didExceedMaxLines;
    if (canToggle != _canToggle) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _canToggle = canToggle;
            if (!_canToggle) {
              _expanded = false;
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const synopsisStyle = TextStyle(
      fontSize: 15,
      color: TitleDetailColors.chipText,
      height: 1.5,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        _measureOverflow(constraints, synopsisStyle);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Synopsis',
              style: TextStyle(
                fontSize: 33,
                fontWeight: FontWeight.w800,
                color: TitleDetailColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              child: Text(
                widget.detail.synopsis,
                maxLines: _expanded ? null : _collapsedLines,
                overflow: _expanded
                    ? TextOverflow.visible
                    : TextOverflow.ellipsis,
                style: synopsisStyle,
              ),
            ),
            if (_canToggle) ...[
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
                child: Text(
                  _expanded ? 'Show less' : 'Read more',
                  style: const TextStyle(
                    color: TitleDetailColors.brand,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
