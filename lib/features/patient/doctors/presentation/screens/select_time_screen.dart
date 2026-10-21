import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doctor_hunt/core/di/service_locator.dart';
import 'package:doctor_hunt/core/themes/app_colors.dart';
import 'package:doctor_hunt/core/widgets/custom_button.dart';
import 'package:doctor_hunt/features/admin/data/models/admin_doctor_model.dart';
import 'package:doctor_hunt/features/admin/data/repo/admin_repository.dart';
import 'package:doctor_hunt/features/patient/appointments/data/models/patient_appointment_model.dart';
import 'package:doctor_hunt/features/patient/appointments/data/repo/patient_appointments_repository.dart';
import 'package:doctor_hunt/features/patient/appointments/presentation/widgets/thank_you_booking_dialog.dart';
import 'package:doctor_hunt/generated/i18n/strings.g.dart';
import 'package:doctor_hunt/generated/image_assets.dart';

class SelectTimeScreen extends StatefulWidget {
  final String doctorName;

  const SelectTimeScreen({
    super.key,
    this.doctorName = 'Dr. Shruti Kedia',
  });

  @override
  State<SelectTimeScreen> createState() => _SelectTimeScreenState();
}

class _SelectTimeScreenState extends State<SelectTimeScreen> {
  AdminDoctorModel? _doctor;
  bool _isLoading = true;
  bool _isFavorite = false;

  late List<DateTime> _dates;
  DateTime? _selectedDate;
  String? _selectedSlot = '2:00 PM';

  final List<String> _afternoonSlots = [
    '1:00 PM',
    '1:30 PM',
    '2:00 PM',
    '2:30 PM',
    '3:00 PM',
    '3:30 PM',
    '4:00 PM',
  ];

  final List<String> _eveningSlots = [
    '5:00 PM',
    '5:30 PM',
    '6:00 PM',
    '6:30 PM',
    '7:00 PM',
  ];

  final List<String> _weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void initState() {
    super.initState();
    _loadDoctorData();
  }

  Future<void> _loadDoctorData() async {
    final repo = sl<AdminRepository>();
    final doctors = await repo.getDoctors();
    final match = doctors.firstWhere(
      (d) => d.name.toLowerCase() == widget.doctorName.toLowerCase(),
      orElse: () => doctors.first,
    );

    final List<DateTime> datesList = [];
    final now = DateTime.now();
    for (int i = 0; i < 10; i++) {
      datesList.add(now.add(Duration(days: i)));
    }

    DateTime? initialDate;
    for (final d in datesList) {
      if (_hasSlots(match, d)) {
        initialDate ??= d;
      }
    }

    setState(() {
      _doctor = match;
      _dates = datesList;
      _selectedDate = initialDate ?? datesList.first;
      _isFavorite = repo.isFavorite(match.id);
      _isLoading = false;
    });
  }

  bool _hasSlots(AdminDoctorModel doc, DateTime date) {
    final dayName = _weekDays[date.weekday - 1];
    return doc.workingDays[dayName] == true;
  }

  int _getSlotsCount(AdminDoctorModel doc, DateTime date) {
    if (!_hasSlots(doc, date)) return 0;
    return (date.day % 2 == 0) ? 9 : 12;
  }

  String _dateCardLabel(DateTime date, int index) {
    final dayStr = '${date.day} ${_monthName(date.month)}';
    if (index == 0) return 'Today, $dayStr';
    if (index == 1) return 'Tomorrow, $dayStr';
    return '${_dayShortName(date.weekday)}, $dayStr';
  }

