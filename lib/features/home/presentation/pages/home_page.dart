import 'package:flutter/material.dart';

import '../../../../app/router/smooth_page_route.dart';
import '../../../library/presentation/pages/library_page.dart';
import '../../../discover/presentation/pages/search_page.dart';
import '../../../discover/presentation/pages/notifications_page.dart';
import '../../data/home_mock_data.dart';
import '../../data/models/home_content_models.dart';
import '../theme/home_colors.dart';
import '../widgets/home_bottom_nav.dart';
import '../widgets/home_page_content.dart';
import '../widgets/home_top_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
              onNotificationTap: () {
                Navigator.of(context).push(
                  buildSmoothPageRoute(
                    NotificationsPage(
                      onHomeTap: () {
                        Navigator.of(context).pushReplacement(
                          buildSmoothPageRoute(const HomePage()),
                        );
                      },
                      onLibraryTap: () {
                        Navigator.of(context).pushReplacement(
                          buildSmoothPageRoute(const LibraryPage()),
                        );
                      },
                      onSearchTap: () {
                        Navigator.of(context).pushReplacement(
                          buildSmoothPageRoute(
                            SearchPage(
                              onHomeTap: () {
                                Navigator.of(context).pushReplacement(
                                  buildSmoothPageRoute(const HomePage()),
                                );
                              },
                              onLibraryTap: () {
                                Navigator.of(context).pushReplacement(
                                  buildSmoothPageRoute(const LibraryPage()),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            Expanded(
              child: HomePageContent(
                featuredTitle: kHomeFeaturedTitle,
                featuredSubtitle: kHomeFeaturedSubtitle,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNav(
        onLibraryTap: () {
          Navigator.of(
            context,
          ).pushReplacement(buildSmoothPageRoute(const LibraryPage()));
        },
        onSearchTap: () {
          Navigator.of(context).push(
            buildSmoothPageRoute(
              SearchPage(
                onHomeTap: () {
                  Navigator.of(
                    context,
                  ).pushReplacement(buildSmoothPageRoute(const HomePage()));
                },
                onLibraryTap: () {
                  Navigator.of(
                    context,
                  ).pushReplacement(buildSmoothPageRoute(const LibraryPage()));
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
