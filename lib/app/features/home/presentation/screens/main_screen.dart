import 'package:flutter/material.dart';
import 'package:doctor_hunt/app/core/themes/app_colors.dart';
import 'package:doctor_hunt/app/core/utils/app_constants.dart';
import 'package:doctor_hunt/app/features/doctors/presentation/screens/favourite_doctors_screen.dart';
import 'package:doctor_hunt/app/features/home/presentation/screens/patient_home_screen.dart';
import 'package:doctor_hunt/app/features/home/presentation/screens/admin_home_screen.dart';

class MainScreen extends StatefulWidget {
  final String? initialRole;

  const MainScreen({super.key, this.initialRole});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;
  late String _role;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _role = widget.initialRole ?? AppConstants.rolePatient;
  }

  void _toggleRole() {
    setState(() {
      _role = (_role == AppConstants.rolePatient)
          ? AppConstants.roleAdmin
          : AppConstants.rolePatient;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPatient = _role == AppConstants.rolePatient;

    final List<Widget> pages = isPatient
        ? [
            const PatientHomeScreen(),
            const _PlaceholderPage(
              title: 'My Appointments',
              icon: Icons.calendar_month_rounded,
              description: 'Your booked doctor appointments will appear here.',
            ),
            const FavouriteDoctorsScreen(),
            _ProfilePage(
              role: _role,
              onToggleRole: _toggleRole,
            ),
          ]
        : [
            const AdminHomeScreen(),
            const _PlaceholderPage(
              title: 'All Appointments',
              icon: Icons.assignment_rounded,
              description: 'Manage and review system-wide doctor appointments.',
            ),
            const _PlaceholderPage(
              title: 'Doctor Directory',
              icon: Icons.badge_rounded,
              description: 'Manage registered doctors and edit profiles.',
            ),
            _ProfilePage(
              role: _role,
              onToggleRole: _toggleRole,
            ),
          ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: isPatient ? AppColors.primary : Colors.indigo,
          unselectedItemColor: AppColors.textSub,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          elevation: 0,
          backgroundColor: Colors.white,
          items: isPatient
              ? const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home_rounded),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_today_outlined),
                    activeIcon: Icon(Icons.calendar_today_rounded),
                    label: 'Appointments',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite_outline_rounded),
                    activeIcon: Icon(Icons.favorite_rounded),
                    label: 'Favorites',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline_rounded),
                    activeIcon: Icon(Icons.person_rounded),
                    label: 'Profile',
                  ),
                ]
              : const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard_outlined),
                    activeIcon: Icon(Icons.dashboard_rounded),
                    label: 'Dashboard',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.assignment_outlined),
                    activeIcon: Icon(Icons.assignment_rounded),
                    label: 'Bookings',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.badge_outlined),
                    activeIcon: Icon(Icons.badge_rounded),
                    label: 'Doctors',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline_rounded),
                    activeIcon: Icon(Icons.person_rounded),
                    label: 'Profile',
                  ),
                ],
        ),
      ),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;

  const _PlaceholderPage({
    required this.title,
    required this.icon,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 54, color: AppColors.primary),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSub, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfilePage extends StatelessWidget {
  final String role;
  final VoidCallback onToggleRole;

  const _ProfilePage({
    required this.role,
    required this.onToggleRole,
  });

  @override
  Widget build(BuildContext context) {
    final isPatient = role == AppConstants.rolePatient;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            CircleAvatar(
              radius: 44,
              backgroundColor: (isPatient ? AppColors.primary : Colors.indigo).withValues(alpha: 0.15),
              child: Icon(
                isPatient ? Icons.person_rounded : Icons.admin_panel_settings_rounded,
                size: 50,
                color: isPatient ? AppColors.primary : Colors.indigo,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              isPatient ? 'Alex Johnson' : 'Administrator',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              isPatient ? 'alex.johnson@example.com' : 'admin@doctorhunt.com',
              style: const TextStyle(color: AppColors.textSub, fontSize: 14),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: (isPatient ? AppColors.primary : Colors.indigo).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'ROLE: ${role.toUpperCase()}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isPatient ? AppColors.primary : Colors.indigo,
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Role Switcher Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.shade300),
              ),
              child: Row(
                children: [
                  const Icon(Icons.swap_calls_rounded, color: Colors.amber, size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Switch Mode / Role',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Current mode is ${role.toUpperCase()}. Tap to toggle UI mode.',
                          style: const TextStyle(fontSize: 12, color: AppColors.textSub),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: onToggleRole,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade700,
                      foregroundColor: Colors.white,
                      elevation: 0,
                    ),
                    child: Text('Switch to ${isPatient ? "Admin" : "Patient"}'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Account Settings'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text('Notifications'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.help_outline_rounded),
              title: const Text('Help & Support'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.red),
              title: const Text('Log Out', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