  String _monthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  String _dayShortName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  Future<void> _confirmBooking() async {
    if (_doctor == null || _selectedDate == null) return;
    final doc = _doctor!;
    final dateStr = '${_selectedDate!.day} ${_monthName(_selectedDate!.month)} ${_selectedDate!.year}';
    final slot = _selectedSlot ?? '02:00 PM';

    final newApt = PatientAppointmentModel(
      id: 'p_apt_${DateTime.now().millisecondsSinceEpoch}',
      doctorId: doc.id,
      doctorName: doc.name,
      doctorSpecialty: doc.specialty,
      date: dateStr,
      time: slot,
      fee: doc.consultationFee,
      clinicLocation: doc.clinicLocation,
      status: PatientAppointmentStatus.upcoming,
    );

    await sl<PatientAppointmentsRepository>().bookAppointment(newApt);

    if (mounted) {
      ThankYouBookingDialog.show(
        context,
        doctorName: doc.name,
        date: dateStr,
        time: slot,
        onDone: () {
          Navigator.of(context).pop();
          context.pop(true);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _doctor == null) {
      return const Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    final doc = _doctor!;
    final repo = sl<AdminRepository>();
    final hasSlotsForSelectedDate = _selectedDate != null && _hasSlots(doc, _selectedDate!);
    final selectedDateStr = _selectedDate != null
        ? _dateCardLabel(_selectedDate!, _dates.indexOf(_selectedDate!))
        : '';

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF3FAF7), Colors.white, Color(0xFFE8F7F3)],
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
                        child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Color(0xFF333333)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      t.doctors.selectTime,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
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
                                      color: Color(0xFF333333),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    doc.clinicLocation,
                                    style: const TextStyle(
                                      color: Color(0xFF677294),
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
                                        color: isFilled ? const Color(0xFFF6D060) : const Color(0xFFE5E7EB),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  repo.toggleFavorite(doc.id);
                                  _isFavorite = repo.isFavorite(doc.id);
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(6),
                                child: Icon(
                                  _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                  color: const Color(0xFFFF4D4F),
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
                          itemCount: _dates.length,
                          itemBuilder: (context, index) {
                            final date = _dates[index];
                            final isSelected = _selectedDate != null &&
                                _selectedDate!.year == date.year &&
                                _selectedDate!.month == date.month &&
                                _selectedDate!.day == date.day;

                            final slotsCount = _getSlotsCount(doc, date);
                            final label = _dateCardLabel(date, index);
                            final slotsText = slotsCount == 0
                                ? 'No slots available'
                                : '$slotsCount slots available';

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedDate = date;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primary : AppColors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected ? AppColors.primary : const Color(0xFFE5E7EB),
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
                                        color: isSelected ? Colors.white : const Color(0xFF333333),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      slotsText,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                                        color: isSelected ? Colors.white70 : const Color(0xFF677294),
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
                            color: Color(0xFF333333),
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
                                  color: Color(0xFF677294),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 60),
                      ] else ...[
                        const Text(
                          'Afternoon 7 slots',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: _afternoonSlots.map((slot) {
                            return _buildSlotChip(slot);
                          }).toList(),
                        ),
                        const SizedBox(height: 24),

                        const Text(
                          'Evening 5 slots',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: _eveningSlots.map((slot) {
                            return _buildSlotChip(slot);
                          }).toList(),
                        ),
                        const SizedBox(height: 36),

                        CustomButton(
                          text: 'Confirm',
                          height: 48,
                          onPressed: _confirmBooking,
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
  }

  Widget _buildSlotChip(String slot) {
    final isSelected = _selectedSlot == slot;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSlot = slot;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : const Color(0xFFE8F7F3),
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
        color: Color(0xFFEAF3FF),
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
              border: Border.all(color: const Color(0xFF4A90E2), width: 2.2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4A90E2).withValues(alpha: 0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 3, width: 24, color: const Color(0xFF9EC5F7)),
                const SizedBox(height: 6),
                Container(height: 3, width: 34, color: const Color(0xFF9EC5F7)),
                const SizedBox(height: 6),
                Container(height: 3, width: 20, color: const Color(0xFF9EC5F7)),
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
                border: Border.all(color: const Color(0xFF4A90E2), width: 2.5),
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 20,
                color: Color(0xFF4A90E2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
