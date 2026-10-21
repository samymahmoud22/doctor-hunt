import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doctor_hunt/core/di/service_locator.dart';
import 'package:doctor_hunt/core/themes/app_colors.dart';
import 'package:doctor_hunt/features/admin/data/models/admin_doctor_model.dart';
import 'package:doctor_hunt/features/admin/data/repo/admin_repository.dart';
import 'package:doctor_hunt/core/utils/doctor_image_helper.dart';
import 'package:doctor_hunt/generated/image_assets.dart';
import 'package:doctor_hunt/generated/i18n/strings.g.dart';

class PatientHomeScreen extends StatefulWidget {
  final VoidCallback? onOpenDrawer;

  const PatientHomeScreen({super.key, this.onOpenDrawer});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  List<AdminDoctorModel> _allDoctors = [];
  bool _isLoading = true;
  final String _selectedSpecialty = 'All';

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  Future<void> _loadDoctors() async {
    final list = await sl<AdminRepository>().getDoctors();
    setState(() {
      _allDoctors = list.where((d) => d.isActive).toList();
      _isLoading = false;
    });
  }

  List<AdminDoctorModel> get _popularDoctors {
    final list = List<AdminDoctorModel>.from(_allDoctors);
    list.sort((a, b) => b.reviewsCount.compareTo(a.reviewsCount));
    if (_selectedSpecialty != 'All') {
      return list.where((d) => d.specialty.toLowerCase().contains(_selectedSpecialty.toLowerCase())).toList();
    }
    return list;
  }

  List<AdminDoctorModel> get _topRatedDoctors {
    final list = List<AdminDoctorModel>.from(_allDoctors);
    list.sort((a, b) => b.rating.compareTo(a.rating));
    if (_selectedSpecialty != 'All') {
      return list.where((d) => d.specialty.toLowerCase().contains(_selectedSpecialty.toLowerCase())).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final repo = sl<AdminRepository>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 52, bottom: 48),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.home.greeting,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                t.home.findDoctor,
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: widget.onOpenDrawer ?? () => context.push('/menu'),
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.white, width: 2),
                                image: const DecorationImage(
                                  image: AssetImage(ImageAssets.userAvatar),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),

