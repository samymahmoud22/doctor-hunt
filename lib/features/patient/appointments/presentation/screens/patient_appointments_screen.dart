import '../extensions/patient_appointment_status_ext.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/core/di/service_locator.dart';

import 'package:doctor_hunt/core/extensions/context_ext.dart';

import 'package:doctor_hunt/core/themes/app_colors.dart';

import 'package:doctor_hunt/core/themes/app_text_styles.dart';

import 'package:doctor_hunt/generated/i18n/strings.g.dart';

import '../../data/models/patient_appointment_model.dart';

import '../controllers/patient_appointments_cubit.dart';

import '../controllers/patient_appointments_state.dart';

import 'package:go_router/go_router.dart';

import '../widgets/patient_appointment_card.dart';



class PatientAppointmentsScreen extends StatelessWidget {

  final bool showBackButton;

  final VoidCallback? onBack;



  const PatientAppointmentsScreen({

    super.key,

    this.showBackButton = false,

    this.onBack,

  });



  @override

  Widget build(BuildContext context) {

    return BlocProvider(

      create: (_) => sl<PatientAppointmentsCubit>()..loadAppointments(),

      child: Scaffold(

        backgroundColor: Colors.transparent,

        appBar: AppBar(

          leading: showBackButton

              ? Padding(

                  padding: const EdgeInsets.only(left: 16),

                  child: Center(

                    child: InkWell(

                      onTap: () {

                        if (onBack != null) {

                          onBack!();

                        } else if (context.canPop()) {

                          context.pop();

                        }

                      },

                      borderRadius: BorderRadius.circular(12),

                      child: Container(

                        width: 38,

                        height: 38,

                        decoration: BoxDecoration(

                          color: AppColors.white,

                          borderRadius: BorderRadius.circular(12),

                          boxShadow: const [

                            BoxShadow(

                              color: AppColors.boxShadow,

                              blurRadius: 8,

                              offset: Offset(0, 2),

                            ),

                          ],

                        ),

                        child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppColors.textMain),

                      ),

                    ),

                  ),

                )

              : null,

          title: Text(

            t.appointments.myAppointments,

            style: AppTextStyles.h3,

          ),

          centerTitle: true,

          backgroundColor: Colors.transparent,

          elevation: 0,

        ),

        body: Container(

          decoration: const BoxDecoration(

            gradient: LinearGradient(

              colors: [AppColors.backgroundLight, AppColors.white, AppColors.primaryLight],

              begin: Alignment.topCenter,

              end: Alignment.bottomCenter,

            ),

          ),

          child: SafeArea(

            child: BlocConsumer<PatientAppointmentsCubit, PatientAppointmentsState>(

              listener: (context, state) {

                if (state.errorMessage != null) {

                  context.showSnackBar(state.errorMessage!, isError: true);

                }

              },

              builder: (context, state) {

                final cubit = context.read<PatientAppointmentsCubit>();

                final appointments = state.currentTabAppointments;



                return Column(

                  children: [

                    Padding(

                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),

                      child: Row(

                        children: [

                          _buildTabPill(

                            label: t.appointments.upcoming,

                            isSelected: state.selectedTab == PatientAppointmentStatus.upcoming,

                            onTap: () => cubit.setSelectedTab(PatientAppointmentStatus.upcoming),

                          ),

                          const SizedBox(width: 10),

                          _buildTabPill(

                            label: t.appointments.completed,

                            isSelected: state.selectedTab == PatientAppointmentStatus.completed,

                            onTap: () => cubit.setSelectedTab(PatientAppointmentStatus.completed),

                          ),

                          const SizedBox(width: 10),

                          _buildTabPill(

                            label: t.appointments.cancelled,

                            isSelected: state.selectedTab == PatientAppointmentStatus.cancelled,

                            onTap: () => cubit.setSelectedTab(PatientAppointmentStatus.cancelled),

                          ),

                        ],

                      ),

                    ),

                    const SizedBox(height: 10),



                    Expanded(

                      child: state.isLoading

                          ? const Center(

                              child: CircularProgressIndicator(color: AppColors.primary),

                            )

                          : (state.errorMessage != null && state.allAppointments.isEmpty)

                              ? _buildErrorState(cubit, state.errorMessage!)

                              : appointments.isEmpty

                                  ? _buildEmptyState(state.selectedTab.displayLabel)

                              : ListView.builder(

                                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),

                                  itemCount: appointments.length,

                                  itemBuilder: (context, index) {

                                    final item = appointments[index];

                                    return PatientAppointmentCard(

                                      appointment: item,

                                      onTap: () async {

                                        final updated = await context.push<bool>(

                                          '/patient/appointment-details?appointmentId=${item.id}',

                                        );

                                        if (updated == true) {

                                          cubit.loadAppointments();

                                        }

                                      },

                                      onCancel: () {

                                        cubit.cancelAppointment(item.id);

                                        context.showSnackBar(t.common.success);

                                      },

                                      onRate: (rating) {

                                        cubit.rateDoctor(item.id, rating);

                                        context.showSnackBar(t.common.success);

                                      },

                                      onRateWithComment: (rating, comment) {

                                        cubit.rateDoctor(item.id, rating, comment: comment);

                                        context.showSnackBar(t.common.success);

                                      },

                                    );

                                  },

                                ),

                    ),

                  ],

                );

              },

            ),

          ),

        ),

      ),

    );

  }



  Widget _buildTabPill({

    required String label,

    required bool isSelected,

    required VoidCallback onTap,

  }) {

    return Expanded(

      child: InkWell(

        onTap: onTap,

        borderRadius: BorderRadius.circular(10),

        child: Container(

          padding: const EdgeInsets.symmetric(vertical: 12),

          decoration: BoxDecoration(

            color: isSelected ? AppColors.primary : AppColors.primaryLight,

            borderRadius: BorderRadius.circular(10),

          ),

          alignment: Alignment.center,

          child: Text(

            label,

            style: AppTextStyles.buttonSmall.copyWith(

              color: isSelected ? AppColors.white : AppColors.primary,

            ),

          ),

        ),

      ),

    );

  }



  Widget _buildEmptyState(String tab) {

    return Center(

      child: Padding(

        padding: const EdgeInsets.all(32),

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Container(

              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(

                color: AppColors.primary.withValues(alpha: 0.1),

                shape: BoxShape.circle,

              ),

              child: const Icon(

                Icons.calendar_today_rounded,

                size: 40,

                color: AppColors.primary,

              ),

            ),

            const SizedBox(height: 16),

            Text(

              t.appointments.noAppointments,

              style: AppTextStyles.titleMedium,

            ),

            const SizedBox(height: 6),

            Text(

              t.appointments.noAppointmentsDesc,

              textAlign: TextAlign.center,

              style: AppTextStyles.subtextSmall,

            ),

          ],

        ),

      ),

    );

  }



  Widget _buildErrorState(PatientAppointmentsCubit cubit, String message) {

    return Center(

      child: Padding(

        padding: const EdgeInsets.all(32),

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Container(

              padding: const EdgeInsets.all(20),

              decoration: const BoxDecoration(

                color: AppColors.dangerLight,

                shape: BoxShape.circle,

              ),

              child: const Icon(

                Icons.error_outline_rounded,

                size: 40,

                color: AppColors.danger,

              ),

            ),

            const SizedBox(height: 16),

            Text(

              'Failed to load appointments',

              style: AppTextStyles.h3,

            ),

            const SizedBox(height: 6),

            Text(

              message,

              textAlign: TextAlign.center,

              style: AppTextStyles.subtextSmall.copyWith(color: AppColors.danger),

            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(

              style: ElevatedButton.styleFrom(

                backgroundColor: AppColors.primary,

                foregroundColor: Colors.white,

                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

              ),

              icon: const Icon(Icons.refresh_rounded, size: 18),

              label: const Text('Retry'),

              onPressed: () => cubit.loadAppointments(),

            ),

          ],

        ),

      ),

    );

  }

}

