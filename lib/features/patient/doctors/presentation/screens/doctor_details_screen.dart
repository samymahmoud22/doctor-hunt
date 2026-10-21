import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doctor_hunt/core/di/service_locator.dart';
import 'package:doctor_hunt/core/themes/app_colors.dart';
import 'package:doctor_hunt/core/widgets/custom_button.dart';
import 'package:doctor_hunt/features/admin/data/models/admin_doctor_model.dart';
import 'package:doctor_hunt/features/admin/data/repo/admin_repository.dart';
import 'package:doctor_hunt/features/patient/doctors/data/models/doctor_review_model.dart';
import 'package:doctor_hunt/core/utils/doctor_image_helper.dart';
import 'package:doctor_hunt/generated/i18n/strings.g.dart';
import 'package:doctor_hunt/generated/image_assets.dart';

class DoctorDetailsScreen extends StatefulWidget {
  final String name;
  final String specialty;

  const DoctorDetailsScreen({
    super.key,
    this.name = 'Dr. Ahmed Ali',
    this.specialty = 'Specialist Cardiologist',
  });

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  AdminDoctorModel? _doctor;
  List<DoctorReviewModel> _reviews = [];
  bool _isLoading = true;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final repo = sl<AdminRepository>();
    final doctors = await repo.getDoctors();
    final match = doctors.firstWhere(
      (d) => d.name.toLowerCase() == widget.name.toLowerCase() ||
             d.specialty.toLowerCase().contains(widget.specialty.toLowerCase()),
      orElse: () => doctors.first,
    );

    final reviews = await repo.getDoctorReviews(match.id);

