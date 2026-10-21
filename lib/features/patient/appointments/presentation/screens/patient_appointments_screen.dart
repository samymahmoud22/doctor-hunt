import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_hunt/core/di/service_locator.dart';
import 'package:doctor_hunt/core/extensions/context_ext.dart';
import 'package:doctor_hunt/core/themes/app_colors.dart';
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
                        } else if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Color(0xFF333333)),
                      ),
                    ),
                  ),
                )
              : null,
          title: const Text(
            'Appointments',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF3FAF7), Colors.white, Color(0xFFE8F7F3)],
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
                            label: 'Upcoming',
                            isSelected: state.selectedTab == PatientAppointmentStatus.upcoming,
                            onTap: () => cubit.setSelectedTab(PatientAppointmentStatus.upcoming),
                          ),
                          const SizedBox(width: 10),
                          _buildTabPill(
                            label: 'Completed',
                            isSelected: state.selectedTab == PatientAppointmentStatus.completed,
                            onTap: () => cubit.setSelectedTab(PatientAppointmentStatus.completed),
                          ),
                          const SizedBox(width: 10),
                          _buildTabPill(
                            label: 'Cancelled',
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
                          : appointments.isEmpty
                              ? _buildEmptyState(state.selectedTab.label)
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
                                        context.showSnackBar('Appointment cancelled');
                                      },
                                      onRate: (rating) {
                                        cubit.rateDoctor(item.id, rating);
                                        context.showSnackBar('Thank you for rating Dr. ${item.doctorName}!');
                                      },
                                      onRateWithComment: (rating, comment) {
                                        cubit.rateDoctor(item.id, rating, comment: comment);
                                        context.showSnackBar('Thank you for rating Dr. ${item.doctorName}!');
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
            color: isSelected ? AppColors.primary : const Color(0xFFE8F7F3),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : AppColors.primary,
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
              'No $tab Appointments',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'You have no $tab appointments at the moment.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Color(0xFF677294)),
            ),
          ],
        ),
      ),
    );
  }
}
