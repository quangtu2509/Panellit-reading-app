import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../app/router/smooth_page_route.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/user_stats_service.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../theme/profile_colors.dart';
import '../widgets/profile_bottom_nav.dart';
import 'account_settings_page.dart';

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

// ── Top bar: ← back arrow + title ────────────────────────────────────────────

class _ProfileTopBar extends StatelessWidget {
  const _ProfileTopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ← back arrow (replaces 3-line menu icon)
        IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 22),
          color: ProfileColors.primary,
        ),
        const SizedBox(width: 4),
        const Text(
          'Profile',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: ProfileColors.primary,
          ),
        ),
      ],
    );
  }
}

// ── Guest placeholder ─────────────────────────────────────────────────────────

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
          BoxShadow(color: Color(0x0F000000), blurRadius: 24, offset: Offset(0, 8)),
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
            child: const Icon(Icons.person_outline_rounded,
                size: 42, color: ProfileColors.primary),
          ),
          const SizedBox(height: 16),
          const Text(
            'You are browsing as a guest',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w800, color: ProfileColors.textPrimary),
          ),
          const SizedBox(height: 8),
          const Text(
            'Login to unlock your library, history, and personalized settings.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, height: 1.4, color: ProfileColors.textSecondary),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: const Icon(Icons.login_rounded),
              label: const Text('Login to Continue',
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Logged-in profile content ─────────────────────────────────────────────────

class _ProfileContent extends StatefulWidget {
  const _ProfileContent();

  @override
  State<_ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<_ProfileContent> {
  String _email  = '';
  String _name   = '';
  int _readHours = 0;
  int _streak    = 0;
  bool _loading  = true;

  // Refresh timer — updates stats every 60 s while Profile is visible
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadData();
    _refreshTimer = Timer.periodic(const Duration(seconds: 60), (_) => _loadStats());
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    final email = await TokenStorage.instance.getUserEmail() ?? '';
    final name  = await TokenStorage.instance.getUserName() ?? 'user1';
    final hours = await UserStatsService.instance.getReadHours();
    final streak = await UserStatsService.instance.getStreakDays();
    if (mounted) {
      setState(() {
        _email     = email;
        _name      = name;
        _readHours = hours;
        _streak    = streak;
        _loading   = false;
      });
    }
  }

  Future<void> _loadStats() async {
    final hours  = await UserStatsService.instance.getReadHours();
    final streak = await UserStatsService.instance.getStreakDays();
    if (mounted) setState(() { _readHours = hours; _streak = streak; });
  }

  Future<void> _logout(BuildContext context) async {
    await AuthService.instance.logout();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 80),
          child: CircularProgressIndicator(color: ProfileColors.primary),
        ),
      );
    }

    return Column(
      children: [
        _ProfileHeader(email: _email, name: _name),
        const SizedBox(height: 18),
        _StatsCard(readHours: _readHours, streak: _streak),
        const SizedBox(height: 18),
        // PREFERENCES section — Account Settings only
        _ProfileSection(
          title: 'PREFERENCES',
          items: [
            _ProfileTileData(
              icon: Icons.manage_accounts_rounded,
              title: 'Account Settings',
              onTap: () async {
                final changed = await Navigator.of(context).push<bool>(
                  buildSmoothPageRoute(
                    AccountSettingsPage(currentEmail: _email, currentName: _name),
                  ),
                );
                if (changed == true) {
                  _loadData(); // refresh name
                }
              },
            ),
            _ProfileTileData(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              onTap: () {}, // placeholder
            ),
          ],
        ),
        const SizedBox(height: 16),
        _LogoutButton(onTap: () => _logout(context)),
      ],
    );
  }
}

// ── Profile header (avatar + email) ──────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  final String email;
  final String name;
  const _ProfileHeader({required this.email, required this.name});

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
        Text(
          name.isNotEmpty ? name : 'user1',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: ProfileColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          email,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: ProfileColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ── Stats card ────────────────────────────────────────────────────────────────

class _StatsCard extends StatelessWidget {
  final int readHours;
  final int streak;

  const _StatsCard({required this.readHours, required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: ProfileColors.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(color: Color(0x0B000000), blurRadius: 20, offset: Offset(0, 8)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(value: '${readHours}h', label: 'READ TIME'),
          _VerticalDivider(),
          _StatItem(value: '$streak Day${streak == 1 ? '' : 's'}', label: 'STREAK'),
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

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 42, color: ProfileColors.border);
}

// ── Preference section ────────────────────────────────────────────────────────

class _ProfileTileData {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const _ProfileTileData({required this.icon, required this.title, this.onTap});
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
          BoxShadow(color: Color(0x0B000000), blurRadius: 20, offset: Offset(0, 8)),
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

class _ProfileTile extends StatelessWidget {
  final _ProfileTileData item;
  const _ProfileTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
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
      ),
    );
  }
}

// ── Logout button ─────────────────────────────────────────────────────────────

class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;
  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}
