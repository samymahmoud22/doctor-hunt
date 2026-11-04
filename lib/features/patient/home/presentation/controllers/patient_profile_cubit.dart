import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/auth/data/repo/auth_repository.dart';
import 'patient_profile_state.dart';

class PatientProfileCubit extends Cubit<PatientProfileState> {
  final AuthRepository repository;

  PatientProfileCubit({required this.repository}) : super(const PatientProfileState());

  Future<void> loadProfile() async {
    emit(state.copyWith(isLoading: true, isSaved: false, errorMessage: null));
    try {
      final profile = await repository.getPatientProfile();
      emit(state.copyWith(
        fullName: profile['fullName'] ?? state.fullName,
        phone: profile['phone'] ?? state.phone,
        email: profile['email'] ?? state.email,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<bool> updateProfile({
    required String fullName,
    required String phone,
  }) async {
    emit(state.copyWith(isLoading: true, isSaved: false, errorMessage: null));
    try {
      await repository.updatePatientProfile(
        fullName: fullName,
        phone: phone,
      );
      emit(state.copyWith(
        fullName: fullName,
        phone: phone,
        isLoading: false,
        isSaved: true,
      ));
      return true;
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
      return false;
    }
  }
}

