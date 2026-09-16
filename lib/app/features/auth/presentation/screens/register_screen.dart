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

class RegisterScreen extends StatefulWidget {
  final String? role;

  const RegisterScreen({super.key, this.role});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _agreedToTerms = false;

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
                context.showSnackBar('Account created successfully for ${state.user!.fullName}!');
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
                      const SizedBox(height: 12),
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                        onPressed: () => LoginRoute(role: widget.role).go(context),
                      ),
                      const Center(child: LogoHeader(size: 64)),
                      const SizedBox(height: 24),
                      Text(
                        t.auth.createAccount,
                        style: context.bold24TextMain,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        t.auth.registerSubtitle,
                        style: context.regular14TextSub,
                      ),
                      const SizedBox(height: 24),
                      CustomTextField(
                        label: t.auth.fullNameLabel,
                        hint: t.auth.fullNameHint,
                        controller: _nameController,
                        prefixIcon: Icons.person_outline_rounded,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _agreedToTerms,
                              activeColor: AppColors.primary,
                              onChanged: (val) {
                                setState(() {
                                  _agreedToTerms = val ?? false;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              t.auth.termsAgree,
                              style: context.regular12TextSub.copyWith(height: 1.4),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: t.auth.registerBtn,
                        isLoading: state.status == AuthStatus.loading,
                        onPressed: () {
                          if (!_agreedToTerms) {
                            context.showSnackBar('Please agree to terms & privacy policy', isError: true);
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
                            t.auth.haveAccount,
                            style: context.regular14TextSub,
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              LoginRoute(role: widget.role).go(context);
                            },
                            child: Text(
                              t.auth.signInLink,
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
