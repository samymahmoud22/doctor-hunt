import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_hunt/core/di/service_locator.dart';
import 'package:doctor_hunt/core/extensions/context_ext.dart';
import 'package:doctor_hunt/core/themes/app_colors.dart';
import 'package:doctor_hunt/core/widgets/custom_button.dart';
import 'package:doctor_hunt/core/widgets/custom_text_field.dart';
import 'package:doctor_hunt/generated/i18n/strings.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import '../controller/auth_cubit.dart';
import '../controller/auth_state.dart';

class ForgotPasswordBottomSheet extends StatefulWidget {
  final AuthCubit? cubit;

  const ForgotPasswordBottomSheet({super.key, this.cubit});

  static Future<bool?> show(BuildContext context, {AuthCubit? cubit}) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ForgotPasswordBottomSheet(cubit: cubit),
    );
  }

  @override
  State<ForgotPasswordBottomSheet> createState() => _ForgotPasswordBottomSheetState();
}

class _ForgotPasswordBottomSheetState extends State<ForgotPasswordBottomSheet> {
  int _currentStep = 1;

  final _emailController = TextEditingController();
  final _emailFormKey = GlobalKey<FormState>();

  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes =
      List.generate(6, (_) => FocusNode());

  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _resetFormKey = GlobalKey<FormState>();

