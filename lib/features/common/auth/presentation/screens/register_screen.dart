import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/core/di/service_locator.dart';
import 'package:doctor_hunt/core/enums/user_role.dart';
import 'package:doctor_hunt/core/extensions/context_ext.dart';
import 'package:doctor_hunt/core/router/app_router.dart';
import 'package:doctor_hunt/core/services/supabase_storage_service.dart';
import 'package:doctor_hunt/core/themes/app_colors.dart';
import 'package:doctor_hunt/core/utils/image_picker_helper.dart';
import 'package:doctor_hunt/core/widgets/custom_button.dart';
import 'package:doctor_hunt/core/widgets/custom_text_field.dart';
import 'package:doctor_hunt/features/common/auth/data/repo/auth_repository.dart';
import 'package:doctor_hunt/generated/i18n/strings.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import '../controller/auth_cubit.dart';
import '../controller/auth_state.dart';
import '../widgets/google_sign_in_card.dart';

class RegisterScreen extends StatefulWidget {
  final UserRole? role;

  const RegisterScreen({super.key, this.role});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  Uint8List? _avatarBytes;
  bool _agreedToTerms = false;

  final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>()..setRole(UserRole.patient),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.8, 0.9),
              radius: 0.9,
              colors: [
                Color(0x1A0EBE7F),
                Colors.white,
              ],
              stops: [0.0, 0.6],
            ),
          ),
          child: SafeArea(
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) async {
                if (state.status == AuthStatus.failure && state.errorMessage != null) {
                  context.showSnackBar(state.errorMessage!, isError: true);
                } else if (state.status == AuthStatus.authenticated && state.user != null) {
                  final userRole = state.user!.role;
                  if (_avatarBytes != null) {
                    try {
                      final storage = sl.isRegistered<SupabaseStorageService>() 
                          ? sl<SupabaseStorageService>() 
                          : SupabaseStorageService();
                      final url = await storage.uploadUserAvatar(
                        userId: state.user!.id,
                        bytes: _avatarBytes!,
                      );
                      if (url != null && sl.isRegistered<AuthRepository>()) {
                        await sl<AuthRepository>().updatePatientProfile(
                          fullName: state.user!.fullName,
                          phone: '',
                          avatarUrl: url,
                        );
                      }
                    } catch (_) {}
                  }
                  if (context.mounted) {
                    context.showSnackBar('Welcome, ${state.user!.fullName}!');
                    MainRoute(role: userRole).go(context);
                  }
                }
              },
              builder: (context, state) {
                final cubit = context.read<AuthCubit>();
                final screenSize = MediaQuery.sizeOf(context);

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: screenSize.height -
                          MediaQuery.paddingOf(context).top -
                          MediaQuery.paddingOf(context).bottom -
                          40,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 36),
                          Text(
                            t.auth.joinUsTitle,
                            style: context.bold24TextMain.copyWith(fontSize: 26),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              t.auth.authSubtitle,
                              style: context.regular14TextSub.copyWith(
                                color: const Color(0xFF677294),
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 18),

                          GoogleSignInCard(
                            onTap: () => cubit.loginWithGoogle(),
                            isLoading: state.status == AuthStatus.loading,
                          ),
                          const SizedBox(height: 20),

                          GestureDetector(
                            onTap: () async {
                              final bytes = await ImagePickerHelper.pickImageBytes(context);
                              if (bytes != null) {
                                setState(() {
                                  _avatarBytes = bytes;
                                });
                              }
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 86,
                                  height: 86,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFFF0FDF4),
                                    border: Border.all(
                                      color: AppColors.primary.withValues(alpha: 0.35),
                                      width: 2,
                                    ),
                                  ),
                                  child: _avatarBytes != null
                                      ? ClipOval(
                                          child: Image.memory(
                                            _avatarBytes!,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.person_outline_rounded,
                                          size: 44,
                                          color: AppColors.primary,
                                        ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: AppColors.white, width: 2),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt_rounded,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _avatarBytes != null ? 'Change photo' : 'Add photo (Optional)',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 18),

                          CustomTextField(
                            hint: t.auth.nameHint,
                            controller: _nameController,
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          CustomTextField(
                            hint: t.auth.emailFieldHint,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!_emailRegex.hasMatch(val.trim())) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          CustomTextField(
                            hint: t.auth.passwordFieldHint,
                            controller: _passwordController,
                            isPassword: true,
                            validator: (val) {
                              if (val == null || val.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _agreedToTerms = !_agreedToTerms;
                              });
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _agreedToTerms
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: _agreedToTerms
                                          ? AppColors.primary
                                          : const Color(0xFF9E9E9E),
                                      width: 1.8,
                                    ),
                                  ),
                                  child: _agreedToTerms
                                      ? const Icon(
                                          Icons.check,
                                          size: 14,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    t.auth.termsAgreeText,
                                    style: context.regular12TextSub.copyWith(
                                      color: const Color(0xFF677294),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),

                          CustomButton(
                            text: t.auth.signUpBtn,
                            isLoading: state.status == AuthStatus.loading,
                            onPressed: () {
                              if (!_agreedToTerms) {
                                context.showSnackBar(
                                  'Please agree to the Terms of Service & Privacy Policy',
                                  isError: true,
                                );
                                return;
                              }
                              if (_formKey.currentState?.validate() ?? false) {
                                cubit.register(
                                  fullName: _nameController.text.trim(),
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 24),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                t.auth.haveAccountLogIn,
                                style: context.regular14TextSub.copyWith(
                                  color: const Color(0xFF677294),
                                ),
                              ),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: () {
                                  LoginRoute(role: UserRole.patient).go(context);
                                },
                                child: Text(
                                  t.auth.logInLink,
                                  style: context.bold14Primary.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
