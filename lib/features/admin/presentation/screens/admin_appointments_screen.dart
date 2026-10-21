import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_hunt/core/di/service_locator.dart';
import 'package:doctor_hunt/core/extensions/context_ext.dart';
import 'package:doctor_hunt/core/themes/app_colors.dart';
import 'package:doctor_hunt/generated/image_assets.dart';
import '../controllers/admin_appointments_cubit.dart';
import '../controllers/admin_appointments_state.dart';
import 'package:go_router/go_router.dart';
import '../widgets/admin_appointment_card.dart';

class AdminAppointmentsScreen extends StatelessWidget {
  const AdminAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AdminAppointmentsCubit>()..loadAppointments(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        body: SafeArea(
          child: BlocConsumer<AdminAppointmentsCubit, AdminAppointmentsState>(
            listener: (context, state) {
              if (state.errorMessage != null) {
                context.showSnackBar(state.errorMessage!, isError: true);
              }
            },
            builder: (context, state) {
              final cubit = context.read<AdminAppointmentsCubit>();
              final appointments = state.currentTabAppointments;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Appointments',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        Row(
                          children: [
                            Stack(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.notifications_outlined,
                                    color: Color(0xFF677294),
                                  ),
                                  onPressed: () {},
                                ),
                                Positioned(
                                  top: 10,
                                  right: 12,
                                  child: Container(
                                    width: 7,
                                    height: 7,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFF4D4F),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 4),
                            CircleAvatar(
                              radius: 17,
                              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                              child: ClipOval(
                                child: Image.asset(
                                  ImageAssets.userAvatar,
                                  width: 34,
                                  height: 34,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Text(
                                    'A',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildTabPill(
                            label: 'All',
                            isSelected: state.selectedTab == AdminAppointmentTab.all,
                            onTap: () => cubit.setSelectedTab(AdminAppointmentTab.all),
                          ),
                          const SizedBox(width: 8),
                          _buildTabPill(
                            label: 'Upcoming',
                            isSelected: state.selectedTab == AdminAppointmentTab.upcoming,
                            onTap: () => cubit.setSelectedTab(AdminAppointmentTab.upcoming),
                          ),
                          const SizedBox(width: 8),
                          _buildTabPill(
                            label: 'Completed',
                            isSelected: state.selectedTab == AdminAppointmentTab.completed,
                            onTap: () => cubit.setSelectedTab(AdminAppointmentTab.completed),
                          ),
                          const SizedBox(width: 8),
                          _buildTabPill(
                            label: 'Cancelled',
                            isSelected: state.selectedTab == AdminAppointmentTab.cancelled,
                            onTap: () => cubit.setSelectedTab(AdminAppointmentTab.cancelled),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Expanded(
                    child: state.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(color: AppColors.primary),
                          )
                        : appointments.isEmpty
                            ? _buildEmptyAppointments(state.selectedTab.label)
                            : ListView.builder(
                                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                                itemCount: appointments.length,
                                itemBuilder: (context, index) {
                                  final item = appointments[index];
                                  return AdminAppointmentCard(
                                    appointment: item,
                                    onTap: () async {
                                      final updated = await context.push<bool>(
                                        '/admin/appointment-details?appointmentId=${item.id}',
                                      );
                                      if (updated == true) {
                                        cubit.loadAppointments();
                                      }
                                    },
                                    onComplete: () {
                                      cubit.markAsCompleted(item.id);
                                      context.showSnackBar('Appointment marked as completed');
                                    },
                                    onCancel: () {
                                      cubit.cancelAppointment(item.id);
                                      context.showSnackBar('Appointment cancelled');
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
    );
  }

  Widget _buildTabPill({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE5E7EB),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : const Color(0xFF677294),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyAppointments(String tab) {
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
              'There are no $tab appointments to display at the moment.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Color(0xFF677294)),
            ),
          ],
        ),
      ),
    );
  }
}
