import 'package:flutter/material.dart';

import '../../../../app/router/smooth_page_route.dart';
import '../../../library/presentation/pages/library_page.dart';
import '../../../discover/presentation/pages/search_page.dart';
import '../../../discover/presentation/pages/notifications_page.dart';
import '../../../discover/presentation/pages/title_detail_page.dart';
import '../../../discover/data/models/title_detail_model.dart';
import '../../data/home_mock_data.dart';
import '../../data/models/home_content_models.dart';
import '../theme/home_colors.dart';
import '../widgets/home_bottom_nav.dart';
import '../widgets/home_page_content.dart';
import '../widgets/home_top_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _openHome(BuildContext context) {
    Navigator.of(
      context,
    ).pushReplacement(buildSmoothPageRoute(const HomePage()));
  }

  void _openLibrary(BuildContext context) {
    Navigator.of(
      context,
    ).pushReplacement(buildSmoothPageRoute(const LibraryPage()));
  }

  void _openSearch(BuildContext context, {bool replace = false}) {
    final route = buildSmoothPageRoute(
      SearchPage(
        onHomeTap: () => _openHome(context),
        onLibraryTap: () => _openLibrary(context),
      ),
    );

    if (replace) {
      Navigator.of(context).pushReplacement(route);
    } else {
      Navigator.of(context).push(route);
    }
  }

  void _openNotifications(BuildContext context) {
    Navigator.of(context).push(
      buildSmoothPageRoute(
        NotificationsPage(
          onHomeTap: () => _openHome(context),
          onLibraryTap: () => _openLibrary(context),
          onSearchTap: () => _openSearch(context, replace: true),
        ),
      ),
    );
  }

  void _openDetail(BuildContext context, TitleDetailModel detail) {
    Navigator.of(context).push(
      buildSmoothPageRoute(
        TitleDetailPage(
          detail: detail,
          onHomeTap: () => _openHome(context),
          onLibraryTap: () => _openLibrary(context),
          onSearchTap: () => _openSearch(context, replace: true),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.background,
      body: SafeArea(
        child: Column(
          children: [
            HomeTopBar(
              title: kHomeAppName,
              hasUnreadNotifications: kHomeNotifications.any(
                (notification) =>
                    notification.type ==
                        HomeNotificationType.savedWorkChapterUpdate &&
                    notification.isUnread,
              ),
              onNotificationTap: () => _openNotifications(context),
            ),
            Expanded(
              child: HomePageContent(
                featuredTitle: kHomeFeaturedTitle,
                featuredSubtitle: kHomeFeaturedSubtitle,
                featuredDetail: kHomeFeaturedDetail,
                onOpenDetail: (detail) => _openDetail(context, detail),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNav(
        onLibraryTap: () => _openLibrary(context),
        onSearchTap: () => _openSearch(context),
      ),
    );
  }
}
