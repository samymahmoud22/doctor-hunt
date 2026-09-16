import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context_ext.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/logo_header.dart';
import 'package:doctor_hunt/generated/i18n/strings.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import '../controller/auth_cubit.dart';
import '../controller/auth_state.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state.errorMessage != null) {
                context.showSnackBar(
                  state.errorMessage!,
                  isError: state.status == AuthStatus.failure,
                );
              }
            },
            builder: (context, state) {
              final cubit = context.read<AuthCubit>();

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                        onPressed: () => const LoginRoute().go(context),
                      ),
                      const Center(child: LogoHeader(size: 64)),
                      const SizedBox(height: 32),
                      Text(
                        t.auth.forgotPassword,
                        style: context.bold24TextMain,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        t.auth.forgotSubtitle,
                        style: context.regular14TextSub,
                      ),
                      const SizedBox(height: 32),
                      CustomTextField(
                        label: t.auth.emailLabel,
                        hint: t.auth.emailHint,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please enter your email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      CustomButton(
                        text: t.auth.resetBtn,
                        isLoading: state.status == AuthStatus.loading,
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            cubit.sendPasswordReset(_emailController.text.trim());
                          }
                        },
                      ),
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
