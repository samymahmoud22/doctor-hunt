import 'package:doctor_hunt/core/extensions/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_hunt/core/di/service_locator.dart';
import 'package:doctor_hunt/core/themes/app_colors.dart';
import 'package:doctor_hunt/core/utils/doctor_image_helper.dart';
import 'package:doctor_hunt/core/widgets/custom_button.dart';
import 'package:go_router/go_router.dart';
import '../controllers/admin_doctors_cubit.dart';
import '../controllers/admin_doctors_state.dart';

class AdminDoctorDetailsScreen extends StatelessWidget {
  final String doctorId;

  const AdminDoctorDetailsScreen({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AdminDoctorsCubit>()..loadDoctors(),
      child: _AdminDoctorDetailsView(doctorId: doctorId),
    );
  }
}

class _AdminDoctorDetailsView extends StatelessWidget {
  final String doctorId;

  const _AdminDoctorDetailsView({required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminDoctorsCubit, AdminDoctorsState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      builder: (context, state) {
        if (state.isLoading || state.allDoctors.isEmpty) {
          return const Scaffold(
            backgroundColor: Color(0xFFF9FAFB),
            body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
          );
        }

        final match = state.allDoctors.firstWhere(
          (d) => d.id == doctorId,
          orElse: () => state.allDoctors.first,
        );
        final doctor = match;
        final cubit = context.read<AdminDoctorsCubit>();

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              context.pop(true);
            }
          },
          child: Scaffold(
            backgroundColor: const Color(0xFFF9FAFB),
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                onPressed: () => context.pop(true),
              ),
            title: const Text(
              'Doctor Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            centerTitle: true,
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF333333)),
                onSelected: (val) async {
                  if (val == 'toggle_status') {
                    final newStatus = !doctor.isActive;
                    final actionLabel = newStatus ? 'Activate' : 'Deactivate';
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('$actionLabel Doctor'),
                        content: Text('Are you sure you want to $actionLabel ${doctor.name}?'),
                        actions: [
                          TextButton(
                            onPressed: () => ctx.pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => ctx.pop(true),
                            style: TextButton.styleFrom(
                              foregroundColor: newStatus ? AppColors.primary : AppColors.danger,
                            ),
                            child: Text(actionLabel),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      final updated = doctor.copyWith(isActive: newStatus);
                      await cubit.updateDoctor(updated);
                      if (context.mounted) {
                        if (cubit.state.errorMessage != null) {
                          context.showSnackBar(cubit.state.errorMessage!, isError: true);
                        } else {
                          context.showSnackBar(
                            'Doctor status updated to ${newStatus ? "Active" : "Inactive"}',
                          );
                        }
                      }
                    }
                  }
                },
                itemBuilder: (ctx) => [
                  PopupMenuItem(
                    value: 'toggle_status',
                    child: Row(
                      children: [
                        Icon(
                          doctor.isActive ? Icons.block_rounded : Icons.check_circle_outline_rounded,
                          size: 18,
                          color: doctor.isActive ? AppColors.danger : AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          doctor.isActive ? 'Deactivate Doctor' : 'Activate Doctor',
                          style: TextStyle(
                            color: doctor.isActive ? AppColors.danger : AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  Center(
                    child: Stack(
                      children: [
                        DoctorImageHelper.buildDoctorAvatar(
                          doctorName: doctor.name,
                          imageUrl: doctor.imageUrl,
                          radius: 54,
                        ),
                        if (doctor.isActive)
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    doctor.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: doctor.isActive
                          ? const Color(0xFFE7F8F2)
                          : const Color(0xFFFFF1F0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: doctor.isActive
                                ? AppColors.primary
                                : const Color(0xFFFF4D4F),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          doctor.isActive ? 'Active' : 'Inactive',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: doctor.isActive
                                ? AppColors.primary
                                : const Color(0xFFFF4D4F),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x06000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildInfoTile(
                          icon: Icons.medical_services_outlined,
                          label: 'Specialty',
                          value: doctor.specialty,
                        ),
                        const Divider(height: 1, indent: 64, endIndent: 20, color: Color(0xFFF3F4F6)),
                        _buildInfoTile(
                          icon: Icons.star_outline_rounded,
                          label: 'Rating',
                          value: doctor.reviewsCount == 0
                              ? 'No reviews yet'
                              : '${doctor.rating.toStringAsFixed(1)} • ${doctor.reviewsCount} reviews',
                        ),
                        const Divider(height: 1, indent: 64, endIndent: 20, color: Color(0xFFF3F4F6)),
                        _buildInfoTile(
                          icon: Icons.attach_money_rounded,
                          label: 'Consultation Fee',
                          value: '\$${doctor.consultationFee.toStringAsFixed(2)}',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),

                  CustomButton(
                    text: 'Edit Doctor',
                    icon: Icons.edit_outlined,
                    height: 52,
                    onPressed: () async {
                      final updated = await context.push<bool>(
                        '/admin/edit-doctor?doctorId=${doctor.id}',
                        extra: doctor,
                      );
                      if (updated == true) {
                        cubit.loadDoctors();
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  CustomButton(
                    text: 'Manage Availability',
                    icon: Icons.event_note_outlined,
                    isOutlined: true,
                    height: 52,
                    onPressed: () async {
                      final updated = await context.push<bool>(
                        '/admin/doctor-availability?doctorId=${doctor.id}',
                        extra: doctor,
                      );
                      if (updated == true) {
                        cubit.loadDoctors();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFE7F8F2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF677294),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
