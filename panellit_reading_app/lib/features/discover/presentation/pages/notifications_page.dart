import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  final bool isGuest;
  final VoidCallback onHomeTap;
  final VoidCallback onLibraryTap;
  final VoidCallback onSearchTap;
  final VoidCallback onProfileTap;

  const NotificationsPage({
    super.key,
    required this.isGuest,
    required this.onHomeTap,
    required this.onLibraryTap,
    required this.onSearchTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.menu_rounded, size: 30),
                    color: const Color(0xFF0F6F9B),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Panellit',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F6F9B),
                    ),
                  ),
                  const Spacer(),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF3FB),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.notifications_rounded,
                          color: Color(0xFF0F6F9B),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Color(0xFF0F6F9B),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 96),
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF31363A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Stay updated with your favorite stories\nand community.',
                    style: TextStyle(
                      fontSize: 20,
                      height: 1.35,
                      color: Color(0xFF6678A0),
                    ),
                  ),
                  const SizedBox(height: 34),
                  _SectionHeader(
                    icon: Icons.menu_book_outlined,
                    title: 'New Chapters',
                    actionLabel: 'Mark all as read',
                    onActionTap: () {},
                  ),
                  const SizedBox(height: 16),
                  ..._chapterNotifications.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _ChapterNotificationCard(item: item),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _SectionHeader(
                    icon: Icons.settings_outlined,
                    title: 'System Updates',
                    actionLabel: '',
                    onActionTap: () {},
                  ),
                  const SizedBox(height: 16),
                  ..._systemNotifications.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _SystemNotificationCard(item: item),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0A6F95), Color(0xFF37A3D0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(Icons.tune_rounded, color: Colors.white, size: 30),
      ),
      bottomNavigationBar: _NotificationBottomNav(
        onHomeTap: onHomeTap,
        onLibraryTap: onLibraryTap,
        onSearchTap: onSearchTap,
        onProfileTap: onProfileTap,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String actionLabel;
  final VoidCallback onActionTap;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.actionLabel,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF0F6F9B), size: 28),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF5E676D),
            ),
          ),
        ),
        if (actionLabel.isNotEmpty)
          TextButton(
            onPressed: onActionTap,
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF0F6F9B),
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              actionLabel,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
      ],
    );
  }
}

class _NotificationItem {
  final String title;
  final String subtitle;
  final String timeLabel;
  final Color accentColor;
  final bool unread;
  final bool showDot;
  final String? actionLabel;

  const _NotificationItem({
    required this.title,
    required this.subtitle,
    required this.timeLabel,
    required this.accentColor,
    required this.unread,
    this.showDot = false,
    this.actionLabel,
  });
}

const List<_NotificationItem> _chapterNotifications = [
  _NotificationItem(
    title: "Omniscient Reader's Viewpoint",
    subtitle: 'Chapter 250: "The Final Wall" is now available for reading!...',
    timeLabel: '2m ago',
    accentColor: Color(0xFF0F6F9B),
    unread: true,
    showDot: true,
  ),
  _NotificationItem(
    title: 'Tower of God',
    subtitle: 'A new chapter has been uploaded. See what Baam and...',
    timeLabel: '2h ago',
    accentColor: Color(0xFFBFE0EF),
    unread: false,
  ),
  _NotificationItem(
    title: 'The Beginning After The End',
    subtitle:
        'Arthur Leywin faces a new trial. Chapter 182 is now live for all...',
    timeLabel: '5h ago',
    accentColor: Color(0xFF0F6F9B),
    unread: false,
  ),
];

const List<_NotificationItem> _systemNotifications = [
  _NotificationItem(
    title: 'Panellit v2.4 Release',
    subtitle:
        'We\'ve added a new "Night Owl" mode for easier reading in the dark and improved page loading speeds by 40%.',
    timeLabel: '1d ago',
    accentColor: Color(0xFFC5E2F8),
    unread: false,
    actionLabel: 'View Release Notes',
  ),
  _NotificationItem(
    title: 'Account Security Alert',
    subtitle:
        'Your account was recently accessed from a new device in Tokyo, Japan. If this wasn\'t you, please change your password.',
    timeLabel: '3d ago',
    accentColor: Color(0xFFBFD0FF),
    unread: false,
  ),
];

class _ChapterNotificationCard extends StatelessWidget {
  final _NotificationItem item;

  const _ChapterNotificationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0B000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              color: item.accentColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.image_outlined, color: Colors.white70),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 22,
                          height: 1.1,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF31363A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.timeLabel,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6678A0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        item.subtitle,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.4,
                          color: Color(0xFF7C838A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (item.showDot)
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0F6F9B),
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SystemNotificationCard extends StatelessWidget {
  final _NotificationItem item;

  const _SystemNotificationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: item.accentColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.rocket_launch_outlined,
                  color: Color(0xFF0F6F9B),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF31363A),
                            ),
                          ),
                        ),
                        Text(
                          item.timeLabel,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6678A0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item.subtitle,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.45,
                        color: Color(0xFF7C838A),
                      ),
                    ),
                    if (item.actionLabel != null) ...[
                      const SizedBox(height: 14),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x0B000000),
                                blurRadius: 12,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Text(
                            item.actionLabel!,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF0F6F9B),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NotificationBottomNav extends StatelessWidget {
  final VoidCallback onHomeTap;
  final VoidCallback onLibraryTap;
  final VoidCallback onSearchTap;
  final VoidCallback onProfileTap;

  const _NotificationBottomNav({
    required this.onHomeTap,
    required this.onLibraryTap,
    required this.onSearchTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 22,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NotificationNavItem(
            icon: Icons.home_outlined,
            label: 'HOME',
            onTap: onHomeTap,
          ),
          _NotificationNavItem(
            icon: Icons.library_books_rounded,
            label: 'LIBRARY',
            onTap: onLibraryTap,
          ),
          _NotificationNavItem(
            icon: Icons.search_rounded,
            label: 'SEARCH',
            onTap: onSearchTap,
          ),
          _NotificationNavItem(
            icon: Icons.person_outline_rounded,
            label: 'PROFILE',
            onTap: onProfileTap,
          ),
        ],
      ),
    );
  }
}

class _NotificationNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _NotificationNavItem({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFFA2A9B2)),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFA2A9B2),
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );

    if (onTap == null) {
      return content;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: content,
      ),
    );
  }
}
