import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/admin_doctor_model.dart';
import '../../data/repo/admin_repository.dart';
import 'admin_doctors_state.dart';

class AdminDoctorsCubit extends Cubit<AdminDoctorsState> {
  final AdminRepository repository;

  AdminDoctorsCubit({required this.repository}) : super(const AdminDoctorsState());

  Future<void> loadDoctors() async {
    emit(state.copyWith(isLoading: true));
    try {
      final doctors = await repository.getDoctors();
      emit(state.copyWith(
        allDoctors: doctors,
        filteredDoctors: _applyFilters(doctors, state.searchQuery, state.selectedSpecialty),
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(
      searchQuery: query,
      filteredDoctors: _applyFilters(state.allDoctors, query, state.selectedSpecialty),
    ));
  }

  void setSelectedSpecialty(String specialty) {
    emit(state.copyWith(
      selectedSpecialty: specialty,
      filteredDoctors: _applyFilters(state.allDoctors, state.searchQuery, specialty),
    ));
  }

  Future<void> addDoctor(AdminDoctorModel doctor) async {
    emit(state.copyWith(isLoading: true));
    try {
      await repository.addDoctor(doctor);
      await loadDoctors();
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> updateDoctor(AdminDoctorModel doctor) async {
    emit(state.copyWith(isLoading: true));
    try {
      await repository.updateDoctor(doctor);
      await loadDoctors();
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> deleteDoctor(String id) async {
    emit(state.copyWith(isLoading: true));
    try {
      await repository.deleteDoctor(id);
      await loadDoctors();
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> updateDoctorAvailability({
    required String id,
    required Map<String, bool> workingDays,
    required String startTime,
    required String endTime,
    required String slotDuration,
  }) async {
    final index = state.allDoctors.indexWhere((d) => d.id == id);
    if (index != -1) {
      final updated = state.allDoctors[index].copyWith(
        workingDays: workingDays,
        startTime: startTime,
        endTime: endTime,
        slotDuration: slotDuration,
      );
      await updateDoctor(updated);
    }
  }

  List<AdminDoctorModel> _applyFilters(
    List<AdminDoctorModel> doctors,
    String query,
    String specialty,
  ) {
    return doctors.where((doc) {
      final matchesSearch = query.isEmpty ||
          doc.name.toLowerCase().contains(query.toLowerCase()) ||
          doc.specialty.toLowerCase().contains(query.toLowerCase());
      final matchesSpecialty =
          specialty == 'All' || doc.specialty.toLowerCase() == specialty.toLowerCase();
      return matchesSearch && matchesSpecialty;
    }).toList();
  }
}
