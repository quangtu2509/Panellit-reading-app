import 'package:flutter/material.dart';

import '../../../data/models/title_detail_model.dart';
import '../../theme/title_detail_colors.dart';

class DetailStatsGenresActions extends StatelessWidget {
  final TitleDetailModel detail;
  final VoidCallback? onReadTap;

  const DetailStatsGenresActions({
    super.key,
    required this.detail,
    this.onReadTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: TitleDetailColors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: TitleDetailColors.divider),
          ),
          child: Row(
            children: [
              _StatCell(
                value: '${detail.rating}',
                label: 'RATING',
                trailingStar: true,
              ),
              const _StatDivider(),
              _StatCell(value: '${detail.chapters}', label: 'CHAPTERS'),
              const _StatDivider(),
              _StatCell(value: detail.readsLabel, label: 'READS'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: detail.genres.asMap().entries.map((entry) {
              final index = entry.key;
              final genre = entry.value;
              final active = index == 0;
              return Padding(
                padding: EdgeInsets.only(
                  right: index == detail.genres.length - 1 ? 0 : 8,
                ),
                child: _GenreChip(label: genre, active: active),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onReadTap,
                  borderRadius: BorderRadius.circular(14),
                  child: Ink(
                    height: 54,
                    decoration: BoxDecoration(
                      color: TitleDetailColors.brand,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x334F46E5),
                          blurRadius: 18,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.menu_book_outlined, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Read Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: TitleDetailColors.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: TitleDetailColors.divider),
              ),
              child: const Icon(
                Icons.flag_outlined,
                color: TitleDetailColors.chipText,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCell extends StatelessWidget {
  final String value;
  final String label;
  final bool trailingStar;

  const _StatCell({
    required this.value,
    required this.label,
    this.trailingStar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: TitleDetailColors.textPrimary,
                ),
              ),
              if (trailingStar)
                const Text(
                  '☆',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFEEB811),
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: TitleDetailColors.muted,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 46, color: TitleDetailColors.divider);
  }
}

class _GenreChip extends StatelessWidget {
  final String label;
  final bool active;

  const _GenreChip({required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: active
            ? TitleDetailColors.chipActiveBackground
            : TitleDetailColors.chipBackground,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFDCE2EA)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: active
              ? TitleDetailColors.chipActiveText
              : TitleDetailColors.chipText,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
