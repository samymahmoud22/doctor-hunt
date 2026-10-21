import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/admin_appointment_model.dart';
import '../../data/repo/admin_repository.dart';
import 'admin_appointments_state.dart';

class AdminAppointmentsCubit extends Cubit<AdminAppointmentsState> {
  final AdminRepository repository;

  AdminAppointmentsCubit({required this.repository})
      : super(const AdminAppointmentsState());

  Future<void> loadAppointments() async {
    emit(state.copyWith(isLoading: true));
    try {
      final appointments = await repository.getAppointments();
      emit(state.copyWith(allAppointments: appointments, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void setSelectedTab(AdminAppointmentTab tab) {
    emit(state.copyWith(selectedTab: tab));
  }

  Future<void> markAsCompleted(String id) async {
    try {
      await repository.updateAppointmentStatus(id, AdminAppointmentStatus.completed);
      await loadAppointments();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> cancelAppointment(String id) async {
    try {
      await repository.updateAppointmentStatus(id, AdminAppointmentStatus.cancelled);
      await loadAppointments();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
