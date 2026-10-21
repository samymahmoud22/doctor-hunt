import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/core/di/service_locator.dart';
import 'package:doctor_hunt/core/enums/user_role.dart';
import 'package:doctor_hunt/core/extensions/context_ext.dart';
import 'package:doctor_hunt/core/router/app_router.dart';
import 'package:doctor_hunt/core/themes/app_colors.dart';
import 'package:doctor_hunt/core/widgets/custom_button.dart';
import 'package:doctor_hunt/core/widgets/custom_text_field.dart';
import 'package:doctor_hunt/generated/i18n/strings.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import '../controller/auth_cubit.dart';
import '../controller/auth_state.dart';
import '../widgets/google_sign_in_card.dart';
import '../widgets/forgot_password_bottom_sheet.dart';

class LoginScreen extends StatefulWidget {
  final UserRole? role;

  const LoginScreen({super.key, this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isEmailValid = false;

  final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
  }

  void _onEmailChanged() {
    final isValid = _emailRegex.hasMatch(_emailController.text.trim());
    if (isValid != _isEmailValid) {
      setState(() {
        _isEmailValid = isValid;
      });
    }
  }

  @override
  void dispose() {
    _emailController.removeListener(_onEmailChanged);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = sl<AuthCubit>();
        if (widget.role != null) {
          cubit.setRole(widget.role!);
        }
        return cubit;
      },
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
                          const SizedBox(height: 40),
                          Text(
                            t.auth.welcomeBackTitle,
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
                          const SizedBox(height: 36),

                          if (widget.role != UserRole.admin) ...[
                            GoogleSignInCard(
                              onTap: () => cubit.loginWithGoogle(),
                              isLoading: state.status == AuthStatus.loading,
                            ),
                            const SizedBox(height: 32),
                          ],

                          CustomTextField(
                            hint: t.auth.emailFieldHint,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            suffixIcon: _isEmailValid
                                ? const Icon(
                                    Icons.check,
                                    color: AppColors.primary,
                                    size: 20,
                                  )
                                : null,
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
                          const SizedBox(height: 32),

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
                          const SizedBox(height: 16),

                          GestureDetector(
                            onTap: () {
                              ForgotPasswordBottomSheet.show(context, cubit: cubit);
                            },
                            child: Text(
                              t.auth.forgotPassword,
                              style: context.medium14Primary.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                t.auth.dontHaveAccount,
                                style: context.regular14TextSub.copyWith(
                                  color: const Color(0xFF677294),
                                ),
                              ),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: () {
                                  RegisterRoute(role: widget.role).go(context);
                                },
                                child: Text(
                                  t.auth.joinUsLink,
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
