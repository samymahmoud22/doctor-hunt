import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:doctor_hunt/core/di/service_locator.dart';
import 'package:doctor_hunt/core/extensions/context_ext.dart';
import 'package:doctor_hunt/core/themes/app_colors.dart';
import 'package:doctor_hunt/core/themes/app_text_styles.dart';
import 'package:doctor_hunt/core/widgets/custom_button.dart';
import 'package:doctor_hunt/core/widgets/custom_text_field.dart';
import 'package:doctor_hunt/features/patient/home/presentation/controllers/patient_profile_cubit.dart';
import 'package:doctor_hunt/features/patient/home/presentation/controllers/patient_profile_state.dart';
import 'package:doctor_hunt/generated/i18n/strings.g.dart';
import 'package:doctor_hunt/generated/image_assets.dart';

class PatientProfileDetailsScreen extends StatelessWidget {
  const PatientProfileDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PatientProfileCubit>()..loadProfile(),
      child: const _PatientProfileDetailsView(),
    );
  }
}

class _PatientProfileDetailsView extends StatefulWidget {
  const _PatientProfileDetailsView();

  @override
  State<_PatientProfileDetailsView> createState() => _PatientProfileDetailsViewState();
}

class _PatientProfileDetailsViewState extends State<_PatientProfileDetailsView> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PatientProfileCubit, PatientProfileState>(
      listener: (context, state) {
        if (!_initialized && !state.isLoading) {
          _nameController.text = state.fullName;
          _phoneController.text = state.phone;
          _initialized = true;
        }

        if (state.errorMessage != null) {
          context.showSnackBar(state.errorMessage!, isError: true);
        } else if (state.isSaved) {
          context.showSnackBar(t.common.success);
          context.pop();
        }
      },
      builder: (context, state) {
        final cubit = context.read<PatientProfileCubit>();

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
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.activeTeal,
                            AppColors.primary,
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(28),
                          bottomRight: Radius.circular(28),
                        ),
                      ),
                      child: SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.white, size: 20),
                                onPressed: () => context.pop(),
                              ),
                              const SizedBox(width: 8),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  t.home.profile,
                                  style: AppTextStyles.h3.withWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: -46,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Stack(
                          children: [
                            Container(
                              width: 92,
                              height: 92,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.white, width: 4),
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors.boxShadow,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  ImageAssets.onboarding3Jpg,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: AppColors.activeTeal,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: AppColors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          label: t.profile.nameQuestion,
                          hint: t.profile.fullNameHint,
                          controller: _nameController,
                          fillColor: AppColors.inputBackground,
                        ),
                        const SizedBox(height: 20),

                        CustomTextField(
                          label: t.profile.phoneQuestion,
                          hint: t.profile.phoneHint,
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          fillColor: AppColors.inputBackground,
                        ),
                        const SizedBox(height: 20),

                        Text(
                          t.auth.emailLabel,
                          style: AppTextStyles.label,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: Text(
                            state.email,
                            style: AppTextStyles.bodyMedium.withTextSub,
                          ),
                        ),
                        const SizedBox(height: 36),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
                  child: CustomButton(
                    text: t.profile.saveChanges,
                    height: 52,
                    isLoading: state.isLoading,
                    onPressed: () {
                      final newName = _nameController.text.trim();
                      final newPhone = _phoneController.text.trim();
                      cubit.updateProfile(
                        fullName: newName.isNotEmpty ? newName : state.fullName,
                        phone: newPhone.isNotEmpty ? newPhone : state.phone,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
