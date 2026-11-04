import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doctor_hunt/core/di/service_locator.dart';
import 'package:doctor_hunt/core/services/session_manager.dart';
import 'package:doctor_hunt/core/themes/app_colors.dart';
import 'package:doctor_hunt/core/themes/app_text_styles.dart';
import 'package:doctor_hunt/features/common/auth/presentation/controller/auth_cubit.dart';
import 'package:doctor_hunt/generated/i18n/strings.g.dart';
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
    final contentWidth = size.width * 0.58;
    final sessionManager = sl.isRegistered<SessionManager>() ? sl<SessionManager>() : null;
    final userName = sessionManager?.userName ?? 'Patient User';
    final userPhone = sessionManager?.userEmail ?? '+20 100 000 0000';

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.drawerBackground,
            Color(0xFF3E485E),
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
                          border: Border.all(color: AppColors.white, width: 2.0),
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
                            Text(
                              userName,
                              style: AppTextStyles.titleMedium.withWhite,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.phone_rounded, color: Colors.white70, size: 12),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    userPhone,
                                    style: AppTextStyles.caption.copyWith(color: Colors.white70),
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

              const SizedBox(height: 24),

              Expanded(
                child: SizedBox(
                  width: contentWidth,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _MenuItem(
                          icon: Icons.person_rounded,
                          title: t.drawer.myDoctors,
                          isSelected: selectedIndex == 0,
                          onTap: () {
                            onSelectTab(0);
                            onClose();
                          },
                        ),
                        const SizedBox(height: 8),
                        _MenuItem(
                          icon: Icons.description_outlined,
                          title: t.drawer.medicalRecords,
                          isSelected: false,
                          onTap: () {
                            onClose();
                            _showFeatureDialog(
                              context,
                              t.drawer.medicalRecords,
                              Icons.description_outlined,
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        _MenuItem(
                          icon: Icons.payment_rounded,
                          title: t.drawer.payments,
                          isSelected: false,
                          onTap: () {
                            onClose();
                            _showFeatureDialog(
                              context,
                              t.drawer.payments,
                              Icons.payment_rounded,
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        _MenuItem(
                          icon: Icons.medication_outlined,
                          title: t.drawer.medicineOrders,
                          isSelected: false,
                          onTap: () {
                            onClose();
                            _showFeatureDialog(
                              context,
                              t.drawer.medicineOrders,
                              Icons.medication_outlined,
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        _MenuItem(
                          icon: Icons.favorite_rounded,
                          title: t.drawer.favourites,
                          isSelected: selectedIndex == 1,
                          onTap: () {
                            onSelectTab(1);
                            onClose();
                          },
                        ),
                        const SizedBox(height: 8),
                        _MenuItem(
                          icon: Icons.calendar_month_rounded,
                          title: t.drawer.myAppointments,
                          isSelected: selectedIndex == 2,
                          onTap: () {
                            onSelectTab(2);
                            onClose();
                          },
                        ),
                        const SizedBox(height: 8),
                        _MenuItem(
                          icon: Icons.help_outline_rounded,
                          title: t.drawer.helpCenter,
                          isSelected: false,
                          onTap: () {
                            onClose();
                            _showFeatureDialog(
                              context,
                              t.drawer.helpCenter,
                              Icons.help_outline_rounded,
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        _MenuItem(
                          icon: Icons.settings_rounded,
                          title: t.profile.settings,
                          isSelected: selectedIndex == 3,
                          onTap: () {
                            onSelectTab(3);
                            onClose();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              InkWell(
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      title: Text(
                        t.profile.logout,
                        style: AppTextStyles.h2,
                      ),
                      content: Text(
                        t.profile.logoutConfirm,
                        style: AppTextStyles.subtext,
                      ),
                      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      actions: [
                        TextButton(
                          onPressed: () => ctx.pop(false),
                          child: Text(
                            t.common.cancel,
                            style: AppTextStyles.buttonSmall.withActiveTeal.withBold,
                          ),
                        ),
                        TextButton(
                          onPressed: () => ctx.pop(true),
                          child: Text(
                            t.profile.ok,
                            style: AppTextStyles.buttonSmall.withActiveTeal.withBold,
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true && context.mounted) {
                    try {
                      await sl<AuthCubit>().logout();
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
                    children: [
                      const Icon(Icons.logout_rounded, color: AppColors.white, size: 22),
                      const SizedBox(width: 12),
                      Text(
                        t.profile.logout,
                        style: AppTextStyles.button,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  void _showFeatureDialog(BuildContext context, String title, IconData icon) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        icon: CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.primary.withValues(alpha: 0.12),
          child: Icon(icon, color: AppColors.primary, size: 28),
        ),
        title: Text(title, style: AppTextStyles.h3),
        content: Text(
          '$title will be available in the upcoming release. Stay tuned!',
          style: AppTextStyles.subtext,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(),
            child: Text(t.profile.ok, style: AppTextStyles.buttonSmall.withActiveTeal.withBold),
          ),
        ],
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.activeTeal : AppColors.white,
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: isSelected
                    ? AppTextStyles.labelBold.withActiveTeal
                    : AppTextStyles.label.withWhite,
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: isSelected ? AppColors.activeTeal : Colors.white54,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
