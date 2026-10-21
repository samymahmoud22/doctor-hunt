import 'package:flutter/material.dart';
import 'package:doctor_hunt/core/enums/user_role.dart';
import 'package:doctor_hunt/core/themes/app_colors.dart';
import 'package:doctor_hunt/features/admin/presentation/screens/admin_doctors_screen.dart';
import 'package:doctor_hunt/features/admin/presentation/screens/admin_appointments_screen.dart';
import 'package:doctor_hunt/features/admin/presentation/screens/admin_settings_screen.dart';
import 'package:doctor_hunt/features/patient/home/presentation/screens/patient_home_screen.dart';
import 'package:doctor_hunt/features/patient/home/presentation/screens/patient_profile_screen.dart';
import 'package:doctor_hunt/features/patient/doctors/presentation/screens/find_doctors_screen.dart';
import 'package:doctor_hunt/features/patient/appointments/presentation/screens/patient_appointments_screen.dart';
import 'package:doctor_hunt/features/patient/home/presentation/widgets/patient_menu_drawer.dart';

class MainScreen extends StatefulWidget {
  final UserRole? initialRole;

  const MainScreen({super.key, this.initialRole});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late int _currentIndex;
  late UserRole _role;
  bool _isDrawerOpen = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _role = widget.initialRole ?? UserRole.patient;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
      if (_isDrawerOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _closeDrawer() {
    if (_isDrawerOpen) {
      setState(() {
        _isDrawerOpen = false;
        _animationController.reverse();
      });
    }
  }

  void _toggleRole() {
    setState(() {
      _role = _role == UserRole.patient ? UserRole.admin : UserRole.patient;
      _currentIndex = 0;
      _closeDrawer();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPatient = _role.isPatient;

    final List<Widget> patientPages = [
      PatientHomeScreen(onOpenDrawer: _toggleDrawer),
      FindDoctorsScreen(
        showBackButton: true,
        onBack: () => setState(() => _currentIndex = 0),
        initialFavoritesOnly: true,
      ),
      PatientAppointmentsScreen(
        showBackButton: true,
        onBack: () => setState(() => _currentIndex = 0),
      ),
      PatientProfileScreen(onToggleRole: _toggleRole),
    ];

    final List<Widget> adminPages = const [
      AdminDoctorsScreen(),
      AdminAppointmentsScreen(),
      AdminSettingsScreen(),
    ];

    final pages = isPatient ? patientPages : adminPages;
    final size = MediaQuery.sizeOf(context);

    final Widget scaffold = !isPatient
        ? Scaffold(
            body: IndexedStack(
              index: _currentIndex.clamp(0, pages.length - 1),
              children: pages,
            ),
            bottomNavigationBar: _buildAdminBottomNav(),
          )
        : Scaffold(
            backgroundColor: const Color(0xFF505B73),
            body: Stack(
              children: [
                PatientMenuDrawer(
                  selectedIndex: _currentIndex,
                  onSelectTab: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  onClose: _closeDrawer,
                ),

                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    final slide = _animationController.value * (size.width * 0.62);
                    final scale = 1.0 - (_animationController.value * 0.20);
                    final radius = _animationController.value * 30.0;

                    return Stack(
                      children: [
                        if (_animationController.value > 0.05)
                          Transform(
                            transform: Matrix4.identity()
                              ..translateByDouble(slide - 24, 0.0, 0.0, 1.0)
                              ..scaleByDouble(scale * 0.94, scale * 0.94, 1.0, 1.0),
                            alignment: Alignment.centerLeft,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(radius),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.16),
                                  borderRadius: BorderRadius.circular(radius),
                                ),
                              ),
                            ),
                          ),

                        Transform(
                          transform: Matrix4.identity()
                            ..translateByDouble(slide, 0.0, 0.0, 1.0)
                            ..scaleByDouble(scale, scale, 1.0, 1.0),
                          alignment: Alignment.centerLeft,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(radius),
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  if (_isDrawerOpen)
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.35),
                                      blurRadius: 28,
                                      spreadRadius: 2,
                                      offset: const Offset(-8, 8),
                                    ),
                                ],
                              ),
                              child: GestureDetector(
                                onTap: _isDrawerOpen ? _closeDrawer : null,
                                behavior: _isDrawerOpen ? HitTestBehavior.opaque : HitTestBehavior.deferToChild,
                                child: AbsorbPointer(
                                  absorbing: _isDrawerOpen,
                                  child: Scaffold(
                                    body: IndexedStack(
                                      index: _currentIndex.clamp(0, pages.length - 1),
                                      children: pages,
                                    ),
                                    bottomNavigationBar: _buildPatientBottomNav(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );

    return PopScope(
      canPop: !isPatient ? _currentIndex == 0 : (!_isDrawerOpen && _currentIndex == 0),
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (_isDrawerOpen) {
          _closeDrawer();
        } else if (_currentIndex != 0) {
          setState(() => _currentIndex = 0);
        }
      },
      child: scaffold,
    );
  }

  Widget _buildPatientBottomNav() {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            index: 0,
            icon: Icons.home_rounded,
            isSelected: _currentIndex == 0,
          ),
          _buildNavItem(
            index: 1,
            icon: Icons.favorite_border_rounded,
            selectedIcon: Icons.favorite_rounded,
            isSelected: _currentIndex == 1,
          ),
          _buildNavItem(
            index: 2,
            icon: Icons.menu_book_outlined,
            selectedIcon: Icons.menu_book_rounded,
            isSelected: _currentIndex == 2,
          ),
          _buildNavItem(
            index: 3,
            icon: Icons.settings_outlined,
            selectedIcon: Icons.settings_rounded,
            isSelected: _currentIndex == 3,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    IconData? selectedIcon,
    required bool isSelected,
  }) {
    if (isSelected) {
      return GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        child: Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: Color(0xFF00D09E),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x3300D09E),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            selectedIcon ?? icon,
            color: Colors.white,
            size: 22,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        width: 44,
        height: 44,
        color: Colors.transparent,
        child: Icon(
          icon,
          color: const Color(0xFF9E9E9E),
          size: 24,
        ),
      ),
    );
  }

  Widget _buildAdminBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex.clamp(0, 2),
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSub,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        elevation: 0,
        backgroundColor: AppColors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services_outlined),
            activeIcon: Icon(Icons.medical_services_rounded),
            label: 'Doctors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today_rounded),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
