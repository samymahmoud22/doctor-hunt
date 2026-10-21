import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/core/di/service_locator.dart';
import 'package:doctor_hunt/core/enums/user_role.dart';
import 'package:doctor_hunt/core/router/app_router.dart';
import 'package:doctor_hunt/core/themes/app_colors.dart';
import 'package:doctor_hunt/core/widgets/custom_button.dart';
import 'package:doctor_hunt/core/widgets/logo_header.dart';
import 'package:doctor_hunt/generated/i18n/strings.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import '../controller/choose_role_cubit.dart';
import '../controller/choose_role_state.dart';
import '../widgets/role_card.dart';

class ChooseRoleScreen extends StatelessWidget {
  const ChooseRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ChooseRoleCubit>(),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [
                AppColors.primaryLight,
                AppColors.white,
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: BlocBuilder<ChooseRoleCubit, ChooseRoleState>(
                builder: (context, state) {
                  final cubit = context.read<ChooseRoleCubit>();

                  return Column(
                    children: [
                      const SizedBox(height: 12),
                      const LogoHeader(size: 64),
                      const SizedBox(height: 24),
                      Text(
                        t.role.title,
                        style: context.bold24TextMain,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          t.role.subtitle,
                          style: context.regular14TextSub,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 28),
                      RoleCard(
                        title: t.role.patient,
                        description: t.role.patientDesc,
                        icon: Icons.person_outline_rounded,
                        isSelected: state.selectedRole == UserRole.patient,
                        onTap: () => cubit.selectRole(UserRole.patient),
                      ),
                      const SizedBox(height: 16),
                      RoleCard(
                        title: t.role.admin,
                        description: t.role.adminDesc,
                        icon: Icons.grid_view_rounded,
                        isSelected: state.selectedRole == UserRole.admin,
                        onTap: () => cubit.selectRole(UserRole.admin),
                      ),
                      const SizedBox(height: 32),
                      CustomButton(
                        text: t.role.continueBtn,
                        onPressed: () {
                          LoginRoute(role: state.selectedRole).go(context);
                        },
                      ),
                      const SizedBox(height: 16),
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
                              RegisterRoute(role: state.selectedRole).go(context);
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
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
