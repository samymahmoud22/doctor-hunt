import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/admin_repository.dart';
import 'admin_profile_state.dart';

class AdminProfileCubit extends Cubit<AdminProfileState> {
  final AdminRepository repository;

  AdminProfileCubit({required this.repository}) : super(const AdminProfileState());

  Future<void> loadProfile() async {
    emit(state.copyWith(isLoading: true));
    try {
      final profile = await repository.getAdminProfile();
      emit(state.copyWith(
        fullName: profile['fullName'] ?? state.fullName,
        email: profile['email'] ?? state.email,
        clinicLocation: profile['clinicLocation'] ?? state.clinicLocation,
        initials: profile['initials'] ?? state.initials,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> updateProfile({
    required String fullName,
    required String email,
    required String clinicLocation,
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      await repository.updateAdminProfile(
        fullName: fullName,
        email: email,
        clinicLocation: clinicLocation,
      );
      final profile = await repository.getAdminProfile();
      emit(state.copyWith(
        fullName: profile['fullName'] ?? fullName,
        email: profile['email'] ?? email,
        clinicLocation: profile['clinicLocation'] ?? clinicLocation,
        initials: profile['initials'] ?? 'AK',
        isLoading: false,
        isSaved: true,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
