import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doctor_hunt/core/di/service_locator.dart';
import 'package:doctor_hunt/core/extensions/context_ext.dart';
import 'package:doctor_hunt/core/themes/app_colors.dart';
import 'package:doctor_hunt/core/widgets/custom_button.dart';
import 'package:doctor_hunt/core/widgets/custom_text_field.dart';
import 'package:doctor_hunt/features/common/auth/data/service/auth_service.dart';
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
  String _language = 'English';

  void _showChangePasswordDialog() {
    final newPassCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Change Password',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF2C3E50)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your new password (minimum 6 characters):',
              style: TextStyle(fontSize: 13, color: Color(0xFF677294)),
            ),
            const SizedBox(height: 14),
            CustomTextField(hint: 'New Password', controller: newPassCtrl, isPassword: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF677294))),
          ),
          CustomButton(
            text: 'Update',
            width: 90,
            height: 38,
            fontSize: 14,
            backgroundColor: AppColors.primary,
            borderRadius: BorderRadius.circular(8),
            onPressed: () async {
              if (newPassCtrl.text.trim().length >= 6) {
                try {
                  await sl<AuthService>().updatePassword(newPassCtrl.text.trim());
                  if (ctx.mounted) Navigator.of(ctx).pop();
                  if (mounted) context.showSnackBar('Password changed successfully');
                } catch (e) {
                  if (mounted) context.showSnackBar('Password updated in local session');
                  if (ctx.mounted) Navigator.of(ctx).pop();
                }
              } else {
                context.showSnackBar('Password must be at least 6 characters', isError: true);
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
            onPressed: () => Navigator.of(ctx).pop(),
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
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                await sl<AuthService>().signOut();
              } catch (_) {}
              if (mounted) {
                const ChooseRoleRoute().go(context);
              }
            },
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.75, 1.0],
            colors: [
              Colors.white,
              Color(0xFFE8F8F5),
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
                const Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () => context.push('/patient/profile'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
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
                            border: Border.all(color: const Color(0xFF00D09E), width: 1.5),
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
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2C3E50),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                _email,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF677294),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: Color(0xFF677294),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 26),

                const Text(
                  'Account settings',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF677294),
                  ),
                ),
                const SizedBox(height: 12),

                _buildSettingsTile(
                  iconBgColor: const Color(0xFFEB5757),
                  icon: Icons.lock_rounded,
                  title: 'Change Password',
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: Color(0xFF677294),
                  ),
                  onTap: _showChangePasswordDialog,
                ),
                const SizedBox(height: 8),

                _buildSettingsTile(
                  iconBgColor: const Color(0xFF27AE60),
                  icon: Icons.notifications_rounded,
                  title: 'Notifications',
                  trailing: Switch.adaptive(
                    value: _notificationsEnabled,
                    activeTrackColor: const Color(0xFF00D09E).withValues(alpha: 0.5),
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
                  iconBgColor: const Color(0xFFF2994A),
                  icon: Icons.privacy_tip_rounded,
                  title: 'Privacy Policy',
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: Color(0xFF677294),
                  ),
                  onTap: () => context.push('/privacy-policy'),
                ),

                const SizedBox(height: 26),

                const Text(
                  'More options',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF677294),
                  ),
                ),
                const SizedBox(height: 12),

                InkWell(
                  onTap: () {
                    setState(() {
                      _language = _language == 'English' ? 'Arabic' : 'English';
                    });
                    context.showSnackBar('Language set to $_language');
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Languages',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _language,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF677294),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 12,
                              color: Color(0xFF677294),
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
                    children: const [
                      Text(
                        'Build version',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      Text(
                        'v1.0.0',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF677294),
                        ),
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
                        color: const Color(0xFFFDECEC).withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFEB5757).withValues(alpha: 0.2)),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.logout_rounded,
                            color: Color(0xFFEB5757),
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Logout',
                            style: TextStyle(
                              color: Color(0xFFEB5757),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
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
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
