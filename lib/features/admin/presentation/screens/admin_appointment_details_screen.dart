import '../extensions/admin_appointment_status_ext.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/core/di/service_locator.dart';

import 'package:doctor_hunt/core/extensions/context_ext.dart';

import 'package:doctor_hunt/core/themes/app_colors.dart';

import 'package:doctor_hunt/core/utils/doctor_image_helper.dart';

import 'package:doctor_hunt/core/widgets/custom_button.dart';

import 'package:doctor_hunt/generated/image_assets.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/admin_appointment_model.dart';

import '../controllers/admin_appointments_cubit.dart';

import '../controllers/admin_appointments_state.dart';



class AdminAppointmentDetailsScreen extends StatelessWidget {

  final String appointmentId;



  const AdminAppointmentDetailsScreen({super.key, required this.appointmentId});



  @override

  Widget build(BuildContext context) {

    return BlocProvider(

      create: (_) => sl<AdminAppointmentsCubit>()..loadAppointments(),

      child: _AdminAppointmentDetailsView(appointmentId: appointmentId),

    );

  }

}



class _AdminAppointmentDetailsView extends StatelessWidget {

  final String appointmentId;



  const _AdminAppointmentDetailsView({required this.appointmentId});



  @override

  Widget build(BuildContext context) {

    return BlocConsumer<AdminAppointmentsCubit, AdminAppointmentsState>(

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

        final cubit = context.read<AdminAppointmentsCubit>();



    return Scaffold(

      backgroundColor: AppColors.scaffoldBackground,

      appBar: AppBar(

        leading: IconButton(

          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),

          onPressed: () => context.pop(),

        ),

        title: const Text(

          'Appointment Details',

          style: TextStyle(

            fontSize: 18,

            fontWeight: FontWeight.bold,

            color: AppColors.textMain,

          ),

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

              const Text(

                'Patient',

                style: TextStyle(

                  fontSize: 14,

                  fontWeight: FontWeight.bold,

                  color: AppColors.textMain,

                ),

              ),

              const SizedBox(height: 10),

              Container(

                padding: const EdgeInsets.all(14),

                decoration: BoxDecoration(

                  color: AppColors.white,

                  borderRadius: BorderRadius.circular(16),

                  border: Border.all(color: AppColors.cardBorder),

                ),

                child: Row(

                  children: [

                    CircleAvatar(

                      radius: 22,

                      backgroundColor: AppColors.primary.withValues(alpha: 0.12),

                      child: ClipOval(

                        child: Image.asset(

                          ImageAssets.userAvatar,

                          width: 44,

                          height: 44,

                          fit: BoxFit.cover,

                          errorBuilder: (context, error, stackTrace) => const Icon(

                            Icons.person_rounded,

                            color: AppColors.primary,

                            size: 24,

                          ),

                        ),

                      ),

                    ),

                    const SizedBox(width: 14),

                    Expanded(

                      child: Column(

                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [

                          Text(

                            item.patientName,

                            style: const TextStyle(

                              fontSize: 15,

                              fontWeight: FontWeight.bold,

                              color: AppColors.textMain,

                            ),

                            maxLines: 1,

                            overflow: TextOverflow.ellipsis,

                          ),

                          const SizedBox(height: 2),

                          Text(

                            item.patientEmail,

                            style: const TextStyle(

                              fontSize: 12,

                              color: AppColors.subtext,

                            ),

                            maxLines: 1,

                            overflow: TextOverflow.ellipsis,

                          ),

                        ],

                      ),

                    ),

                  ],

                ),

              ),

              const SizedBox(height: 22),



              const Text(

                'Doctor',

                style: TextStyle(

                  fontSize: 14,

                  fontWeight: FontWeight.bold,

                  color: AppColors.textMain,

                ),

              ),

              const SizedBox(height: 10),

              Container(

                padding: const EdgeInsets.all(14),

                decoration: BoxDecoration(

                  color: AppColors.white,

                  borderRadius: BorderRadius.circular(16),

                  border: Border.all(color: AppColors.cardBorder),

                ),

                child: Row(

                  children: [

                    DoctorImageHelper.buildDoctorAvatar(

                      doctorName: item.doctorName,

                      radius: 22,

                    ),

                    const SizedBox(width: 14),

                    Expanded(

                      child: Column(

                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [

                          Text(

                            item.doctorName,

                            style: const TextStyle(

                              fontSize: 15,

                              fontWeight: FontWeight.bold,

                              color: AppColors.textMain,

                            ),

                            maxLines: 1,

                            overflow: TextOverflow.ellipsis,

                          ),

                          const SizedBox(height: 2),

                          Text(

                            item.doctorSpecialty,

                            style: const TextStyle(

                              fontSize: 12,

                              color: AppColors.subtext,

                            ),

                            maxLines: 1,

                            overflow: TextOverflow.ellipsis,

                          ),

                        ],

                      ),

                    ),

                    const Icon(

                      Icons.check_circle_rounded,

                      color: AppColors.primary,

                      size: 20,

                    ),

                  ],

                ),

              ),

              const SizedBox(height: 22),



              Row(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [

                  const Text(

                    'Appointment',

                    style: TextStyle(

                      fontSize: 14,

                      fontWeight: FontWeight.bold,

                      color: AppColors.textMain,

                    ),

                  ),

                  Container(

                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),

                    decoration: BoxDecoration(

                      color: item.status == AdminAppointmentStatus.cancelled

                          ? AppColors.dangerLight

                          : AppColors.primaryLight,

                      borderRadius: BorderRadius.circular(20),

                    ),

                    child: Text(

                      item.status.displayLabel,

                      style: TextStyle(

                        fontSize: 11,

                        fontWeight: FontWeight.bold,

                        color: item.status == AdminAppointmentStatus.cancelled

                            ? AppColors.danger

                            : AppColors.primary,

                      ),

                    ),

                  ),

                ],

              ),

              const SizedBox(height: 10),



              Container(

                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(

                  color: AppColors.white,

                  borderRadius: BorderRadius.circular(16),

                  border: Border.all(color: AppColors.cardBorder),

                ),

                child: Column(

                  children: [

                    Row(

                      children: [

                        Expanded(

                          child: _buildDetailTile(

                            icon: Icons.calendar_today_outlined,

                            label: 'DATE',

                            value: item.date,

                          ),

                        ),

                        Expanded(

                          child: _buildDetailTile(

                            icon: Icons.access_time_rounded,

                            label: 'TIME',

                            value: item.time,

                          ),

                        ),

                      ],

                    ),

                    const Divider(height: 24, color: AppColors.cardBackground),

                    Row(

                      children: [

                        Expanded(

                          child: _buildDetailTile(

                            icon: Icons.attach_money_rounded,

                            label: 'CONSULTATION FEE',

                            value: '\$${item.fee.toStringAsFixed(2)}',

                          ),

                        ),

                      ],

                    ),

                    const Divider(height: 24, color: AppColors.cardBackground),

                    Row(

                      children: [

                        Expanded(

                          child: _buildDetailTile(

                            icon: Icons.location_on_outlined,

                            label: 'CLINIC LOCATION',

                            value: item.clinicLocation,

                          ),

                        ),

                      ],

                    ),

                  ],

                ),

              ),

              const SizedBox(height: 36),



              if (item.status == AdminAppointmentStatus.upcoming) ...[

                Row(

                  children: [

                    Expanded(

                      child: CustomButton(

                        text: 'Cancel Appointment',

                        height: 50,

                        isOutlined: true,

                        backgroundColor: AppColors.danger,

                        textColor: AppColors.danger,

                        onPressed: () async {

                          await cubit.cancelAppointment(appointmentId);

                          if (context.mounted) {

                            context.showSnackBar('Appointment cancelled');

                            context.pop(true);

                          }

                        },

                      ),

                    ),

                    const SizedBox(width: 12),

                    Expanded(

                      child: CustomButton(

                        text: 'Mark as Completed',

                        icon: Icons.check_rounded,

                        height: 50,

                        backgroundColor: AppColors.primary,

                        textColor: AppColors.white,

                        onPressed: () async {

                          await cubit.markAsCompleted(appointmentId);

                          if (context.mounted) {

                            context.showSnackBar('Appointment marked as completed');

                            context.pop(true);

                          }

                        },

                      ),

                    ),

                  ],

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



  Widget _buildDetailTile({

    required IconData icon,

    required String label,

    required String value,

  }) {

    return Row(

      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        Container(

          width: 34,

          height: 34,

          decoration: BoxDecoration(

            color: AppColors.primaryLight,

            borderRadius: BorderRadius.circular(8),

          ),

          child: Icon(icon, color: AppColors.primary, size: 18),

        ),

        const SizedBox(width: 10),

        Expanded(

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text(

                label,

                style: const TextStyle(

                  fontSize: 10,

                  fontWeight: FontWeight.bold,

                  color: AppColors.subtext,

                  letterSpacing: 0.5,

                ),

              ),

              const SizedBox(height: 3),

              Text(

                value,

                style: const TextStyle(

                  fontSize: 13,

                  fontWeight: FontWeight.w600,

                  color: AppColors.textMain,

                ),

              ),

            ],

          ),

        ),

      ],

    );

  }

}

