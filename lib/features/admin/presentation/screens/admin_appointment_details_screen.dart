import 'package:flutter/material.dart';
import 'package:doctor_hunt/core/di/service_locator.dart';
import 'package:doctor_hunt/core/extensions/context_ext.dart';
import 'package:doctor_hunt/core/themes/app_colors.dart';
import 'package:doctor_hunt/core/utils/doctor_image_helper.dart';
import 'package:doctor_hunt/core/widgets/custom_button.dart';
import 'package:doctor_hunt/generated/image_assets.dart';
import '../../data/models/admin_appointment_model.dart';
import '../../data/repo/admin_repository.dart';

class AdminAppointmentDetailsScreen extends StatefulWidget {
  final String appointmentId;

  const AdminAppointmentDetailsScreen({super.key, required this.appointmentId});

  @override
  State<AdminAppointmentDetailsScreen> createState() => _AdminAppointmentDetailsScreenState();
}

class _AdminAppointmentDetailsScreenState extends State<AdminAppointmentDetailsScreen> {
  AdminAppointmentModel? _appointment;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await sl<AdminRepository>().getAppointments();
    final match = list.firstWhere(
      (a) => a.id == widget.appointmentId,
      orElse: () => list.first,
    );
    setState(() {
      _appointment = match;
      _isLoading = false;
    });
  }

  Future<void> _updateStatus(AdminAppointmentStatus status) async {
    await sl<AdminRepository>().updateAppointmentStatus(widget.appointmentId, status);
    if (mounted) {
      context.showSnackBar(
        status == AdminAppointmentStatus.completed
            ? 'Appointment marked as completed'
            : 'Appointment cancelled',
      );
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _appointment == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF9FAFB),
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    final item = _appointment!;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Appointment Details',
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
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
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
                              color: Color(0xFF333333),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.patientEmail,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF677294),
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
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
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
                              color: Color(0xFF333333),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.doctorSpecialty,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF677294),
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
                      color: Color(0xFF333333),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: item.status == AdminAppointmentStatus.cancelled
                          ? const Color(0xFFFFF1F0)
                          : const Color(0xFFE7F8F2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item.status.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: item.status == AdminAppointmentStatus.cancelled
                            ? const Color(0xFFFF4D4F)
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
                  border: Border.all(color: const Color(0xFFE5E7EB)),
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
                    const Divider(height: 24, color: Color(0xFFF3F4F6)),
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
                    const Divider(height: 24, color: Color(0xFFF3F4F6)),
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
                        backgroundColor: const Color(0xFFFF4D4F),
                        textColor: const Color(0xFFFF4D4F),
                        onPressed: () => _updateStatus(AdminAppointmentStatus.cancelled),
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
                        onPressed: () => _updateStatus(AdminAppointmentStatus.completed),
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
            color: const Color(0xFFE7F8F2),
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
                  color: Color(0xFF677294),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
