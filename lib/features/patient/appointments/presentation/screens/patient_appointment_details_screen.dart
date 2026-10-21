import 'package:flutter/material.dart';
import 'package:doctor_hunt/core/di/service_locator.dart';
import 'package:doctor_hunt/core/extensions/context_ext.dart';
import 'package:doctor_hunt/core/themes/app_colors.dart';
import 'package:doctor_hunt/core/widgets/custom_button.dart';
import '../../data/models/patient_appointment_model.dart';
import '../../data/repo/patient_appointments_repository.dart';
import '../widgets/rate_doctor_dialog.dart';

class PatientAppointmentDetailsScreen extends StatefulWidget {
  final String appointmentId;

  const PatientAppointmentDetailsScreen({super.key, required this.appointmentId});

  @override
  State<PatientAppointmentDetailsScreen> createState() => _PatientAppointmentDetailsScreenState();
}

class _PatientAppointmentDetailsScreenState extends State<PatientAppointmentDetailsScreen> {
  PatientAppointmentModel? _appointment;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await sl<PatientAppointmentsRepository>().getAppointments();
    final match = list.firstWhere(
      (a) => a.id == widget.appointmentId,
      orElse: () => list.first,
    );
    setState(() {
      _appointment = match;
      _isLoading = false;
    });
  }

  Future<void> _cancel() async {
    await sl<PatientAppointmentsRepository>().cancelAppointment(widget.appointmentId);
    if (mounted) {
      context.showSnackBar('Appointment cancelled');
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
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
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.doctorSpecialty,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF677294),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: item.status == PatientAppointmentStatus.cancelled
                            ? const Color(0xFFFFF1F0)
                            : const Color(0xFFE7F8F2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item.status.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: item.status == PatientAppointmentStatus.cancelled
                              ? const Color(0xFFFF4D4F)
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
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'APPOINTMENT DATE',
                      value: item.date,
                    ),
                    const Divider(height: 24, color: Color(0xFFF3F4F6)),
                    _buildDetailRow(
                      icon: Icons.access_time_rounded,
                      label: 'APPOINTMENT TIME',
                      value: item.time,
                    ),
                    const Divider(height: 24, color: Color(0xFFF3F4F6)),
                    _buildDetailRow(
                      icon: Icons.attach_money_rounded,
                      label: 'CONSULTATION FEE',
                      value: '\$${item.fee.toStringAsFixed(2)}',
                    ),
                    const Divider(height: 24, color: Color(0xFFF3F4F6)),
                    _buildDetailRow(
                      icon: Icons.location_on_outlined,
                      label: 'CLINIC LOCATION',
                      value: item.clinicLocation,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              if (item.status == PatientAppointmentStatus.upcoming)
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: _cancel,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFFF4D4F), width: 1.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: const Color(0xFFFFF1F0),
                    ),
                    child: const Text(
                      'Cancel Appointment',
                      style: TextStyle(
                        color: Color(0xFFFF4D4F),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              if (item.status == PatientAppointmentStatus.completed) ...[
                if (item.isRated)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBE6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFFE58F)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Color(0xFFF6D060), size: 20),
                            const SizedBox(width: 6),
                            Text(
                              'Your Rating: ${item.userRating ?? 5.0} / 5.0',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF874D00),
                              ),
                            ),
                          ],
                        ),
                        if (item.reviewComment != null && item.reviewComment!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            '"${item.reviewComment}"',
                            style: const TextStyle(
                              color: Color(0xFF874D00),
                              fontStyle: FontStyle.italic,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                else
                  CustomButton(
                    text: 'Rate Doctor (1–5 Stars)',
                    height: 52,
                    onPressed: () {
                      RateDoctorDialog.show(
                        context,
                        appointment: item,
                        onSubmit: (rating, comment) async {
                          await sl<PatientAppointmentsRepository>()
                              .rateDoctor(item.id, rating, comment: comment);
                          if (!mounted) return;
                          this.context.showSnackBar('Thank you for your review!');
                          _load();
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
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFE7F8F2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF677294),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
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
