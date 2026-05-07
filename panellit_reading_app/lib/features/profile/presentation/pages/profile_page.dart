import 'package:flutter/material.dart';

import '../../../auth/presentation/pages/login_page.dart';
import '../theme/profile_colors.dart';
import '../widgets/profile_bottom_nav.dart';

class ProfilePage extends StatelessWidget {
  final bool isGuest;
  final VoidCallback onHomeTap;
  final VoidCallback onLibraryTap;
  final VoidCallback onSearchTap;

  const ProfilePage({
    super.key,
    required this.isGuest,
    required this.onHomeTap,
    required this.onLibraryTap,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProfileColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 96),
          children: [
            const _ProfileTopBar(),
            const SizedBox(height: 16),
            if (isGuest)
              _GuestSection(
                onLoginTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
              )
            else
              const _ProfileContent(),
          ],
        ),
      ),
      bottomNavigationBar: ProfileBottomNav(
        onHomeTap: onHomeTap,
        onLibraryTap: onLibraryTap,
        onSearchTap: onSearchTap,
      ),
    );
  }
}

class _ProfileTopBar extends StatelessWidget {
  const _ProfileTopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.menu_rounded, size: 30),
          color: ProfileColors.primary,
        ),
        const SizedBox(width: 6),
        const Text(
          'Panellit',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: ProfileColors.primary,
          ),
        ),
        const Spacer(),
        const Text(
          'Profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: ProfileColors.textSecondary,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF3FB),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.settings_rounded,
            color: ProfileColors.primary,
          ),
        ),
      ],
    );
  }
}

class _GuestSection extends StatelessWidget {
  final VoidCallback onLoginTap;

  const _GuestSection({required this.onLoginTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: ProfileColors.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 82,
            height: 82,
            decoration: const BoxDecoration(
              color: Color(0xFFEAF3FB),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              size: 42,
              color: ProfileColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'You are browsing as a guest',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: ProfileColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Login to unlock your library, history, and personalized settings.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
              color: ProfileColors.textSecondary,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onLoginTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: ProfileColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.login_rounded),
              label: const Text(
                'Login to Continue',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _ProfileHeader(),
        SizedBox(height: 18),
        _StatsCard(),
        SizedBox(height: 18),
        _ProfileSection(
          title: 'YOUR LIBRARY',
          items: [
            _ProfileTileData(
              icon: Icons.history_rounded,
              title: 'Reading History',
            ),
            _ProfileTileData(
              icon: Icons.chat_bubble_outline_rounded,
              title: 'My Comments',
            ),
            _ProfileTileData(
              icon: Icons.download_rounded,
              title: 'Downloaded Stories',
            ),
          ],
        ),
        SizedBox(height: 16),
        _ProfileSection(
          title: 'PREFERENCES',
          items: [
            _ProfileTileData(
              icon: Icons.star_rounded,
              title: 'Subscription Plan (Pro)',
            ),
            _ProfileTileData(
              icon: Icons.manage_accounts_outlined,
              title: 'Account Settings',
            ),
            _ProfileTileData(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
            ),
          ],
        ),
        SizedBox(height: 16),
        _LogoutButton(),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFBFE1F2), width: 4),
              ),
              child: const CircleAvatar(
                backgroundColor: Color(0xFF1B1F24),
                child: Icon(Icons.person, color: Colors.white, size: 46),
              ),
            ),
            Positioned(
              right: 8,
              bottom: 8,
              child: Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: ProfileColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, size: 16, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          children: [
            const Text(
              'Alex Reader',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: ProfileColors.textPrimary,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: ProfileColors.badge,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'PREMIUM',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'alex.reader@example.com',
          style: TextStyle(fontSize: 14, color: ProfileColors.textSecondary),
        ),
      ],
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: ProfileColors.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0B000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _StatItem(value: '142', label: 'BOOKS'),
          _Divider(),
          _StatItem(value: '345h', label: 'READ TIME'),
          _Divider(),
          _StatItem(value: '12 Day', label: 'STREAK'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: ProfileColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: ProfileColors.textSecondary,
            letterSpacing: 0.6,
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 42, color: ProfileColors.border);
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final List<_ProfileTileData> items;

  const _ProfileSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: ProfileColors.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0B000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
              color: ProfileColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map((item) => _ProfileTile(item: item)),
        ],
      ),
    );
  }
}

class _ProfileTileData {
  final IconData icon;
  final String title;

  const _ProfileTileData({required this.icon, required this.title});
}

class _ProfileTile extends StatelessWidget {
  final _ProfileTileData item;

  const _ProfileTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: ProfileColors.border)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF3FB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: ProfileColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: ProfileColors.textPrimary,
              ),
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Color(0xFFB0B6BE)),
        ],
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: ProfileColors.logoutBackground,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.logout_rounded, color: ProfileColors.logoutText),
          SizedBox(width: 8),
          Text(
            'Logout',
            style: TextStyle(
              color: ProfileColors.logoutText,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
