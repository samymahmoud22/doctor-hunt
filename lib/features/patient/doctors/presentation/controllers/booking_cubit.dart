import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../admin/data/models/admin_doctor_model.dart';
import '../../../../admin/data/repo/admin_repository.dart';
import '../../data/repo/favorites_repository.dart';
import '../../../appointments/data/models/patient_appointment_model.dart';
import '../../../appointments/data/repo/patient_appointments_repository.dart';
import '../../../../../core/errors/booking_exceptions.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final AdminRepository adminRepository;
  final PatientAppointmentsRepository appointmentsRepository;
  final FavoritesRepository favoritesRepository;

  static const List<String> afternoonSlots = [
    '1:00 PM',
    '1:30 PM',
    '2:00 PM',
    '2:30 PM',
    '3:00 PM',
    '3:30 PM',
    '4:00 PM',
  ];

  static const List<String> eveningSlots = [
    '5:00 PM',
    '5:30 PM',
    '6:00 PM',
    '6:30 PM',
    '7:00 PM',
  ];

  static const List<String> weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const List<String> monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  BookingCubit({
    required this.adminRepository,
    required this.appointmentsRepository,
    FavoritesRepository? favoritesRepository,
  })  : favoritesRepository = favoritesRepository ?? _resolveFavorites(adminRepository),
        super(const BookingState());

  static FavoritesRepository _resolveFavorites(AdminRepository adminRepo) {
    try {
      return adminRepo.favoritesRepository;
    } catch (_) {
      return FavoritesRepository();
    }
  }

  static String formatDateStr(DateTime date) {
    return '${date.day} ${monthNames[date.month - 1]} ${date.year}';
  }

  bool hasWorkingSlots(AdminDoctorModel doc, DateTime date) {
    final dayName = weekDays[date.weekday - 1];
    return doc.workingDays[dayName] == true;
  }

  Set<String> getBookedSlotsForDate(String doctorId, DateTime date) {
    final dateStr = formatDateStr(date);
    return adminRepository.getBookedSlotsForDoctor(
      doctorId: doctorId,
      date: dateStr,
    );
  }

  int getAvailableSlotsCount(AdminDoctorModel doc, DateTime date) {
    if (!hasWorkingSlots(doc, date)) return 0;
    final totalSlots = afternoonSlots.length + eveningSlots.length;
    final booked = getBookedSlotsForDate(doc.id, date);
    final available = totalSlots - booked.length;
    return available > 0 ? available : 0;
  }

  bool isSlotBooked(String slot) => state.bookedSlots.contains(AdminRepository.normalizeTime(slot));
  int get availableAfternoonCount => afternoonSlots.where((s) => !isSlotBooked(s)).length;
  int get availableEveningCount => eveningSlots.where((s) => !isSlotBooked(s)).length;
  bool isDateWorking(DateTime date) => state.doctor != null && hasWorkingSlots(state.doctor!, date);
  int getAvailableSlots(DateTime date) => state.doctor != null ? getAvailableSlotsCount(state.doctor!, date) : 0;

  Future<void> loadBookingData(String doctorName) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final doctors = await adminRepository.getDoctors();
      await adminRepository.getAppointments();

      final match = doctors.firstWhere(
        (d) => d.name.toLowerCase() == doctorName.toLowerCase(),
        orElse: () => doctors.first,
      );

      final List<DateTime> datesList = [];
      final now = DateTime.now();
      for (int i = 0; i < 10; i++) {
        datesList.add(now.add(Duration(days: i)));
      }

      DateTime? initialDate;
      for (final d in datesList) {
        if (hasWorkingSlots(match, d) && getAvailableSlotsCount(match, d) > 0) {
          initialDate ??= d;
          break;
        }
      }

      final chosenDate = initialDate ?? datesList.first;
      final booked = getBookedSlotsForDate(match.id, chosenDate);
      final allSlots = [...afternoonSlots, ...eveningSlots];
      final firstFreeSlot = allSlots.firstWhere(
        (s) => !booked.contains(AdminRepository.normalizeTime(s)),
        orElse: () => allSlots.first,
      );

      bool isFav = false;
      try {
        isFav = await favoritesRepository.isFavoriteAsync(match.id);
      } catch (_) {
        isFav = favoritesRepository.isFavorite(match.id);
      }

      emit(state.copyWith(
        doctor: match,
        dates: datesList,
        selectedDate: chosenDate,
        selectedSlot: firstFreeSlot,
        bookedSlots: booked,
        isFavorite: isFav,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  void selectDate(DateTime date) {
    if (state.doctor == null) return;
    final booked = getBookedSlotsForDate(state.doctor!.id, date);

    String? newSlot = state.selectedSlot;
    if (newSlot == null || booked.contains(AdminRepository.normalizeTime(newSlot))) {
      final allSlots = [...afternoonSlots, ...eveningSlots];
      final firstFree = allSlots.firstWhere(
        (s) => !booked.contains(AdminRepository.normalizeTime(s)),
        orElse: () => '',
      );
      newSlot = firstFree.isNotEmpty ? firstFree : null;
    }

    emit(state.copyWith(
      selectedDate: date,
      selectedSlot: newSlot,
      bookedSlots: booked,
    ));
  }

  void selectSlot(String slot) {
    if (state.bookedSlots.contains(AdminRepository.normalizeTime(slot))) {
      return; // cannot select booked slot
    }
    emit(state.copyWith(selectedSlot: slot));
  }

  Future<void> toggleFavorite() async {
    if (state.doctor == null) return;
    final docId = state.doctor!.id;
    final newFav = !state.isFavorite;
    emit(state.copyWith(isFavorite: newFav));
    await favoritesRepository.toggleFavorite(docId);
  }

  Future<bool> confirmBooking() async {
    if (state.doctor == null || state.selectedDate == null) return false;
    if (state.selectedSlot == null) {
      emit(state.copyWith(errorMessage: 'Please select an available time slot.'));
      return false;
    }

    final doc = state.doctor!;
    final dateStr = formatDateStr(state.selectedDate!);
    final slot = state.selectedSlot!;

    if (appointmentsRepository.isSlotBooked(doctorId: doc.id, date: dateStr, time: slot)) {
      final updatedBooked = getBookedSlotsForDate(doc.id, state.selectedDate!);
      emit(state.copyWith(
        bookedSlots: updatedBooked,
        errorMessage: 'This time slot has already been booked. Please choose another time.',
      ));
      return false;
    }

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

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

    try {
      await appointmentsRepository.bookAppointment(newApt);
      emit(state.copyWith(
        isSubmitting: false,
        bookingSuccess: true,
        bookedAppointment: newApt,
      ));
      return true;
    } on AlreadyBookedException catch (e) {
      final updatedBooked = getBookedSlotsForDate(doc.id, state.selectedDate!);
      emit(state.copyWith(
        isSubmitting: false,
        bookedSlots: updatedBooked,
        errorMessage: e.message,
      ));
      return false;
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
      return false;
    }
  }
}
