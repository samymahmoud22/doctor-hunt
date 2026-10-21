import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/core/di/service_locator.dart';
import 'package:doctor_hunt/core/enums/user_role.dart';
import 'package:doctor_hunt/core/extensions/context_ext.dart';
import 'package:doctor_hunt/core/router/app_router.dart';
import 'package:doctor_hunt/core/themes/app_colors.dart';
import 'package:doctor_hunt/core/widgets/custom_button.dart';
import 'package:doctor_hunt/core/widgets/custom_text_field.dart';
import 'package:doctor_hunt/features/admin/data/models/admin_doctor_model.dart';
import 'package:doctor_hunt/features/admin/data/repo/admin_repository.dart';
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
  bool _agreedToTerms = false;
  late UserRole _selectedRole;

  final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.role ?? UserRole.patient;
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
      create: (_) {
        final cubit = sl<AuthCubit>();
        cubit.setRole(_selectedRole);
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
                  final userRole = state.user!.role;
                  if (userRole.isAdmin) {
                    final repo = sl<AdminRepository>();
                    final docName = state.user!.fullName.startsWith('Dr.')
                        ? state.user!.fullName
                        : 'Dr. ${state.user!.fullName}';
                    final existing = repo.findDoctorByName(docName);
                    if (existing == null) {
                      repo.addDoctor(
                        AdminDoctorModel(
                          id: 'doc_${DateTime.now().millisecondsSinceEpoch}',
                          name: docName,
                          specialty: 'Specialist General',
                          consultationFee: 30.0,
                          isActive: true,
                          rating: 5.0,
                          reviewsCount: 1,
                        ),
                      );
                    }
                  }
                  context.showSnackBar('Welcome, ${state.user!.fullName}!');
                  MainRoute(role: userRole).go(context);
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

                          // Role selection toggle
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F3F6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedRole = UserRole.patient;
                                      });
                                      cubit.setRole(UserRole.patient);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                        color: _selectedRole == UserRole.patient ? Colors.white : Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: _selectedRole == UserRole.patient
                                            ? [
                                                BoxShadow(
                                                  color: Colors.black.withValues(alpha: 0.06),
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: Center(
                                        child: Text(
                                          'مريض (Patient)',
                                          style: TextStyle(
                                            color: _selectedRole == UserRole.patient ? AppColors.primary : const Color(0xFF677294),
                                            fontWeight: _selectedRole == UserRole.patient ? FontWeight.bold : FontWeight.w500,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedRole = UserRole.admin;
                                      });
                                      cubit.setRole(UserRole.admin);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                        color: _selectedRole == UserRole.admin ? Colors.white : Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: _selectedRole == UserRole.admin
                                            ? [
                                                BoxShadow(
                                                  color: Colors.black.withValues(alpha: 0.06),
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: Center(
                                        child: Text(
                                          'طبيب / أدمن (Doctor)',
                                          style: TextStyle(
                                            color: _selectedRole == UserRole.admin ? AppColors.primary : const Color(0xFF677294),
                                            fontWeight: _selectedRole == UserRole.admin ? FontWeight.bold : FontWeight.w500,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          if (_selectedRole != UserRole.admin) ...[
                            GoogleSignInCard(
                              onTap: () => cubit.loginWithGoogle(),
                              isLoading: state.status == AuthStatus.loading,
                            ),
                            const SizedBox(height: 24),
                          ],

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
                                  LoginRoute(role: _selectedRole).go(context);
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
