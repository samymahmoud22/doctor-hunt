import 'package:flutter/material.dart';
import 'package:doctor_hunt/app/core/themes/app_colors.dart';
import 'package:doctor_hunt/generated/image_assets.dart';
import 'select_time_screen.dart';

class DoctorModel {
  final String name;
  final String specialty;
  final int experienceYears;
  final int ratingPercent;
  final int patientStories;
  final String nextAvailable;
  final String imageAsset;
  final bool isFavorite;

  const DoctorModel({
    required this.name,
    required this.specialty,
    required this.experienceYears,
    required this.ratingPercent,
    required this.patientStories,
    required this.nextAvailable,
    required this.imageAsset,
    this.isFavorite = false,
  });
}

class FindDoctorsScreen extends StatefulWidget {
  final String? initialQuery;

  const FindDoctorsScreen({super.key, this.initialQuery});

  @override
  State<FindDoctorsScreen> createState() => _FindDoctorsScreenState();
}

class _FindDoctorsScreenState extends State<FindDoctorsScreen> {
  late TextEditingController _searchController;
  late List<DoctorModel> _doctors;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? 'Dentist');
    _doctors = [
      const DoctorModel(
        name: 'Dr. Shruti Kedia',
        specialty: 'Tooths Dentist',
        experienceYears: 7,
        ratingPercent: 87,
        patientStories: 69,
        nextAvailable: '10:00 AM tomorrow',
        imageAsset: ImageAssets.onboarding1Jpg,
        isFavorite: true,
      ),
      const DoctorModel(
        name: 'Dr. Watamaniuk',
        specialty: 'Tooths Dentist',
        experienceYears: 9,
        ratingPercent: 74,
        patientStories: 78,
        nextAvailable: '12:00 AM tomorrow',
        imageAsset: ImageAssets.onboarding2Jpg,
        isFavorite: false,
      ),
      const DoctorModel(
        name: 'Dr. Crownover',
        specialty: 'Tooths Dentist',
        experienceYears: 5,
        ratingPercent: 59,
        patientStories: 86,
        nextAvailable: '11:00 AM tomorrow',
        imageAsset: ImageAssets.onboarding3Jpg,
        isFavorite: true,
      ),
      const DoctorModel(
        name: 'Dr. Balestra',
        specialty: 'Tooths Dentist',
        experienceYears: 6,
        ratingPercent: 87,
        patientStories: 42,
        nextAvailable: '02:00 PM tomorrow',
        imageAsset: ImageAssets.onboarding1Jpg,
        isFavorite: false,
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleFavorite(int index) {
    setState(() {
      final doc = _doctors[index];
      _doctors[index] = DoctorModel(
        name: doc.name,
        specialty: doc.specialty,
        experienceYears: doc.experienceYears,
        ratingPercent: doc.ratingPercent,
        patientStories: doc.patientStories,
        nextAvailable: doc.nextAvailable,
        imageAsset: doc.imageAsset,
        isFavorite: !doc.isFavorite,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF9),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textMain),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Find Doctors',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: AppColors.textSub),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded, size: 20, color: AppColors.textSub),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    hintText: 'Search doctor...',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // List of Doctors
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _doctors.length,
                itemBuilder: (context, index) {
                  final doc = _doctors[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Doctor Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                doc.imageAsset,
                                width: 84,
                                height: 84,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => Container(
                                  width: 84,
                                  height: 84,
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  child: const Icon(Icons.person, color: AppColors.primary, size: 40),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),

                            // Doctor Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          doc.name,
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textMain,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => _toggleFavorite(index),
                                        child: Icon(
                                          doc.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                          color: doc.isFavorite ? Colors.red : AppColors.textSub,
                                          size: 22,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    doc.specialty,
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${doc.experienceYears} Years experience',
                                    style: const TextStyle(
                                      color: AppColors.textSub,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  // Rating & Patient Stories
                                  Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: AppColors.primary,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${doc.ratingPercent}%',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSub,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: AppColors.primary,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${doc.patientStories} Patient Stories',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSub,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 1, color: Color(0xFFF0F0F0)),
                        const SizedBox(height: 10),

                        // Next Available & Book Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Next Available',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  doc.nextAvailable,
                                  style: const TextStyle(
                                    color: AppColors.textSub,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => SelectTimeScreen(doctorName: doc.name),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              ),
                              child: const Text(
                                'Book Now',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
