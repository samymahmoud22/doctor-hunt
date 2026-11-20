import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/auth/data/repo/auth_repository.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/services/session_manager.dart';
import '../../../../../core/services/supabase_storage_service.dart';
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
        avatarUrl: profile['avatarUrl'] ?? state.avatarUrl,
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
    String? avatarUrl,
  }) async {
    emit(state.copyWith(isLoading: true, isSaved: false, errorMessage: null));
    try {
      final targetAvatarUrl = avatarUrl ?? state.avatarUrl;
      if (targetAvatarUrl != null) {
        await repository.updatePatientProfile(
          fullName: fullName,
          phone: phone,
          avatarUrl: targetAvatarUrl,
        );
      } else {
        await repository.updatePatientProfile(
          fullName: fullName,
          phone: phone,
        );
      }
      emit(state.copyWith(
        fullName: fullName,
        phone: phone,
        avatarUrl: targetAvatarUrl,
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

  Future<String?> uploadAvatar(Uint8List bytes) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final userId = sl.isRegistered<SessionManager>() ? sl<SessionManager>().userId : null;
      final targetId = userId ?? 'user_${DateTime.now().millisecondsSinceEpoch}';
      
      final storageService = sl.isRegistered<SupabaseStorageService>() 
          ? sl<SupabaseStorageService>() 
          : SupabaseStorageService();

      final url = await storageService.uploadUserAvatar(
        userId: targetId,
        bytes: bytes,
      );

      if (url != null) {
        emit(state.copyWith(avatarUrl: url, isLoading: false));
      } else {
        emit(state.copyWith(isLoading: false));
      }
      return url;
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString().replaceAll('Exception: ', '')));
      return null;
    }
  }
}

