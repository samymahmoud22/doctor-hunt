import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doctor_hunt/core/di/service_locator.dart';
import 'package:doctor_hunt/core/themes/app_colors.dart';
import 'package:doctor_hunt/features/admin/data/models/admin_doctor_model.dart';
import 'package:doctor_hunt/features/admin/data/repo/admin_repository.dart';
import 'package:doctor_hunt/core/utils/doctor_image_helper.dart';
import 'package:doctor_hunt/generated/image_assets.dart';

class PopularDoctorsScreen extends StatefulWidget {
  const PopularDoctorsScreen({super.key});

  @override
  State<PopularDoctorsScreen> createState() => _PopularDoctorsScreenState();
}

String _getDoctorPhoto(String name, int index) {
  return DoctorImageHelper.getDoctorPhoto(name, index);
}

class _PopularDoctorsScreenState extends State<PopularDoctorsScreen> {
  List<AdminDoctorModel> _popularDoctors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPopularDoctors();
  }

  Future<void> _loadPopularDoctors() async {
    final list = await sl<AdminRepository>().getDoctors();
    final active = list.where((d) => d.isActive).toList();
    active.sort((a, b) => b.reviewsCount.compareTo(a.reviewsCount));

    setState(() {
      _popularDoctors = active;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final repo = sl<AdminRepository>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE8F6FD),
              Color(0xFFF7FCFA),
              Color(0xFFE8F9F3),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => context.pop(),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                          color: Color(0xFF333333),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Text(
                      'Popular Doctors',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
                        itemCount: _popularDoctors.length,
                        itemBuilder: (context, index) {
                          final doc = _popularDoctors[index];
                          final isFav = repo.isFavorite(doc.id);

                          return _FigmaDoctorListCard(
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

class _FigmaDoctorListCard extends StatelessWidget {
  final AdminDoctorModel doctor;
  final int index;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onTap;

  const _FigmaDoctorListCard({
    required this.doctor,
    required this.index,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
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
                _getDoctorPhoto(doctor.name, index),
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          doctor.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: onToggleFavorite,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Icon(
                            isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            color: isFavorite ? const Color(0xFFFF3B30) : const Color(0xFFC4C4C4),
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),

                  Text(
                    doctor.specialty,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF677294),
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
                          (i) => Icon(
                            Icons.star_rounded,
                            color: i < 4 ? const Color(0xFFF6D060) : const Color(0xFFE5E7EB),
                            size: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${doctor.rating}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '(${doctor.reviewsCount} views)',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF677294),
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
          ],
        ),
      ),
    );
  }
}