    setState(() {
      _doctor = match;
      _reviews = reviews;
      _isFavorite = repo.isFavorite(match.id);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final repo = sl<AdminRepository>();

    if (_isLoading || _doctor == null) {
      return const Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    final doc = _doctor!;
    final centralLocation = repo.centralLocation;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF3FAF7), Colors.white, Color(0xFFE8F7F3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () => context.pop(),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 38,
                            height: 38,
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
                            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Color(0xFF333333)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          t.doctors.doctorDetails,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () => context.push('/find-doctors'),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 38,
                        height: 38,
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
                          Icons.search_rounded,
                          size: 20,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.asset(
                                    DoctorImageHelper.getDoctorPhoto(doc.name),
                                    width: 84,
                                    height: 84,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        doc.name,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF333333),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        doc.specialty,
                                        style: const TextStyle(
                                          color: Color(0xFF677294),
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 8),

                                      Row(
                                        children: List.generate(5, (index) {
                                          final isFilled = index < (doc.rating.round().clamp(1, 5));
                                          return Icon(
                                            Icons.star_rounded,
                                            size: 16,
                                            color: isFilled ? const Color(0xFFF6D060) : const Color(0xFFE5E7EB),
                                          );
                                        }),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Text(
                                            '\$ ${doc.consultationFee.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const Text(
                                            '/hr',
                                            style: TextStyle(
                                              color: Color(0xFF677294),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      repo.toggleFavorite(doc.id);
                                      _isFavorite = repo.isFavorite(doc.id);
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    child: Icon(
                                      _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                      size: 22,
                                      color: const Color(0xFFFF4D4F),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            CustomButton(
                              text: t.common.bookNow,
                              height: 44,
                              onPressed: () {
                                context.push('/select-time?doctorName=${Uri.encodeComponent(doc.name)}');
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        'Services',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildServiceItem('1.', 'Patient care should be the number one priority.'),
                      const SizedBox(height: 10),
                      _buildServiceItem('2.', 'If you run your practice you know how frustrating.'),
                      const SizedBox(height: 10),
                      _buildServiceItem('3.', 'That\'s why some of appointment reminder system.'),
                      const SizedBox(height: 22),

                      _buildMapPreview(centralLocation),
                      const SizedBox(height: 24),
                    const SizedBox(height: 20),

                    const Text(
                      'Working Days & Hours',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.primary),
                              const SizedBox(width: 8),
                              const Text('Working Days: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              Expanded(
                                child: Text(
                                  doc.workingDays.entries
                                      .where((e) => e.value)
                                      .map((e) => e.key.substring(0, 3))
                                      .join(', '),
                                  style: const TextStyle(color: AppColors.textSub, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 16),
                          Row(
                            children: [
                              const Icon(Icons.access_time_rounded, size: 16, color: AppColors.primary),
                              const SizedBox(width: 8),
                              const Text('Hours: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              Text(
                                '${doc.startTime} - ${doc.endTime} (${doc.slotDuration} slots)',
                                style: const TextStyle(color: AppColors.textSub, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent Reviews',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMain,
                          ),
                        ),
                        Text(
                          '${_reviews.length} Comments',
                          style: const TextStyle(color: AppColors.textSub, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_reviews.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Text(
                            'No patient reviews written yet.',
                            style: TextStyle(color: AppColors.textSub, fontSize: 13),
                          ),
                        ),
                      )
                    else
                      for (final rev in _reviews)
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        radius: 12,
                                        backgroundColor: AppColors.primaryLight,
                                        child: Icon(Icons.person, size: 14, color: AppColors.primary),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Verified Patient',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.star_rounded, color: Color(0xFFF6D060), size: 16),
                                      const SizedBox(width: 3),
                                      Text(
                                        '${rev.rating}',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              if (rev.comment != null && rev.comment!.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text(
                                  rev.comment!,
                                  style: const TextStyle(fontSize: 13, color: Color(0xFF555555), height: 1.3),
                                ),
                              ],
                            ],
                          ),
                        ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildServiceItem(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF677294),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapPreview(String location) {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE8ECE9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _MapPainter(),
              ),
            ),

            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      location.split('•').first.trim(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Icon(
                    Icons.location_on_rounded,
                    color: Color(0xFFFF4D4F),
                    size: 32,
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

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFEBF1ED);
    canvas.drawRect(Offset.zero & size, bgPaint);

    final parkPaint = Paint()..color = const Color(0xFFD4E7D7);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(16, 16, size.width * 0.35, size.height * 0.4),
        const Radius.circular(8),
      ),
      parkPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.65, size.height * 0.5, size.width * 0.3, size.height * 0.4),
        const Radius.circular(8),
      ),
      parkPaint,
    );

    final waterPaint = Paint()
      ..color = const Color(0xFFCCE4F5)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke;
    final riverPath = Path()
      ..moveTo(0, size.height * 0.85)
      ..quadraticBezierTo(
        size.width * 0.4,
        size.height * 0.65,
        size.width,
        size.height * 0.9,
      );
    canvas.drawPath(riverPath, waterPaint);

    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    final roadBorderPaint = Paint()
      ..color = const Color(0xFFD8DCDA)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    final road1 = Path()
      ..moveTo(0, size.height * 0.45)
      ..lineTo(size.width, size.height * 0.35);
    canvas.drawPath(road1, roadBorderPaint);
    canvas.drawPath(road1, roadPaint);

    final road2 = Path()
      ..moveTo(size.width * 0.48, 0)
      ..lineTo(size.width * 0.52, size.height);
    canvas.drawPath(road2, roadBorderPaint);
    canvas.drawPath(road2, roadPaint);

    final secRoadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final road3 = Path()
      ..moveTo(0, size.height * 0.2)
      ..lineTo(size.width * 0.5, size.height * 0.25);
    canvas.drawPath(road3, secRoadPaint);

    final road4 = Path()
      ..moveTo(size.width * 0.25, size.height * 0.45)
      ..lineTo(size.width * 0.25, size.height);
    canvas.drawPath(road4, secRoadPaint);

    final road5 = Path()
      ..moveTo(size.width * 0.5, size.height * 0.7)
      ..lineTo(size.width, size.height * 0.6);
    canvas.drawPath(road5, secRoadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
