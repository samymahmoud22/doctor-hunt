import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doctor_hunt/core/di/service_locator.dart';
import 'package:doctor_hunt/core/themes/app_colors.dart';
import 'package:doctor_hunt/features/admin/data/models/admin_doctor_model.dart';
import 'package:doctor_hunt/features/admin/data/repo/admin_repository.dart';
import 'package:doctor_hunt/core/utils/doctor_image_helper.dart';
import 'package:doctor_hunt/generated/image_assets.dart';
import 'package:doctor_hunt/generated/i18n/strings.g.dart';

class FindDoctorsScreen extends StatefulWidget {
  final String? initialQuery;
  final bool showBackButton;
  final bool initialFavoritesOnly;
  final VoidCallback? onBack;

  const FindDoctorsScreen({
    super.key,
    this.initialQuery,
    this.showBackButton = true,
    this.initialFavoritesOnly = false,
    this.onBack,
  });

  @override
  State<FindDoctorsScreen> createState() => _FindDoctorsScreenState();
}

class _FindDoctorsScreenState extends State<FindDoctorsScreen> {
  late TextEditingController _searchController;
  String _selectedSpecialty = 'All';
  bool _onlyFavorites = false;
  List<AdminDoctorModel> _allDoctors = [];
  bool _isLoading = true;

  final List<String> _specialties = [
    'All',
    'Dentist',
    'Cardiologist',
    'Medicine Specialist',
    'Orthopedic',
    'Eye',
    'Pediatrician',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? '');
    _onlyFavorites = widget.initialFavoritesOnly;
    _loadDoctors();
  }

  Future<void> _loadDoctors() async {
    final list = await sl<AdminRepository>().getDoctors();
    setState(() {
      _allDoctors = list.where((d) => d.isActive).toList();
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<AdminDoctorModel> get _filteredDoctors {
    final query = _searchController.text.trim().toLowerCase();
    final repo = sl<AdminRepository>();

    return _allDoctors.where((doc) {
      if (_onlyFavorites && !repo.isFavorite(doc.id)) {
        return false;
      }
      if (_selectedSpecialty != 'All' &&
          !doc.specialty.toLowerCase().contains(_selectedSpecialty.toLowerCase())) {
        return false;
      }
      if (query.isNotEmpty &&
          !doc.name.toLowerCase().contains(query) &&
          !doc.specialty.toLowerCase().contains(query)) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final repo = sl<AdminRepository>();
    final doctors = _filteredDoctors;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    if (widget.showBackButton) ...[
                      InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          if (widget.onBack != null) {
                            widget.onBack!();
                          } else if (context.canPop()) {
                            context.pop();
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 16,
                            color: AppColors.textMain,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                    ],
                    Text(
                      _onlyFavorites ? t.doctors.favouriteDoctors : t.doctors.findDoctors,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => FocusScope.of(context).unfocus(),
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: t.common.search,
                      hintStyle: const TextStyle(color: AppColors.textPlaceholder, fontSize: 14),
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textPlaceholder, size: 22),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textPlaceholder),
                              onPressed: () {
                                _searchController.clear();
                                FocusScope.of(context).unfocus();
                                setState(() {});
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 8),

            SizedBox(
              height: 38,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _specialties.length,
                itemBuilder: (context, index) {
                  final spec = _specialties[index];
                  final isSelected = _selectedSpecialty == spec;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(spec),
                      selected: isSelected,
                      onSelected: (val) {
                        setState(() {
                          _selectedSpecialty = spec;
                        });
                      },
                      backgroundColor: AppColors.white,
                      selectedColor: AppColors.primary,
                      checkmarkColor: AppColors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.white : AppColors.textMain,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? AppColors.primary : AppColors.textBorders,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : doctors.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 50,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                t.doctors.noDoctorsFound,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textMain,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _onlyFavorites
                                    ? t.doctors.noFavoritesSaved
                                    : t.doctors.adjustSearchFilters,
                                style: const TextStyle(fontSize: 13, color: AppColors.textSub),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
                          itemCount: doctors.length,
                          itemBuilder: (context, index) {
                            final doc = doctors[index];
                            final isFav = repo.isFavorite(doc.id);

                            return _FigmaDoctorCard(
                              doctor: doc,
                              index: index,
                              isFavorite: isFav,
                              onToggleFavorite: () {
                                setState(() {
                                  repo.toggleFavorite(doc.id);
                                });
                              },
                              onTap: () {
                                context.push(
                                  '/doctor-details?name=${Uri.encodeComponent(doc.name)}&specialty=${Uri.encodeComponent(doc.specialty)}',
                                );
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    ),
  );
}
}

class _FigmaDoctorCard extends StatelessWidget {
  final AdminDoctorModel doctor;
  final int index;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onTap;

  const _FigmaDoctorCard({
    required this.doctor,
    this.index = 0,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                DoctorImageHelper.getDoctorPhoto(doctor.name, index),
                width: 82,
                height: 82,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    doctor.specialty,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSub,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Row(
                        children: List.generate(
                          5,
                          (i) => const Icon(
                            Icons.star_rounded,
                            color: AppColors.ratingStar,
                            size: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          '${doctor.rating} (${doctor.reviewsCount} views)',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textMain,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            GestureDetector(
              onTap: onToggleFavorite,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: isFavorite ? AppColors.danger : AppColors.textPlaceholder,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
