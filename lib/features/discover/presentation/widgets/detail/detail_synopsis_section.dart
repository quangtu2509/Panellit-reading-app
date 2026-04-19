import 'package:flutter/material.dart';

import '../../../data/models/title_detail_model.dart';
import '../../theme/title_detail_colors.dart';

class DetailSynopsisSection extends StatelessWidget {
  final TitleDetailModel detail;

  const DetailSynopsisSection({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
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
        Text(
          detail.synopsis,
          style: const TextStyle(
            fontSize: 15,
            color: TitleDetailColors.chipText,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Read more',
          style: TextStyle(
            color: TitleDetailColors.brand,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
