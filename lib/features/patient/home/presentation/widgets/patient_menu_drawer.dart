import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doctor_hunt/core/di/service_locator.dart';
import 'package:doctor_hunt/features/common/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/generated/image_assets.dart';

class PatientMenuDrawer extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelectTab;
  final VoidCallback onClose;

  const PatientMenuDrawer({
    super.key,
    required this.selectedIndex,
    required this.onSelectTab,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final contentWidth = size.width * 0.50;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF6E7A9C),
            Color(0xFF586687),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  onClose();
                  context.push('/patient/profile');
                },
                child: SizedBox(
                  width: contentWidth,
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.0),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            ImageAssets.userAvatar,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Abdullah Mamun',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: const [
                                Icon(Icons.phone_rounded, color: Colors.white70, size: 12),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    '01303-527300',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 44),
              SizedBox(
                width: contentWidth,
                child: Column(
                  children: [
                    _MenuItem(
                      icon: Icons.person_rounded,
                      title: 'Home',
                      isSelected: selectedIndex == 0,
                      onTap: () {
                        onSelectTab(0);
                        onClose();
                      },
                    ),
                    const SizedBox(height: 16),
                    _MenuItem(
                      icon: Icons.favorite_rounded,
                      title: 'Favourites',
                      isSelected: selectedIndex == 1,
                      onTap: () {
                        onSelectTab(1);
                        onClose();
                      },
                    ),
                    const SizedBox(height: 16),
                    _MenuItem(
                      icon: Icons.calendar_month_rounded,
                      title: 'My Appoitments',
                      isSelected: selectedIndex == 2,
                      onTap: () {
                        onSelectTab(2);
                        onClose();
                      },
                    ),
                    const SizedBox(height: 16),
                    _MenuItem(
                      icon: Icons.settings_rounded,
                      title: 'Settings',
                      isSelected: selectedIndex == 3,
                      onTap: () {
                        onSelectTab(3);
                        onClose();
                      },
                    ),
                  ],
                ),
              ),

              const Spacer(),
              InkWell(
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      title: const Text(
                        'Log Out',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      content: const Text(
                        'Are you sure you want to logout?',
                        style: TextStyle(
                          color: Color(0xFF677294),
                          fontSize: 14,
                        ),
                      ),
                      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Color(0xFF00D09E),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          child: const Text(
                            'Ok',
                            style: TextStyle(
                              color: Color(0xFF00D09E),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true && context.mounted) {
                    try {
                      await sl<AuthService>().signOut();
                    } catch (_) {}
                    if (context.mounted) {
                      context.go('/login');
                    }
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.logout_rounded, color: Colors.white, size: 22),
                      SizedBox(width: 12),
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF00D09E) : Colors.white,
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF00D09E) : Colors.white,
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: isSelected ? const Color(0xFF00D09E) : Colors.white54,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
