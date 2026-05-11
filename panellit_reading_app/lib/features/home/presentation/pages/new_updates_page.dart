import 'package:flutter/material.dart';

import '../../../../app/router/smooth_page_route.dart';
import '../../data/models/home_content_models.dart';
import '../../../discover/presentation/pages/title_detail_page.dart';
import '../widgets/home_update_card.dart';

class NewUpdatesPage extends StatelessWidget {
  final List<HomeUpdateItem> updates;
  final bool isGuest;
  final VoidCallback onHomeTap;
  final VoidCallback onLibraryTap;
  final VoidCallback onSearchTap;
  final VoidCallback onProfileTap;

  const NewUpdatesPage({
    super.key,
    required this.updates,
    required this.isGuest,
    required this.onHomeTap,
    required this.onLibraryTap,
    required this.onSearchTap,
    required this.onProfileTap,
  });

  void _openDetail(BuildContext context, HomeUpdateItem item) {
    Navigator.of(context).push(
      buildSmoothPageRoute(
        TitleDetailPage(
          detail: item.detail,
          isGuest: isGuest,
          onHomeTap: onHomeTap,
          onLibraryTap: onLibraryTap,
          onSearchTap: onSearchTap,
          onProfileTap: onProfileTap,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _TopBar(),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.73,
                ),
                itemCount: updates.length,
                itemBuilder: (context, index) {
                  final item = updates[index];
                  return HomeUpdateCard(
                    item: item,
                    onTap: () => _openDetail(context, item),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 6, 20, 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            color: const Color(0xFF2F3B46),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 4),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Latest',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8A96A3),
                    letterSpacing: 0.8,
                  ),
                ),
                Text(
                  'New Updates',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1C2333),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
