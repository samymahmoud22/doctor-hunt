import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context_ext.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/logo_header.dart';
import 'package:doctor_hunt/generated/i18n/strings.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import '../controller/auth_cubit.dart';
import '../controller/auth_state.dart';
import '../widgets/social_login_button.dart';

class LoginScreen extends StatefulWidget {
  final String? role;

  const LoginScreen({super.key, this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = AuthCubit();
        if (widget.role != null) {
          cubit.setRole(widget.role!);
        }
        return cubit;
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state.status == AuthStatus.failure && state.errorMessage != null) {
                context.showSnackBar(state.errorMessage!, isError: true);
              } else if (state.status == AuthStatus.authenticated && state.user != null) {
                context.showSnackBar('Welcome back, ${state.user!.fullName}!');
                MainRoute(role: state.user!.role).go(context);
              }
            },
            builder: (context, state) {
              final cubit = context.read<AuthCubit>();

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const Center(child: LogoHeader(size: 64)),
                      const SizedBox(height: 28),
                      Text(
                        t.auth.welcomeBack,
                        style: context.bold24TextMain,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        t.auth.loginSubtitle,
                        style: context.regular14TextSub,
                      ),
                      const SizedBox(height: 28),
                      CustomTextField(
                        label: t.auth.emailLabel,
                        hint: t.auth.emailHint,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),
                      CustomTextField(
                        label: t.auth.passwordLabel,
                        hint: t.auth.passwordHint,
                        controller: _passwordController,
                        isPassword: true,
                        prefixIcon: Icons.lock_outline_rounded,
                        validator: (val) {
                          if (val == null || val.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: state.rememberMe,
                                  activeColor: AppColors.primary,
                                  onChanged: (val) => cubit.toggleRememberMe(val ?? false),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                t.auth.rememberMe,
                                style: context.regular14TextSub,
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              const ForgotPasswordRoute().go(context);
                            },
                            child: Text(
                              t.auth.forgotPasswordLink,
                              style: context.medium14Primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      CustomButton(
                        text: t.auth.loginBtn,
                        isLoading: state.status == AuthStatus.loading,
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            cubit.login(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: Text(
                          t.auth.socialSignIn,
                          style: context.regular14TextSub,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          SocialLoginButton(
                            label: t.auth.google,
                            icon: Icons.g_mobiledata_rounded,
                            iconColor: Colors.red,
                            onTap: () {
                              cubit.loginWithGoogle();
                            },
                          ),
                          const SizedBox(width: 16),
                          SocialLoginButton(
                            label: t.auth.facebook,
                            icon: Icons.facebook,
                            iconColor: Colors.blue,
                            onTap: () {
                              cubit.loginWithFacebook();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            t.auth.noAccount,
                            style: context.regular14TextSub,
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              RegisterRoute(role: widget.role).go(context);
                            },
                            child: Text(
                              t.auth.signUpLink,
                              style: context.medium14Primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
