import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doctor_hunt/core/themes/app_colors.dart';
import 'package:doctor_hunt/core/themes/app_text_styles.dart';
import 'package:doctor_hunt/core/widgets/custom_button.dart';
import 'package:doctor_hunt/core/widgets/custom_text_field.dart';
import 'package:doctor_hunt/generated/i18n/strings.g.dart';
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
      backgroundColor: AppColors.white,
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
                '${t.appointments.rateDoctor} ${widget.appointment.doctorName}',
                style: AppTextStyles.h3,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                widget.appointment.doctorSpecialty,
                style: AppTextStyles.subtextSmall,
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
                        color: AppColors.ratingStar,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 6),
              Text(
                '$_rating / 5.0 Stars',
                style: AppTextStyles.captionBold.withTextSub,
              ),
              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  t.appointments.commentOptional,
                  style: AppTextStyles.captionBold,
                ),
              ),
              const SizedBox(height: 6),
              CustomTextField(
                controller: _commentController,
                hint: t.appointments.shareExperience,
                maxLines: 3,
                fillColor: AppColors.inputBackground,
              ),
              const SizedBox(height: 24),

              CustomButton(
                text: t.appointments.submitReview,
                onPressed: () {
                  final commentText = _commentController.text.trim();
                  widget.onSubmit(
                    _rating,
                    commentText.isEmpty ? null : commentText,
                  );
                  context.pop();
                },
              ),
              const SizedBox(height: 8),

              TextButton(
                onPressed: () => context.pop(),
                child: Text(
                  t.common.cancel,
                  style: AppTextStyles.subtext,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