  Timer? _countdownTimer;
  int _countdownSeconds = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 6; i++) {
      final index = i;
      _otpFocusNodes[index].onKeyEvent = (node, event) {
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.backspace ||
             event.logicalKey == LogicalKeyboardKey.delete)) {
          if (_otpControllers[index].text.isEmpty && index > 0) {
            _otpControllers[index - 1].clear();
            _otpFocusNodes[index - 1].requestFocus();
            setState(() {});
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      };
    }
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    setState(() {
      _countdownSeconds = 60;
      _canResend = false;
    });
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_countdownSeconds > 1) {
        setState(() {
          _countdownSeconds--;
        });
      } else {
        setState(() {
          _countdownSeconds = 0;
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _emailController.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _otpFocusNodes) {
      f.dispose();
    }
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String get _otpCode =>
      _otpControllers.map((c) => c.text.trim()).join();

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom +
        MediaQuery.viewInsetsOf(context).bottom;

    return BlocProvider.value(
      value: widget.cubit ?? sl<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) async {
          if (state.status == AuthStatus.failure && state.errorMessage != null) {
            context.showSnackBar(state.errorMessage!, isError: true);
          } else if (state.status == AuthStatus.otpSent && _currentStep == 1) {
            setState(() {
              _currentStep = 2;
            });
            _startCountdown();
            Future.delayed(const Duration(milliseconds: 150), () {
              if (mounted) _otpFocusNodes[0].requestFocus();
            });
          } else if (state.status == AuthStatus.otpVerified && _currentStep == 2) {
            setState(() {
              _currentStep = 3;
            });
          } else if (state.status == AuthStatus.passwordUpdated && _currentStep == 3) {
            await (widget.cubit ?? sl<AuthCubit>()).logout();
            if (context.mounted) {
              context.showSnackBar('Password reset successfully! Please sign in with your new password.');
              Navigator.of(context).pop(true);
            }
          }
        },
        builder: (context, state) {
          final cubit = context.read<AuthCubit>();
          final isLoading = state.status == AuthStatus.loading;

          return Container(
            padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottomInset),
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x1F000000),
                  blurRadius: 20,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1D5DB),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (_currentStep == 1)
                    _buildStep1Email(context, cubit, isLoading)
                  else if (_currentStep == 2)
                    _buildStep2Otp(context, cubit, isLoading)
                  else
                    _buildStep3ResetPassword(context, cubit, isLoading),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStep1Email(BuildContext context, AuthCubit cubit, bool isLoading) {
    return Form(
      key: _emailFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.auth.forgotPassword,
            style: context.bold24TextMain.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 10),
          Text(
            t.auth.forgotPasswordSubtitleSheet,
            style: context.regular14TextSub.copyWith(
              height: 1.4,
              color: const Color(0xFF677294),
            ),
          ),
          const SizedBox(height: 24),
          CustomTextField(
            hint: t.auth.emailFieldHint,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Please enter your email';
              }
              if (!val.contains('@') || !val.contains('.')) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 28),
          CustomButton(
            text: t.auth.continueBtn,
            isLoading: isLoading,
            onPressed: () {
              if (_emailFormKey.currentState?.validate() ?? false) {
                cubit.sendPasswordReset(_emailController.text.trim());
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStep2Otp(BuildContext context, AuthCubit cubit, bool isLoading) {
    final email = _emailController.text.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Enter Verification Code',
              style: context.bold24TextMain.copyWith(fontSize: 22),
            ),
            IconButton(
              tooltip: 'Change Email',
              icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.primary),
              onPressed: () {
                _countdownTimer?.cancel();
                setState(() {
                  _currentStep = 1;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 6),
        RichText(
          text: TextSpan(
            style: context.regular14TextSub.copyWith(
              height: 1.4,
              color: const Color(0xFF677294),
            ),
            children: [
              const TextSpan(text: 'Enter the 6-digit code sent to '),
              TextSpan(
                text: email,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) {
            return SizedBox(
              width: 44,
              height: 52,
              child: TextFormField(
                controller: _otpControllers[index],
                focusNode: _otpFocusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  counterText: '',
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: _otpControllers[index].text.isNotEmpty
                          ? AppColors.primary
                          : const Color(0xFFE5E7EB),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
                onTap: () {
                  _otpControllers[index].selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: _otpControllers[index].text.length,
                  );
                },
                onChanged: (val) {
                  if (val.length > 1) {
                    final digits = val.replaceAll(RegExp(r'\D'), '');
                    if (digits.length == 6) {
                      for (int i = 0; i < 6; i++) {
                        _otpControllers[i].text = digits[i];
                      }
                      _otpFocusNodes[5].unfocus();
                      setState(() {});
                      cubit.verifyOtp(
                        email: _emailController.text.trim(),
                        token: digits,
                      );
                      return;
                    }
                    final lastChar = val.characters.last;
                    _otpControllers[index].text = lastChar;
                    _otpControllers[index].selection =
                        const TextSelection.collapsed(offset: 1);
                    val = lastChar;
                  }

                  setState(() {});

                  if (val.isNotEmpty) {
                    if (index < 5) {
                      _otpFocusNodes[index + 1].requestFocus();
                    } else {
                      _otpFocusNodes[index].unfocus();
                      if (_otpCode.length == 6) {
                        cubit.verifyOtp(
                          email: _emailController.text.trim(),
                          token: _otpCode,
                        );
                      }
                    }
                  }
                },
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_canResend) ...[
              const Text(
                "Didn't receive the code? ",
                style: TextStyle(fontSize: 13, color: Color(0xFF677294)),
              ),
              GestureDetector(
                onTap: isLoading
                    ? null
                    : () {
                        cubit.sendPasswordReset(_emailController.text.trim());
                        _startCountdown();
                        context.showSnackBar('A new verification code was sent to your email.');
                      },
                child: const Text(
                  'Resend Code',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ] else ...[
              Text(
                'Resend code in ${_countdownSeconds}s',
                style: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
              ),
            ],
          ],
        ),
        const SizedBox(height: 24),
        CustomButton(
          text: t.auth.continueBtn,
          isLoading: isLoading,
          onPressed: () {
            final code = _otpCode;
            if (code.length < 6) {
              context.showSnackBar('Please enter all 6 digits', isError: true);
              return;
            }
            cubit.verifyOtp(
              email: _emailController.text.trim(),
              token: code,
            );
          },
        ),
      ],
    );
  }

  Widget _buildStep3ResetPassword(BuildContext context, AuthCubit cubit, bool isLoading) {
    return Form(
      key: _resetFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.auth.resetPasswordTitle,
            style: context.bold24TextMain.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 10),
          Text(
            t.auth.resetPasswordSubtitle,
            style: context.regular14TextSub.copyWith(
              height: 1.4,
              color: const Color(0xFF677294),
            ),
          ),
          const SizedBox(height: 24),
          CustomTextField(
            hint: t.auth.newPasswordHint,
            controller: _newPasswordController,
            isPassword: true,
            validator: (val) {
              if (val == null || val.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hint: t.auth.reenterPasswordHint,
            controller: _confirmPasswordController,
            isPassword: true,
            validator: (val) {
              if (val != _newPasswordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 28),
          CustomButton(
            text: t.auth.updatePasswordBtn,
            isLoading: isLoading,
            onPressed: () {
              if (_resetFormKey.currentState?.validate() ?? false) {
                cubit.updatePassword(_newPasswordController.text.trim());
              }
            },
          ),
        ],
      ),
    );
  }
}
