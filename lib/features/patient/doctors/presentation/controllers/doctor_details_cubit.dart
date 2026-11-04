import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../admin/data/repo/admin_repository.dart';
import '../../data/repo/favorites_repository.dart';
import 'doctor_details_state.dart';

class DoctorDetailsCubit extends Cubit<DoctorDetailsState> {
  final AdminRepository repository;
  final FavoritesRepository favoritesRepository;

  DoctorDetailsCubit({
    required this.repository,
    FavoritesRepository? favoritesRepository,
  })  : favoritesRepository = favoritesRepository ?? _resolveFavorites(repository),
        super(const DoctorDetailsState());

  static FavoritesRepository _resolveFavorites(AdminRepository repo) {
    try {
      return repo.favoritesRepository;
    } catch (_) {
      return FavoritesRepository();
    }
  }

  Future<void> loadDoctorDetails(String doctorName, {String? specialty}) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final doctors = await repository.getDoctors();
      final match = doctors.firstWhere(
        (d) => d.name.toLowerCase() == doctorName.toLowerCase() ||
               (specialty != null && specialty.isNotEmpty && d.specialty.toLowerCase().contains(specialty.toLowerCase())),
        orElse: () => doctors.first,
      );

      final reviews = await repository.getDoctorReviews(match.id);
      bool isFav = false;
      try {
        isFav = repository.isFavorite(match.id);
      } catch (_) {
        try {
          isFav = await favoritesRepository.isFavoriteAsync(match.id);
        } catch (_) {}
      }

      emit(state.copyWith(
        doctor: match,
        reviews: reviews,
        isFavorite: isFav,
        clinicLocation: match.clinicLocation.isNotEmpty ? match.clinicLocation : repository.centralLocation,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> toggleFavorite() async {
    if (state.doctor == null) return;
    final doctorId = state.doctor!.id;
    final newFav = !state.isFavorite;
    emit(state.copyWith(isFavorite: newFav));
    try {
      repository.toggleFavorite(doctorId);
    } catch (_) {}
    await favoritesRepository.toggleFavorite(doctorId);
  }
}
