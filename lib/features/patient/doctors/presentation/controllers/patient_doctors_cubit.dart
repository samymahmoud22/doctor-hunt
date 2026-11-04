import '../../data/repo/favorites_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../admin/data/models/admin_doctor_model.dart';
import '../../../../admin/data/repo/admin_repository.dart';
import 'patient_doctors_state.dart';

class PatientDoctorsCubit extends Cubit<PatientDoctorsState> {
  final AdminRepository repository;
  final FavoritesRepository favoritesRepository;

  PatientDoctorsCubit({
    required this.repository,
    FavoritesRepository? favoritesRepository,
  })  : favoritesRepository = favoritesRepository ?? _resolveFavorites(repository),
        super(const PatientDoctorsState());

  static FavoritesRepository _resolveFavorites(AdminRepository repo) {
    try {
      return repo.favoritesRepository;
    } catch (_) {
      return FavoritesRepository();
    }
  }

  Future<void> loadDoctors({bool? initialFavoritesOnly}) async {
    emit(state.copyWith(
      isLoading: true,
      onlyFavorites: initialFavoritesOnly ?? state.onlyFavorites,
    ));

    try {
      final list = await repository.getDoctors();
      final activeDoctors = list.where((d) => d.isActive).toList();
      Set<String> favorites = <String>{};
      try {
        favorites = repository.favoriteDoctorIds;
      } catch (_) {
        try {
          favorites = await favoritesRepository.getFavorites();
        } catch (_) {}
      }

      // Popular doctors sorted by rating descending
      final popular = List<AdminDoctorModel>.from(activeDoctors)
        ..sort((a, b) => b.rating.compareTo(a.rating));

      final filtered = _applyFilters(
        doctors: activeDoctors,
        query: state.searchQuery,
        specialty: state.selectedSpecialty,
        onlyFavorites: initialFavoritesOnly ?? state.onlyFavorites,
        favoriteIds: favorites,
      );

      emit(state.copyWith(
        allDoctors: activeDoctors,
        popularDoctors: popular,
        filteredDoctors: filtered,
        favoriteDoctorIds: favorites,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  void setSearchQuery(String query) {
    final filtered = _applyFilters(
      doctors: state.allDoctors,
      query: query,
      specialty: state.selectedSpecialty,
      onlyFavorites: state.onlyFavorites,
      favoriteIds: state.favoriteDoctorIds,
    );

    emit(state.copyWith(
      searchQuery: query,
      filteredDoctors: filtered,
    ));
  }

  void setSelectedSpecialty(String specialty) {
    final filtered = _applyFilters(
      doctors: state.allDoctors,
      query: state.searchQuery,
      specialty: specialty,
      onlyFavorites: state.onlyFavorites,
      favoriteIds: state.favoriteDoctorIds,
    );

    emit(state.copyWith(
      selectedSpecialty: specialty,
      filteredDoctors: filtered,
    ));
  }

  void setOnlyFavorites(bool onlyFavorites) {
    final filtered = _applyFilters(
      doctors: state.allDoctors,
      query: state.searchQuery,
      specialty: state.selectedSpecialty,
      onlyFavorites: onlyFavorites,
      favoriteIds: state.favoriteDoctorIds,
    );

    emit(state.copyWith(
      onlyFavorites: onlyFavorites,
      filteredDoctors: filtered,
    ));
  }

  Future<void> toggleFavorite(String doctorId) async {
    final updatedFavorites = Set<String>.from(state.favoriteDoctorIds);
    if (updatedFavorites.contains(doctorId)) {
      updatedFavorites.remove(doctorId);
    } else {
      updatedFavorites.add(doctorId);
    }

    final filtered = _applyFilters(
      doctors: state.allDoctors,
      query: state.searchQuery,
      specialty: state.selectedSpecialty,
      onlyFavorites: state.onlyFavorites,
      favoriteIds: updatedFavorites,
    );

    emit(state.copyWith(
      favoriteDoctorIds: updatedFavorites,
      filteredDoctors: filtered,
    ));

    try {
      repository.toggleFavorite(doctorId);
    } catch (_) {}
    await favoritesRepository.toggleFavorite(doctorId);
  }

  List<AdminDoctorModel> _applyFilters({
    required List<AdminDoctorModel> doctors,
    required String query,
    required String specialty,
    required bool onlyFavorites,
    required Set<String> favoriteIds,
  }) {
    final cleanQuery = query.trim().toLowerCase();
    final cleanSpecialty = specialty.trim().toLowerCase();

    return doctors.where((doc) {
      if (onlyFavorites && !favoriteIds.contains(doc.id)) {
        return false;
      }
      if (cleanSpecialty != 'all' &&
          !doc.specialty.toLowerCase().contains(cleanSpecialty)) {
        return false;
      }
      if (cleanQuery.isNotEmpty &&
          !doc.name.toLowerCase().contains(cleanQuery) &&
          !doc.specialty.toLowerCase().contains(cleanQuery)) {
        return false;
      }
      return true;
    }).toList();
  }
}

