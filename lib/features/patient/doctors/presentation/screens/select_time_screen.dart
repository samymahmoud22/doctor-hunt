import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:doctor_hunt/core/di/service_locator.dart';
import 'package:doctor_hunt/core/themes/app_colors.dart';
import 'package:doctor_hunt/core/widgets/custom_button.dart';
import 'package:doctor_hunt/features/patient/appointments/presentation/widgets/thank_you_booking_dialog.dart';
import 'package:doctor_hunt/features/patient/doctors/presentation/controllers/booking_cubit.dart';
import 'package:doctor_hunt/features/patient/doctors/presentation/controllers/booking_state.dart';
import 'package:doctor_hunt/generated/i18n/strings.g.dart';
import 'package:doctor_hunt/generated/image_assets.dart';

class SelectTimeScreen extends StatelessWidget {
  final String doctorName;

  const SelectTimeScreen({
    super.key,
    this.doctorName = 'Dr. Shruti Kedia',
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BookingCubit>()..loadBookingData(doctorName),
      child: SelectTimeView(doctorName: doctorName),
    );
  }
}

class SelectTimeView extends StatelessWidget {
  final String doctorName;

  const SelectTimeView({
    super.key,
    required this.doctorName,
  });

  String _dateCardLabel(DateTime date, int index) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dayStr = '${date.day} ${months[date.month - 1]}';
    if (index == 0) return 'Today, $dayStr';
    if (index == 1) return 'Tomorrow, $dayStr';
    return '${days[date.weekday - 1]}, $dayStr';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state.errorMessage != null && !state.bookingSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.danger,
              content: Text(state.errorMessage!),
            ),
          );
        } else if (state.bookingSuccess && state.bookedAppointment != null) {
          final apt = state.bookedAppointment!;
          ThankYouBookingDialog.show(
            context,
            doctorName: apt.doctorName,
            date: apt.date,
            time: apt.time,
            onDone: () {
              context.pop();
              context.pop(true);
            },
          );
        }
      },
      builder: (context, state) {
        if (state.isLoading || state.doctor == null) {
          return const Scaffold(
            backgroundColor: AppColors.backgroundLight,
            body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
          );
        }

        final doc = state.doctor!;
        final cubit = context.read<BookingCubit>();
        final hasSlotsForSelectedDate = state.selectedDate != null &&
            cubit.isDateWorking(state.selectedDate!) &&
            cubit.getAvailableSlots(state.selectedDate!) > 0;

        final selectedDateStr = state.selectedDate != null
            ? _dateCardLabel(state.selectedDate!, state.dates.indexOf(state.selectedDate!))
            : '';

        final availAfternoon = cubit.availableAfternoonCount;
        final availEvening = cubit.availableEveningCount;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.backgroundLight, Colors.white, AppColors.mintLight],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => context.pop(),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppColors.textMain),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          t.doctors.selectTime,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMain,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    ImageAssets.onboarding2Jpg,
                                    width: 62,
                                    height: 62,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        doc.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textMain,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        doc.clinicLocation,
                                        style: const TextStyle(
                                          color: AppColors.subtext,
                                          fontSize: 12,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: List.generate(5, (index) {
                                          final isFilled = index < (doc.rating.round().clamp(1, 5));
                                          return Icon(
                                            Icons.star_rounded,
                                            size: 15,
                                            color: isFilled ? AppColors.ratingStar : AppColors.cardBorder,
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    cubit.toggleFavorite();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Icon(
                                      state.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                      color: AppColors.danger,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          SizedBox(
                            height: 64,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.dates.length,
                              itemBuilder: (context, index) {
                                final date = state.dates[index];
                                final isSelected = state.selectedDate != null &&
                                    state.selectedDate!.year == date.year &&
                                    state.selectedDate!.month == date.month &&
                                    state.selectedDate!.day == date.day;

                                final slotsCount = cubit.getAvailableSlots(date);
                                final label = _dateCardLabel(date, index);
                                final slotsText = slotsCount == 0
                                    ? 'No slots available'
                                    : '$slotsCount slots available';

                                return GestureDetector(
                                  onTap: () {
                                    cubit.selectDate(date);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: isSelected ? AppColors.primary : AppColors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isSelected ? AppColors.primary : AppColors.cardBorder,
                                      ),
                                      boxShadow: [
                                        if (isSelected)
                                          BoxShadow(
                                            color: AppColors.primary.withValues(alpha: 0.25),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          label,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected ? Colors.white : AppColors.textMain,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          slotsText,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                                            color: isSelected ? Colors.white70 : AppColors.subtext,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),

                          Center(
                            child: Text(
                              selectedDateStr,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textMain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          if (!hasSlotsForSelectedDate) ...[
                            const SizedBox(height: 40),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildEmptySlotsIllustration(),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'No slots available',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.subtext,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 60),
                          ] else ...[
                            Text(
                              'Afternoon ($availAfternoon available)',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textMain,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: BookingCubit.afternoonSlots.map((slot) {
                                final isBooked = cubit.isSlotBooked(slot);
                                return _buildSlotChip(context, slot, isBooked, state.selectedSlot == slot);
                              }).toList(),
                            ),
                            const SizedBox(height: 24),

                            Text(
                              'Evening ($availEvening available)',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textMain,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: BookingCubit.eveningSlots.map((slot) {
                                final isBooked = cubit.isSlotBooked(slot);
                                return _buildSlotChip(context, slot, isBooked, state.selectedSlot == slot);
                              }).toList(),
                            ),
                            const SizedBox(height: 36),

                            CustomButton(
                              text: 'Confirm',
                              height: 48,
                              isLoading: state.isSubmitting,
                              onPressed: () {
                                cubit.confirmBooking();
                              },
                            ),
                            const SizedBox(height: 24),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSlotChip(BuildContext context, String slot, bool isBooked, bool isSelected) {
    if (isBooked) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              slot,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: AppColors.textSecondary,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.dangerBg,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Booked',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: AppColors.danger,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        context.read<BookingCubit>().selectSlot(slot);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.mintLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          slot,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptySlotsIllustration() {
    return Container(
      width: 130,
      height: 130,
      decoration: const BoxDecoration(
        color: AppColors.infoBlueLight,
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 58,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.infoBlue, width: 2.2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.infoBlue.withValues(alpha: 0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 3, width: 24, color: AppColors.infoBlue.withValues(alpha: 0.45)),
                const SizedBox(height: 6),
                Container(height: 3, width: 34, color: AppColors.infoBlue.withValues(alpha: 0.45)),
                const SizedBox(height: 6),
                Container(height: 3, width: 20, color: AppColors.infoBlue.withValues(alpha: 0.45)),
              ],
            ),
          ),
          Positioned(
            right: 28,
            bottom: 24,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.infoBlue, width: 2.5),
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 20,
                color: AppColors.infoBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
