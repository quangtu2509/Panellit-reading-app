import 'package:flutter/material.dart';

import '../../../data/models/title_detail_model.dart';
import '../../theme/title_detail_colors.dart';

class DetailHeaderHero extends StatelessWidget {
  final TitleDetailModel detail;
  final VoidCallback onBackTap;

  const DetailHeaderHero({
    super.key,
    required this.detail,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 330,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8E98A6), Color(0xFFBCC5D3), Color(0xFF9AA2AC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 6, 8, 12),
                  child: Row(
                    children: [
                      _CircleIconButton(
                        icon: Icons.arrow_back_rounded,
                        onTap: onBackTap,
                      ),
                      const Spacer(),
                      const _CircleIconButton(icon: Icons.share_outlined),
                      const SizedBox(width: 10),
                      const _CircleIconButton(icon: Icons.more_vert_rounded),
                    ],
                  ),
                ),
                Container(
                  width: 132,
                  height: 188,
                  decoration: BoxDecoration(
                    color: detail.coverColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (detail.coverUrl != null && detail.coverUrl!.isNotEmpty)
                        Image.network(
                          detail.coverUrl!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              color: detail.coverColor,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white70,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              Container(color: detail.coverColor),
                        ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: TitleDetailColors.brand,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            detail.status,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
          child: Transform.translate(
            offset: const Offset(0, -10),
            child: Column(
              children: [
                Text(
                  detail.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 46,
                    height: 0.95,
                    fontWeight: FontWeight.w800,
                    color: TitleDetailColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    text: 'By ',
                    style: const TextStyle(
                      color: TitleDetailColors.textSecondary,
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: detail.author,
                        style: const TextStyle(
                          color: TitleDetailColors.brand,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                          decorationColor: TitleDetailColors.brand,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _CircleIconButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.25),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}
