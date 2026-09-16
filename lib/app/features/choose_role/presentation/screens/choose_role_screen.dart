import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/logo_header.dart';
import 'package:doctor_hunt/generated/i18n/strings.g.dart';
import '../controller/choose_role_cubit.dart';
import '../controller/choose_role_state.dart';
import '../widgets/role_card.dart';

class ChooseRoleScreen extends StatelessWidget {
  const ChooseRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChooseRoleCubit(),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [
                Color(0xFFE8F7F4),
                Colors.white,
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
                        style: const TextStyle(
                          color: Color(0xFF1F2937),
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          t.role.subtitle,
                          style: const TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 14,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 28),
                      RoleCard(
                        title: t.role.patient,
                        description: t.role.patientDesc,
                        icon: Icons.person_outline_rounded,
                        isSelected: state.selectedRole == AppConstants.rolePatient,
                        onTap: () => cubit.selectRole(AppConstants.rolePatient),
                      ),
                      const SizedBox(height: 16),
                      RoleCard(
                        title: t.role.admin,
                        description: t.role.adminDesc,
                        icon: Icons.grid_view_rounded,
                        isSelected: state.selectedRole == AppConstants.roleAdmin,
                        onTap: () => cubit.selectRole(AppConstants.roleAdmin),
                      ),
                      const SizedBox(height: 32),
                      CustomButton(
                        text: t.role.continueBtn,
                        onPressed: () {
                          LoginRoute(role: state.selectedRole).go(context);
                        },
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