                Positioned(
                  left: 20,
                  right: 20,
                  bottom: -22,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: TextField(
                      readOnly: true,
                      onTap: () {
                        context.push('/find-doctors');
                      },
                      decoration: InputDecoration(
                        hintText: t.common.search,
                        hintStyle: const TextStyle(color: AppColors.textPlaceholder, fontSize: 14),
                        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textPlaceholder, size: 22),
                        suffixIcon: const Icon(Icons.close_rounded, color: AppColors.textPlaceholder, size: 20),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 38),

            // Live Doctors section matching Figma
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.home.liveDoctors,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.push('/find-doctors');
                    },
                    child: Text(
                      '${t.common.seeAll} >',
                      style: const TextStyle(
                        color: AppColors.textSub,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 168,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _LiveDoctorCard(
                    image: ImageAssets.doctorLiveFemale,
                    onTap: () => context.push('/find-doctors'),
                  ),
                  _LiveDoctorCard(
                    image: ImageAssets.doctorMaleScrubs,
                    onTap: () => context.push('/find-doctors'),
                  ),
                  _LiveDoctorCard(
                    image: ImageAssets.doctorPopularFemale,
                    onTap: () => context.push('/find-doctors'),
                  ),
                  _LiveDoctorCard(
                    image: ImageAssets.doctorMaleCoat,
                    onTap: () => context.push('/find-doctors'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SpecialtySquare(
                    color: const Color(0xFF4C6FFF),
                    iconWidget: const CustomPaint(
                      size: Size(26, 26),
                      painter: _ToothPainter(),
                    ),
                    onTap: () {
                      context.push('/find-doctors?specialty=Dentist');
                    },
                  ),
                  _SpecialtySquare(
                    color: AppColors.primary,
                    iconWidget: const Icon(Icons.monitor_heart_rounded, color: AppColors.white, size: 28),
                    onTap: () {
                      context.push('/find-doctors?specialty=Cardiologist');
                    },
                  ),
                  _SpecialtySquare(
                    color: const Color(0xFFFF9E44),
                    iconWidget: const Icon(Icons.visibility_rounded, color: AppColors.white, size: 28),
                    onTap: () {
                      context.push('/find-doctors?specialty=Eye');
                    },
                  ),
                  _SpecialtySquare(
                    color: const Color(0xFFFF6E6E),
                    iconWidget: const Icon(Icons.accessibility_new_rounded, color: AppColors.white, size: 28),
                    onTap: () {
                      context.push('/find-doctors?specialty=Orthopedic');
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.home.popularDoctors,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.push('/popular-doctors');
                    },
                    child: Text(
                      '${t.common.seeAll} >',
                      style: const TextStyle(
                        color: AppColors.textSub,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _isLoading
                ? const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator(color: AppColors.primary)))
                : SizedBox(
                    height: 236,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _popularDoctors.length,
                      itemBuilder: (context, index) {
                        final doc = _popularDoctors[index];
                        return _FigmaPopularDoctorCard(
                          doctor: doc,
                          index: index,
                          onTap: () {
                            context.push(
                              '/doctor-details?name=${Uri.encodeComponent(doc.name)}&specialty=${Uri.encodeComponent(doc.specialty)}',
                            );
                          },
                        );
                      },
                    ),
                  ),

            const SizedBox(height: 28),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.home.featureDoctors,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.push('/find-doctors');
                    },
                    child: Text(
                      '${t.common.seeAll} >',
                      style: const TextStyle(
                        color: AppColors.textSub,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _isLoading
                ? const SizedBox.shrink()
                : SizedBox(
                    height: 168,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _topRatedDoctors.length,
                      itemBuilder: (context, index) {
                        final doc = _topRatedDoctors[index];
                        final isFav = repo.isFavorite(doc.id);

                        return _FigmaTopRatedDoctorCard(
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

            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}

class _SpecialtySquare extends StatelessWidget {
  final Color color;
  final Widget iconWidget;
  final VoidCallback onTap;

  const _SpecialtySquare({
    required this.color,
    required this.iconWidget,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 68,
        height: 68,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(child: iconWidget),
      ),
    );
  }
}

String _getDoctorPhoto(String name, int index) {
  return DoctorImageHelper.getDoctorPhoto(name, index);
}

class _FigmaPopularDoctorCard extends StatelessWidget {
  final AdminDoctorModel doctor;
  final int index;
  final VoidCallback onTap;

  const _FigmaPopularDoctorCard({
    required this.doctor,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 172,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                _getDoctorPhoto(doctor.name, index),
                width: 172,
                height: 148,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                doctor.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 2),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                doctor.specialty,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSub,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 6),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (i) => const Icon(
                  Icons.star_rounded,
                  color: AppColors.ratingStar,
                  size: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FigmaTopRatedDoctorCard extends StatelessWidget {
  final AdminDoctorModel doctor;
  final int index;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onTap;

  const _FigmaTopRatedDoctorCard({
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
        width: 128,
        margin: const EdgeInsets.only(right: 14),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: onToggleFavorite,
                  child: Icon(
                    isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: isFavorite ? AppColors.danger : AppColors.textPlaceholder,
                    size: 16,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: AppColors.ratingStar, size: 14),
                    const SizedBox(width: 2),
                    Text(
                      '${doctor.rating}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(_getDoctorPhoto(doctor.name, index)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),

            Text(
              doctor.name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              '\$${doctor.consultationFee.toInt().toStringAsFixed(2)}/hours',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF677294),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ToothPainter extends CustomPainter {
  const _ToothPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    final w = size.width;
    final h = size.height;

    path.moveTo(w * 0.22, h * 0.15);
    path.cubicTo(w * 0.38, h * 0.04, w * 0.62, h * 0.04, w * 0.78, h * 0.15);
    path.cubicTo(w * 0.98, h * 0.28, w * 0.94, h * 0.55, w * 0.82, h * 0.92);
    path.cubicTo(w * 0.72, h * 0.96, w * 0.62, h * 0.68, w * 0.5, h * 0.66);
    path.cubicTo(w * 0.38, h * 0.68, w * 0.28, h * 0.96, w * 0.18, h * 0.92);
    path.cubicTo(w * 0.06, h * 0.55, w * 0.02, h * 0.28, w * 0.22, h * 0.15);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LiveDoctorCard extends StatelessWidget {
  final String image;
  final VoidCallback onTap;

  const _LiveDoctorCard({
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 116,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                image,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.25),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.35),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF3B30),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.circle, color: Colors.white, size: 6),
                      SizedBox(width: 3),
                      Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.85),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Color(0xFF00D09E),
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
