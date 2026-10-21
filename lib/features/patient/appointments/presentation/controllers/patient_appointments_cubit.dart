import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/patient_appointment_model.dart';
import '../../data/repo/patient_appointments_repository.dart';
import 'patient_appointments_state.dart';

class PatientAppointmentsCubit extends Cubit<PatientAppointmentsState> {
  final PatientAppointmentsRepository repository;

  PatientAppointmentsCubit({required this.repository})
      : super(const PatientAppointmentsState());

  Future<void> loadAppointments() async {
    emit(state.copyWith(isLoading: true));
    try {
      final appointments = await repository.getAppointments();
      emit(state.copyWith(allAppointments: appointments, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void setSelectedTab(PatientAppointmentStatus status) {
    emit(state.copyWith(selectedTab: status));
  }

  Future<void> cancelAppointment(String id) async {
    try {
      await repository.cancelAppointment(id);
      await loadAppointments();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> rateDoctor(String id, double rating, {String? comment}) async {
    try {
      await repository.rateDoctor(id, rating, comment: comment);
      await loadAppointments();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> bookAppointment(PatientAppointmentModel appointment) async {
    try {
      await repository.bookAppointment(appointment);
      await loadAppointments();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
