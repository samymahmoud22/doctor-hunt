import 'package:flutter/material.dart';
import 'package:doctor_hunt/core/themes/app_colors.dart';
import 'package:doctor_hunt/core/widgets/custom_button.dart';

class ThankYouBookingDialog extends StatelessWidget {
  final String doctorName;
  final String date;
  final String time;
  final VoidCallback onDone;

  const ThankYouBookingDialog({
    super.key,
    required this.doctorName,
    required this.date,
    required this.time,
    required this.onDone,
  });

  static Future<void> show(
    BuildContext context, {
    required String doctorName,
    required String date,
    required String time,
    required VoidCallback onDone,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => ThankYouBookingDialog(
        doctorName: doctorName,
        date: date,
        time: time,
        onDone: onDone,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: AppColors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: const BoxDecoration(
                color: Color(0xFFE7F8F2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.thumb_up_alt_rounded,
                size: 42,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Thank You !',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 8),

            const Text(
              'Your Appointment Successful',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF677294),
              ),
            ),
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'You booked an appointment with $doctorName on $date at $time',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF677294),
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 28),

            CustomButton(
              text: 'Done',
              height: 48,
              onPressed: onDone,
            ),
          ],
        ),
      ),
    );
  }
}
