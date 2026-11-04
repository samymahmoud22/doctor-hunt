import 'package:doctor_hunt/core/extensions/context_ext.dart';
import 'package:doctor_hunt/core/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_hunt/core/di/service_locator.dart';
import 'package:doctor_hunt/core/router/app_router.dart';
import 'package:doctor_hunt/core/themes/app_colors.dart';
import 'package:doctor_hunt/core/themes/app_text_styles.dart';
import 'package:doctor_hunt/core/localization/locale_helper.dart';
import 'package:doctor_hunt/core/widgets/custom_button.dart';
import 'package:doctor_hunt/core/widgets/custom_text_field.dart';
import 'package:doctor_hunt/features/common/auth/presentation/controller/auth_cubit.dart';
import 'package:doctor_hunt/generated/i18n/strings.g.dart';
import 'package:doctor_hunt/generated/image_assets.dart';
import 'package:go_router/go_router.dart';
import '../controllers/admin_profile_cubit.dart';
import '../controllers/admin_profile_state.dart';

class AdminSettingsScreen extends StatelessWidget {
  final VoidCallback? onToggleRole;

  const AdminSettingsScreen({super.key, this.onToggleRole});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AdminProfileCubit>()..loadProfile(),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: SafeArea(
          child: BlocBuilder<AdminProfileCubit, AdminProfileState>(
            builder: (context, state) {
              final cubit = context.read<AdminProfileCubit>();

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          t.admin.settings,
                          style: AppTextStyles.h1,
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.notifications_outlined,
                                color: AppColors.textSub,
                              ),
                              onPressed: () {},
                            ),
                            CircleAvatar(
                              radius: 17,
                              backgroundColor: AppColors.primaryLight,
                              child: ClipOval(
                                child: Image.asset(
                                  ImageAssets.userAvatar,
                                  width: 34,
                                  height: 34,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Text(
                                    'A',
                                    style: AppTextStyles.buttonSmall.withPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: AppColors.primaryLight,
                            child: ClipOval(
                              child: Image.asset(
                                ImageAssets.userAvatar,
                                width: 52,
                                height: 52,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Text(
                                  state.initials,
                                  style: AppTextStyles.h3.withPrimary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.fullName.isNotEmpty ? state.fullName : 'Administrator',
                                  style: AppTextStyles.titleMedium,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  state.email,
                                  style: AppTextStyles.subtextSmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Column(
                        children: [
                          _buildSettingTile(
                            icon: Icons.person_outline_rounded,
                            title: t.profile.personalInfo,
                            subtitle: 'Edit super admin details & permissions',
                            onTap: () async {
                              final updated = await context.push<bool>('/admin/edit-profile');
                              if (updated == true) {
                                cubit.loadProfile();
                              }
                            },
                          ),
                          const Divider(height: 1, indent: 56, endIndent: 16, color: AppColors.cardBackground),
                          _buildSettingTile(
                            icon: Icons.lock_outline_rounded,
                            title: t.profile.changePassword,
                            subtitle: 'Update master security credentials',
                            onTap: () {
                              _showChangePasswordDialog(context);
                            },
                          ),
                          if (onToggleRole != null) ...[
                            const Divider(height: 1, indent: 56, endIndent: 16, color: AppColors.cardBackground),
                            _buildSettingTile(
                              icon: Icons.swap_horiz_rounded,
                              title: '${t.home.switchRole} ${t.role.patient}',
                              subtitle: 'Preview full experience as a patient',
                              trailing: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                                color: AppColors.primary,
                              ),
                              onTap: onToggleRole!,
                            ),
                          ],
                          const Divider(height: 1, indent: 56, endIndent: 16, color: AppColors.cardBackground),
                          _buildSettingTile(
                            icon: Icons.language_rounded,
                            title: t.profile.language,
                            subtitle: LocaleSettings.currentLocale == AppLocale.ar ? 'العربية' : 'English',
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: AppColors.primary,
                            ),
                            onTap: () async {
                              await LocaleHelper.showLanguageSelectionBottomSheet(context);
                            },
                          ),
                          const Divider(height: 1, indent: 56, endIndent: 16, color: AppColors.cardBackground),
                          _buildSettingTile(
                            icon: Icons.info_outline_rounded,
                            title: 'App Information',
                            subtitle: 'Build version',
                            trailing: Text(
                              'v1.0.0',
                              style: AppTextStyles.subtextMedium,
                            ),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    Material(
                      color: AppColors.dangerLight,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        onTap: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(t.profile.logout, style: AppTextStyles.h3),
                              content: Text(t.profile.logoutConfirm, style: AppTextStyles.subtext),
                              actions: [
                                TextButton(
                                  onPressed: () => ctx.pop(false),
                                  child: Text(t.common.cancel, style: AppTextStyles.subtext),
                                ),
                                TextButton(
                                  onPressed: () => ctx.pop(true),
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.danger,
                                  ),
                                  child: Text(t.profile.logout, style: AppTextStyles.buttonSmall.withDanger),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await sl<AuthCubit>().logout();
                            if (context.mounted) {
                              const LoginRoute().go(context);
                            }
                          }
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.danger.withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.logout_rounded, color: AppColors.danger, size: 18),
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
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: AppTextStyles.labelBold,
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.caption.withTextSub,
      ),
      trailing: trailing ??
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textPlaceholder,
            size: 20,
          ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final newPassCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.profile.changePassword, style: AppTextStyles.h3),
        content: CustomTextField(
          controller: newPassCtrl,
          isPassword: true,
          hint: t.profile.enterNewPassword,
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
              if (newPassCtrl.text.length >= 6) {
                try {
                  await sl<AuthCubit>().updatePassword(newPassCtrl.text.trim());
                  final err = sl<AuthCubit>().state.errorMessage;
                  if (err != null) {
                    if (context.mounted) context.showSnackBar(err, isError: true);
                  } else {
                    if (ctx.mounted) {
                      ctx.pop();
                      context.showSnackBar(t.profile.passwordChangedSuccess);
                    }
                  }
                } catch (e) {
                  AppLogger.error('Admin update password failed', e);
                  if (context.mounted) {
                    context.showSnackBar(e.toString().replaceAll('Exception: ', ''), isError: true);
                  }
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
}
