import 'package:equatable/equatable.dart';
import '../../../../admin/data/models/admin_doctor_model.dart';
import '../../../appointments/data/models/patient_appointment_model.dart';

class BookingState extends Equatable {
  final AdminDoctorModel? doctor;
  final List<DateTime> dates;
  final DateTime? selectedDate;
  final String? selectedSlot;
  final Set<String> bookedSlots;
  final bool isFavorite;
  final bool isLoading;
  final bool isSubmitting;
  final bool bookingSuccess;
  final PatientAppointmentModel? bookedAppointment;
  final String? errorMessage;

  const BookingState({
    this.doctor,
    this.dates = const [],
    this.selectedDate,
    this.selectedSlot = '2:00 PM',
    this.bookedSlots = const {},
    this.isFavorite = false,
    this.isLoading = true,
    this.isSubmitting = false,
    this.bookingSuccess = false,
    this.bookedAppointment,
    this.errorMessage,
  });

  BookingState copyWith({
    AdminDoctorModel? doctor,
    List<DateTime>? dates,
    DateTime? selectedDate,
    String? selectedSlot,
    Set<String>? bookedSlots,
    bool? isFavorite,
    bool? isLoading,
    bool? isSubmitting,
    bool? bookingSuccess,
    PatientAppointmentModel? bookedAppointment,
    String? errorMessage,
  }) {
    return BookingState(
      doctor: doctor ?? this.doctor,
      dates: dates ?? this.dates,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedSlot: selectedSlot ?? this.selectedSlot,
      bookedSlots: bookedSlots ?? this.bookedSlots,
      isFavorite: isFavorite ?? this.isFavorite,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      bookingSuccess: bookingSuccess ?? this.bookingSuccess,
      bookedAppointment: bookedAppointment ?? this.bookedAppointment,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        doctor,
        dates,
        selectedDate,
        selectedSlot,
        bookedSlots,
        isFavorite,
        isLoading,
        isSubmitting,
        bookingSuccess,
        bookedAppointment,
        errorMessage,
      ];
}

