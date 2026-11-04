import '../extensions/patient_appointment_status_ext.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/core/di/service_locator.dart';

import 'package:doctor_hunt/core/extensions/context_ext.dart';

import 'package:doctor_hunt/core/themes/app_colors.dart';

import 'package:doctor_hunt/core/themes/app_text_styles.dart';

import 'package:doctor_hunt/core/widgets/custom_button.dart';

import 'package:doctor_hunt/generated/i18n/strings.g.dart';

import '../../data/models/patient_appointment_model.dart';

import '../controllers/patient_appointments_cubit.dart';

import '../controllers/patient_appointments_state.dart';

import '../widgets/rate_doctor_dialog.dart';



class PatientAppointmentDetailsScreen extends StatelessWidget {

  final String appointmentId;



  const PatientAppointmentDetailsScreen({super.key, required this.appointmentId});



  @override

  Widget build(BuildContext context) {

    return BlocProvider(

      create: (_) => sl<PatientAppointmentsCubit>()..loadAppointments(),

      child: _PatientAppointmentDetailsView(appointmentId: appointmentId),

    );

  }

}



class _PatientAppointmentDetailsView extends StatelessWidget {

  final String appointmentId;



  const _PatientAppointmentDetailsView({required this.appointmentId});



  @override

  Widget build(BuildContext context) {

    return BlocConsumer<PatientAppointmentsCubit, PatientAppointmentsState>(

      listener: (context, state) {

        if (state.errorMessage != null) {

          context.showSnackBar(state.errorMessage!, isError: true);

        }

      },

      builder: (context, state) {

        if (state.isLoading || state.allAppointments.isEmpty) {

          return const Scaffold(

            backgroundColor: AppColors.scaffoldBackground,

            body: Center(child: CircularProgressIndicator(color: AppColors.primary)),

          );

        }



        final match = state.allAppointments.firstWhere(

          (a) => a.id == appointmentId,

          orElse: () => state.allAppointments.first,

        );

        final item = match;

        final cubit = context.read<PatientAppointmentsCubit>();



        return Scaffold(

          backgroundColor: AppColors.scaffoldBackground,

          appBar: AppBar(

            leading: IconButton(

              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),

              onPressed: () => context.pop(),

            ),

            title: Text(

              t.appointments.appointmentDetails,

              style: AppTextStyles.h3,

            ),

            centerTitle: true,

            backgroundColor: Colors.transparent,

            elevation: 0,

          ),

          body: SafeArea(

            child: SingleChildScrollView(

              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Container(

                    padding: const EdgeInsets.all(16),

                    decoration: BoxDecoration(

                      color: AppColors.white,

                      borderRadius: BorderRadius.circular(16),

                      border: Border.all(color: AppColors.divider),

                    ),

                    child: Row(

                      children: [

                        CircleAvatar(

                          radius: 28,

                          backgroundColor: AppColors.primary.withValues(alpha: 0.12),

                          child: const Icon(

                            Icons.person_rounded,

                            color: AppColors.primary,

                            size: 32,

                          ),

                        ),

                        const SizedBox(width: 14),

                        Expanded(

                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [

                              Text(

                                item.doctorName,

                                style: AppTextStyles.titleMedium,

                              ),

                              const SizedBox(height: 3),

                              Text(

                                item.doctorSpecialty,

                                style: AppTextStyles.subtextSmall,

                              ),

                            ],

                          ),

                        ),

                        Container(

                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),

                          decoration: BoxDecoration(

                            color: item.status == PatientAppointmentStatus.cancelled

                                ? AppColors.dangerLight

                                : AppColors.primaryLight,

                            borderRadius: BorderRadius.circular(20),

                          ),

                          child: Text(

                            item.status.displayLabel,

                            style: AppTextStyles.captionBold.copyWith(

                              color: item.status == PatientAppointmentStatus.cancelled

                                  ? AppColors.danger

                                  : AppColors.primary,

                            ),

                          ),

                        ),

                      ],

                    ),

                  ),

                  const SizedBox(height: 20),



                  Container(

                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(

                      color: AppColors.white,

                      borderRadius: BorderRadius.circular(16),

                      border: Border.all(color: AppColors.divider),

                    ),

                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        Text(

                          t.appointments.dateAndTime,

                          style: AppTextStyles.labelBold,

                        ),

                        const SizedBox(height: 14),

                        _buildDetailRow(

                          icon: Icons.calendar_today_rounded,

                          label: 'Date',

                          value: item.date,

                        ),

                        const Divider(height: 20, color: AppColors.cardBackground),

                        _buildDetailRow(

                          icon: Icons.access_time_rounded,

                          label: 'Time',

                          value: item.time,

                        ),

                        const Divider(height: 20, color: AppColors.cardBackground),

                        _buildDetailRow(

                          icon: Icons.location_on_rounded,

                          label: t.appointments.location,

                          value: item.clinicLocation.isNotEmpty

                              ? item.clinicLocation

                              : 'DoctorHunt HQ Clinic',

                        ),

                      ],

                    ),

                  ),

                  const SizedBox(height: 20),



                  Container(

                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(

                      color: AppColors.white,

                      borderRadius: BorderRadius.circular(16),

                      border: Border.all(color: AppColors.divider),

                    ),

                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        Text(

                          t.appointments.fee,

                          style: AppTextStyles.labelBold,

                        ),

                        const SizedBox(height: 14),

                        _buildDetailRow(

                          icon: Icons.payments_rounded,

                          label: t.appointments.fee,

                          value: '\$${item.fee.toStringAsFixed(0)}',

                        ),

                        const Divider(height: 20, color: AppColors.cardBackground),

                        _buildDetailRow(

                          icon: Icons.confirmation_number_rounded,

                          label: 'Booking ID',

                          value: item.id.toUpperCase(),

                        ),

                      ],

                    ),

                  ),

                  const SizedBox(height: 32),



                  if (item.status == PatientAppointmentStatus.upcoming) ...[

                    CustomButton(

                      text: t.appointments.cancelAppointment,

                      height: 52,

                      backgroundColor: AppColors.dangerLight,

                      textColor: AppColors.danger,

                      onPressed: () async {

                        final confirm = await showDialog<bool>(

                          context: context,

                          builder: (ctx) => AlertDialog(

                            backgroundColor: AppColors.white,

                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

                            title: Text(t.appointments.cancelAppointment, style: AppTextStyles.h3),

                            content: Text(t.appointments.cancelConfirm, style: AppTextStyles.subtext),

                            actions: [

                              TextButton(

                                onPressed: () => ctx.pop(false),

                                child: Text(t.common.cancel, style: AppTextStyles.subtext),

                              ),

                              TextButton(

                                onPressed: () => ctx.pop(true),

                                child: Text(

                                  t.appointments.cancelAppointment,

                                  style: AppTextStyles.buttonSmall.withDanger.withBold,

                                ),

                              ),

                            ],

                          ),

                        );

                        if (confirm == true) {

                          await cubit.cancelAppointment(appointmentId);

                          if (context.mounted) {

                            context.showSnackBar(t.common.success);

                            context.pop(true);

                          }

                        }

                      },

                    ),

                  ] else if (item.status == PatientAppointmentStatus.completed) ...[

                    if (item.rating != null)

                      Container(

                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(

                          color: AppColors.warningLight,

                          borderRadius: BorderRadius.circular(14),

                          border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),

                        ),

                        child: Column(

                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [

                            Row(

                              children: [

                                const Icon(Icons.star_rounded, color: AppColors.warning, size: 20),

                                const SizedBox(width: 8),

                                Text(

                                  'Your Review: ${item.rating!.toStringAsFixed(1)} / 5.0',

                                  style: AppTextStyles.labelBold.copyWith(color: const Color(0xFF874D00)),

                                ),

                              ],

                            ),

                            if (item.reviewComment != null && item.reviewComment!.isNotEmpty) ...[

                              const SizedBox(height: 6),

                              Text(

                                '"${item.reviewComment}"',

                                style: AppTextStyles.subtextMedium.copyWith(

                                  fontStyle: FontStyle.italic,

                                  color: const Color(0xFF874D00),

                                ),

                              ),

                            ],

                          ],

                        ),

                      )

                    else

                      CustomButton(

                        text: t.appointments.rateDoctor,

                        height: 52,

                        onPressed: () {

                          RateDoctorDialog.show(

                            context,

                            appointment: item,

                            onSubmit: (rating, comment) async {

                              await cubit.rateDoctor(item.id, rating, comment: comment);

                              if (!context.mounted) return;

                              context.showSnackBar(t.common.success);

                            },

                          );

                        },

                      ),

                  ],

                ],

              ),

            ),

          ),

        );

      },

    );

  }



  Widget _buildDetailRow({

    required IconData icon,

    required String label,

    required String value,

  }) {

    return Row(

      children: [

        Container(

          padding: const EdgeInsets.all(8),

          decoration: BoxDecoration(

            color: AppColors.cardBackground,

            borderRadius: BorderRadius.circular(8),

          ),

          child: Icon(icon, size: 18, color: AppColors.primary),

        ),

        const SizedBox(width: 14),

        Expanded(

          child: Text(

            label,

            style: AppTextStyles.subtext,

          ),

        ),

        Text(

          value,

          style: AppTextStyles.labelBold,

        ),

      ],

    );

  }

}

