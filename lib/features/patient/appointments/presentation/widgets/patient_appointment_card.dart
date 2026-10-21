import 'package:flutter/material.dart';
import 'package:doctor_hunt/core/themes/app_colors.dart';
import 'package:doctor_hunt/core/widgets/custom_button.dart';
import 'package:doctor_hunt/core/utils/doctor_image_helper.dart';
import 'package:doctor_hunt/generated/image_assets.dart';
import '../../data/models/patient_appointment_model.dart';
import 'rate_doctor_dialog.dart';

class PatientAppointmentCard extends StatefulWidget {
  final PatientAppointmentModel appointment;
  final VoidCallback onTap;
  final VoidCallback? onCancel;
  final void Function(double rating)? onRate;
  final void Function(double rating, String? comment)? onRateWithComment;

  const PatientAppointmentCard({
    super.key,
    required this.appointment,
    required this.onTap,
    this.onCancel,
    this.onRate,
    this.onRateWithComment,
  });

  @override
  State<PatientAppointmentCard> createState() => _PatientAppointmentCardState();
}

class _PatientAppointmentCardState extends State<PatientAppointmentCard> {
  double _currentRating = 0;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.appointment.userRating ?? 0;
  }

  String _getDoctorImage(String name) {
    return DoctorImageHelper.getDoctorPhoto(name);
  }

  @override
  Widget build(BuildContext context) {
    final appointment = widget.appointment;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F2F5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        _getDoctorImage(appointment.doctorName),
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.doctorName,
                            style: const TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            appointment.doctorSpecialty,
                            style: const TextStyle(
                              color: Color(0xFF677294),
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    _buildStatusPill(appointment.status),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE7F8F2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 14,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Appointment date',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF677294),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    appointment.date,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE7F8F2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.monetization_on_outlined,
                                  size: 14,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Consultation fee',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF677294),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '\$${appointment.fee.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE7F8F2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.access_time_rounded,
                                  size: 14,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Appointment time',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF677294),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    appointment.time,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                if (appointment.status == PatientAppointmentStatus.completed) ...[
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        appointment.isRated ? 'Your rating' : 'Tap to rate your visit',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF677294),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: List.generate(5, (index) {
                          final starIndex = index + 1;
                          final isFilled = starIndex <= _currentRating;

                          return GestureDetector(
                            onTap: appointment.isRated
                                ? null
                                : () {
                                    setState(() => _currentRating = starIndex.toDouble());
                                  },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              child: Icon(
                                isFilled ? Icons.star_rounded : Icons.star_border_rounded,
                                size: 20,
                                color: const Color(0xFFF6D060),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 16),

                if (appointment.status == PatientAppointmentStatus.upcoming) ...[
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: widget.onTap,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primary, width: 1.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: const Text(
                            'View Details',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: widget.onCancel,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFFF7875), width: 1.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: const Text(
                            'Cancel Appointment',
                            style: TextStyle(
                              color: Color(0xFFFF4D4F),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else if (appointment.status == PatientAppointmentStatus.completed) ...[
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: widget.onTap,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primary, width: 1.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: const Text(
                            'View Details',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomButton(
                          text: appointment.isRated ? 'Rated' : 'Rate Doctor',
                          height: 38,
                          fontSize: 12,
                          borderRadius: BorderRadius.circular(10),
                          backgroundColor: appointment.isRated ? AppColors.grey : AppColors.primary,
                          textColor: AppColors.white,
                          onPressed: appointment.isRated
                              ? null
                              : () {
                                  RateDoctorDialog.show(
                                    context,
                                    appointment: appointment,
                                    onSubmit: (rating, comment) {
                                      widget.onRateWithComment?.call(rating, comment);
                                      widget.onRate?.call(rating);
                                    },
                                  );
                                },
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: widget.onTap,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary, width: 1.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text(
                        'View Details',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusPill(PatientAppointmentStatus status) {
    Color bg;
    Color textColor;
    String label;

    switch (status) {
      case PatientAppointmentStatus.upcoming:
        bg = const Color(0xFFE7F8F2);
        textColor = AppColors.primary;
        label = 'Upcoming';
        break;
      case PatientAppointmentStatus.completed:
        bg = const Color(0xFFE7F8F2);
        textColor = AppColors.primary;
        label = 'Completed';
        break;
      case PatientAppointmentStatus.cancelled:
        bg = const Color(0xFFFFF1F0);
        textColor = const Color(0xFFFF4D4F);
        label = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
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
              color: textColor,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
