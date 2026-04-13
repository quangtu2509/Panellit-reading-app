import 'package:flutter/material.dart';

import '../../../home/presentation/pages/home_page.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  String _selectedSort = 'Newest → Oldest';
  final List<String> _sortOptions = const [
    'A → Z',
    'Z → A',
    'Newest → Oldest',
    'Oldest → Newest',
  ];

  final List<_LibraryItemData> _items = const [
    _LibraryItemData(
      title: 'Shadow Realm Chronicles',
      genre: 'Fantasy',
      updatedText: 'Updated 2h ago',
      chapter: 'Ch. 142',
      actionLabel: 'Continue',
      badge: 'NEW',
      color: Color(0xFF1E3340),
    ),
    _LibraryItemData(
      title: 'Cyber City 2099',
      genre: 'Sci-Fi',
      updatedText: 'Updated 5h ago',
      chapter: 'Ch. 88',
      actionLabel: 'Continue',
      badge: 'NEW',
      color: Color(0xFF122033),
    ),
    _LibraryItemData(
      title: 'The Midnight Library',
      genre: 'Mystery',
      updatedText: 'Updated 1d ago',
      chapter: 'Ch. 24',
      actionLabel: 'Read Now',
      color: Color(0xFF4E3415),
    ),
    _LibraryItemData(
      title: "Ron's Path",
      genre: 'Historical',
      updatedText: 'Updated 3d ago',
      chapter: 'Ch. 12',
      actionLabel: 'Resume',
      badge: 'NEW',
      color: Color(0xFF5A2A31),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 12),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.menu_rounded, size: 30),
                      color: const Color(0xFF0F6F9B),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'My Library',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF31363A),
                      ),
                    ),
                    const Spacer(),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.notifications_none_rounded,
                            size: 30,
                          ),
                          color: const Color(0xFF9AA3AE),
                        ),
                        Positioned(
                          right: 12,
                          top: 11,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Color(0xFFB13B39),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x10000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const TabBar(
                  labelColor: Color(0xFF0F6F9B),
                  unselectedLabelColor: Color(0xFF788391),
                  indicatorColor: Color(0xFF0F6F9B),
                  indicatorWeight: 3,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: [
                    Tab(text: 'Following'),
                    Tab(text: 'Reading'),
                    Tab(text: 'Completed'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildLibraryTab(context),
                    _buildPlaceholderTab('Reading list will appear here.'),
                    _buildPlaceholderTab('Completed books will appear here.'),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
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
              _BottomNavItem(
                icon: Icons.home_outlined,
                label: 'HOME',
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
              ),
              const _BottomNavItem(
                icon: Icons.library_books_rounded,
                label: 'LIBRARY',
                active: true,
              ),
              _BottomNavItem(
                icon: Icons.search_rounded,
                label: 'SEARCH',
                onTap: () {},
              ),
              _BottomNavItem(
                icon: Icons.person_outline_rounded,
                label: 'PROFILE',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLibraryTab(BuildContext context) {
    final sortedItems = _sortedItems();

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 96),
      children: [
        Row(
          children: [
            const Flexible(
              child: Text(
                '12 Titles',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF31363A),
                ),
              ),
            ),
            const SizedBox(width: 12),
            PopupMenuButton<String>(
              initialValue: _selectedSort,
              onSelected: (value) {
                setState(() {
                  _selectedSort = value;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              color: Colors.white,
              itemBuilder: (context) {
                return _sortOptions.map((option) {
                  return PopupMenuItem<String>(
                    value: option,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: option == _selectedSort
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: const Color(0xFF3A3F44),
                            ),
                          ),
                        ),
                        if (option == _selectedSort)
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFF0F6F9B),
                            size: 18,
                          ),
                      ],
                    ),
                  );
                }).toList();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(
                      'Sort',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: Colors.grey.shade700,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        ...sortedItems.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 28),
            child: _LibraryCard(item: item),
          );
        }),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF0B6B8A),
            borderRadius: BorderRadius.circular(26),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 26,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'RECOMMENDED',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Explore 500+ New\nSeries This Weekend',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Browse Now',
                      style: TextStyle(
                        color: Color(0xFF0B6B8A),
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderTab(String text) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF7D848C),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  List<_LibraryItemData> _sortedItems() {
    final items = List<_LibraryItemData>.from(_items);
    switch (_selectedSort) {
      case 'A → Z':
        items.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Z → A':
        items.sort((a, b) => b.title.compareTo(a.title));
        break;
      case 'Oldest → Newest':
        items.sort((a, b) => b.updatedText.compareTo(a.updatedText));
        break;
      case 'Newest → Oldest':
      default:
        items.sort((a, b) => a.updatedText.compareTo(b.updatedText));
        break;
    }
    return items;
  }
}

class _LibraryCard extends StatelessWidget {
  final _LibraryItemData item;

  const _LibraryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 145,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 145,
                height: 190,
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 14,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.image_outlined,
                  color: Colors.white24,
                  size: 38,
                ),
              ),
              if (item.badge != null)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F7AA5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      item.badge!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 22,
                  height: 1.05,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF31363A),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    item.genre,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5C7499),
                    ),
                  ),
                  const Text(
                    ' • ',
                    style: TextStyle(fontSize: 14, color: Color(0xFF9AA3AE)),
                  ),
                  Text(
                    item.updatedText,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF7D848C),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6ECFB),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      item.chapter,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF1D6D93),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    item.actionLabel,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF0F7AA5),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LibraryItemData {
  final String title;
  final String genre;
  final String updatedText;
  final String chapter;
  final String actionLabel;
  final String? badge;
  final Color color;

  const _LibraryItemData({
    required this.title,
    required this.genre,
    required this.updatedText,
    required this.chapter,
    required this.actionLabel,
    required this.color,
    this.badge,
  });
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    this.active = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? const Color(0xFF0F7AA5) : const Color(0xFFA2A9B2);
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
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
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: content,
      ),
    );
  }
}
