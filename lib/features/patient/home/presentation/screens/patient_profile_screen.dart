import 'package:doctor_hunt/core/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doctor_hunt/core/di/service_locator.dart';
import 'package:doctor_hunt/core/extensions/context_ext.dart';
import 'package:doctor_hunt/core/themes/app_colors.dart';
import 'package:doctor_hunt/core/themes/app_text_styles.dart';
import 'package:doctor_hunt/core/localization/locale_helper.dart';
import 'package:doctor_hunt/core/widgets/custom_button.dart';
import 'package:doctor_hunt/core/widgets/custom_text_field.dart';
import 'package:doctor_hunt/features/common/auth/presentation/controller/auth_cubit.dart';
import 'package:doctor_hunt/generated/i18n/strings.g.dart';
import 'package:doctor_hunt/generated/image_assets.dart';
import 'package:doctor_hunt/core/router/app_router.dart';

class PatientProfileScreen extends StatefulWidget {
  final VoidCallback? onToggleRole;

  const PatientProfileScreen({super.key, this.onToggleRole});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  final String _fullName = 'Patient User';
  final String _email = 'admin@doctorhunt.com';
  bool _notificationsEnabled = true;

  void _showChangePasswordDialog() {
    final newPassCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          t.profile.changePassword,
          style: AppTextStyles.h3,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.profile.newPasswordMinChars,
              style: AppTextStyles.subtextMedium,
            ),
            const SizedBox(height: 14),
            CustomTextField(
              hint: t.auth.newPasswordHint,
              controller: newPassCtrl,
              isPassword: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(),
            child: Text(t.common.cancel, style: AppTextStyles.subtext),
          ),
          CustomButton(
            text: t.profile.update,
            width: 90,
            height: 38,
            fontSize: 14,
            backgroundColor: AppColors.primary,
            borderRadius: BorderRadius.circular(8),
            onPressed: () async {
              if (newPassCtrl.text.trim().length >= 6) {
                try {
                  await sl<AuthCubit>().updatePassword(newPassCtrl.text.trim());
                  final err = sl<AuthCubit>().state.errorMessage;
                  if (err != null) {
                    if (mounted) context.showSnackBar(err, isError: true);
                  } else {
                    if (ctx.mounted) ctx.pop();
                    if (mounted) context.showSnackBar(t.profile.passwordChangedSuccess);
                  }
                } catch (e) {
                  AppLogger.error('Update password failed', e);
                  if (mounted) context.showSnackBar(e.toString().replaceAll('Exception: ', ''), isError: true);
                }
              } else {
                context.showSnackBar(t.profile.passwordMinLength, isError: true);
              }
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
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
            onPressed: () => ctx.pop(),
            child: Text(
              t.common.cancel,
              style: AppTextStyles.buttonSmall.withActiveTeal.withBold,
            ),
          ),
          TextButton(
            onPressed: () async {
              ctx.pop();
              try {
                await sl<AuthCubit>().logout();
              } catch (_) {}
              if (mounted) {
                const ChooseRoleRoute().go(context);
              }
            },
            child: Text(
              t.profile.ok,
              style: AppTextStyles.buttonSmall.withActiveTeal.withBold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.75, 1.0],
            colors: [
              AppColors.white,
              AppColors.mintLight,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  t.profile.settings,
                  style: AppTextStyles.h2,
                ),
                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () => context.push('/patient/profile'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.boxShadow,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.activeTeal, width: 1.5),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              ImageAssets.onboarding2Jpg,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _fullName,
                                style: AppTextStyles.titleMedium.withTextDark,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                _email,
                                style: AppTextStyles.subtextSmall,
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: AppColors.textSub,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 26),

                Text(
                  t.profile.accountSettings,
                  style: AppTextStyles.titleSmall.withTextSub.withBold,
                ),
                const SizedBox(height: 12),

                _buildSettingsTile(
                  iconBgColor: AppColors.redAccent,
                  icon: Icons.lock_rounded,
                  title: t.profile.changePassword,
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: AppColors.textSub,
                  ),
                  onTap: _showChangePasswordDialog,
                ),
                const SizedBox(height: 8),

                _buildSettingsTile(
                  iconBgColor: AppColors.primary,
                  icon: Icons.notifications_rounded,
                  title: t.profile.notifications,
                  trailing: Switch.adaptive(
                    value: _notificationsEnabled,
                    activeTrackColor: AppColors.activeTeal.withValues(alpha: 0.5),
                    onChanged: (val) {
                      setState(() => _notificationsEnabled = val);
                      context.showSnackBar('Notifications ${val ? "enabled" : "disabled"}');
                    },
                  ),
                  onTap: () {
                    setState(() => _notificationsEnabled = !_notificationsEnabled);
                  },
                ),
                const SizedBox(height: 8),

                _buildSettingsTile(
                  iconBgColor: AppColors.warning,
                  icon: Icons.privacy_tip_rounded,
                  title: t.profile.privacyPolicy,
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: AppColors.textSub,
                  ),
                  onTap: () => context.push('/privacy-policy'),
                ),

                if (widget.onToggleRole != null) ...[
                  const SizedBox(height: 8),
                  _buildSettingsTile(
                    iconBgColor: AppColors.primary,
                    icon: Icons.admin_panel_settings_rounded,
                    title: '${t.home.switchRole} ${t.admin.adminPortal}',
                    trailing: const Icon(
                      Icons.swap_horiz_rounded,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    onTap: widget.onToggleRole!,
                  ),
                ],

                const SizedBox(height: 26),

                Text(
                  t.home.categories,
                  style: AppTextStyles.titleSmall.withTextSub.withBold,
                ),
                const SizedBox(height: 12),

                InkWell(
                  key: const Key('patient_profile_language_tile'),
                  onTap: () async {
                    await LocaleHelper.showLanguageSelectionBottomSheet(context);
                    if (mounted) setState(() {});
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          t.profile.language,
                          style: AppTextStyles.label,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              LocaleSettings.currentLocale == AppLocale.ar ? 'العربية' : 'English',
                              style: AppTextStyles.subtextMedium,
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 12,
                              color: AppColors.textSub,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Build version',
                        style: AppTextStyles.label,
                      ),
                      Text(
                        'v1.0.0',
                        style: AppTextStyles.subtextMedium,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 36),

                Center(
                  child: InkWell(
                    onTap: _showLogoutDialog,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.dangerLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.danger.withValues(alpha: 0.2)),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.logout_rounded,
                            color: AppColors.danger,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            t.profile.logout,
                            style: AppTextStyles.buttonSmall.withDanger.withBold,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required Color iconBgColor,
    required IconData icon,
    required String title,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.label,
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
