import 'package:flutter/material.dart';
import 'package:doctor_hunt/core/themes/app_colors.dart';
import 'package:doctor_hunt/core/widgets/custom_button.dart';
import '../../data/models/patient_appointment_model.dart';

class RateDoctorDialog extends StatefulWidget {
  final PatientAppointmentModel appointment;
  final void Function(double rating, String? comment) onSubmit;

  const RateDoctorDialog({
    super.key,
    required this.appointment,
    required this.onSubmit,
  });

  static Future<void> show(
    BuildContext context, {
    required PatientAppointmentModel appointment,
    required void Function(double rating, String? comment) onSubmit,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => RateDoctorDialog(
        appointment: appointment,
        onSubmit: onSubmit,
      ),
    );
  }

  @override
  State<RateDoctorDialog> createState() => _RateDoctorDialogState();
}

class _RateDoctorDialogState extends State<RateDoctorDialog> {
  double _rating = 5.0;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                child: const Icon(Icons.person_rounded, size: 40, color: AppColors.primary),
              ),
              const SizedBox(height: 12),

              Text(
                'Rate ${widget.appointment.doctorName}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                widget.appointment.doctorSpecialty,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF677294),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starIndex = index + 1;
                  final isFilled = starIndex <= _rating;

                  return GestureDetector(
                    onTap: () {
                      setState(() => _rating = starIndex.toDouble());
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        isFilled ? Icons.star_rounded : Icons.star_border_rounded,
                        size: 34,
                        color: const Color(0xFFF6D060),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 6),
              Text(
                '$_rating / 5.0 Stars',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF677294),
                ),
              ),
              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'COMMENT (OPTIONAL)',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _commentController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Share your consultation experience...',
                  hintStyle: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 13),
                  contentPadding: const EdgeInsets.all(12),
                  filled: true,
                  fillColor: const Color(0xFFF9FAFB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              CustomButton(
                text: 'Submit Review',
                onPressed: () {
                  final commentText = _commentController.text.trim();
                  widget.onSubmit(
                    _rating,
                    commentText.isEmpty ? null : commentText,
                  );
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel', style: TextStyle(color: Color(0xFF677294))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
