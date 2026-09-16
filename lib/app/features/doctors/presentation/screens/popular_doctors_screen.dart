import 'package:flutter/material.dart';
import 'package:doctor_hunt/app/core/themes/app_colors.dart';
import 'package:doctor_hunt/generated/image_assets.dart';
import 'doctor_details_screen.dart';

class PopularDoctorsScreen extends StatefulWidget {
  const PopularDoctorsScreen({super.key});

  @override
  State<PopularDoctorsScreen> createState() => _PopularDoctorsScreenState();
}

class _PopularDoctorsScreenState extends State<PopularDoctorsScreen> {
  final List<Map<String, dynamic>> _popularDoctors = [
    {
      'name': 'Dr. Truluck Nik',
      'specialty': 'Medicine Specialist',
      'rating': 5.0,
      'imageAsset': ImageAssets.onboarding1Jpg,
    },
    {
      'name': 'Dr. Tranquili',
      'specialty': 'Pathology Specialist',
      'rating': 5.0,
      'imageAsset': ImageAssets.onboarding2Jpg,
    },
    {
      'name': 'Dr. Truluck Nik',
      'specialty': 'Medicine Specialist',
      'rating': 5.0,
      'imageAsset': ImageAssets.onboarding3Jpg,
    },
  ];

  final List<Map<String, dynamic>> _categoryDoctors = [
    {
      'name': 'Dr. Pediatrician',
      'specialty': 'Specialist Cardiologist',
      'rating': 4.0,
      'views': '2.4 (2475 views)',
      'imageAsset': ImageAssets.onboarding1Jpg,
      'isFavorite': true,
    },
    {
      'name': 'Dr. Mistry Brick',
      'specialty': 'Specialist Dentist',
      'rating': 4.0,
      'views': '2.8 (2893 views)',
      'imageAsset': ImageAssets.onboarding2Jpg,
      'isFavorite': false,
    },
    {
      'name': 'Dr. Ether Wall',
      'specialty': 'Specialist Cancer',
      'rating': 4.0,
      'views': '2.7 (2754 views)',
      'imageAsset': ImageAssets.onboarding3Jpg,
      'isFavorite': true,
    },
    {
      'name': 'Dr. Johan smith',
      'specialty': 'Specialist cardiologist',
      'rating': 4.0,
      'views': '3.1 (1892 views)',
      'imageAsset': ImageAssets.onboarding1Jpg,
      'isFavorite': false,
    },
  ];

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
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
                        'Popular Doctor',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMain,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {},
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
                      child: const Icon(Icons.search_rounded, size: 20, color: AppColors.textMain),
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
                    // Section 1: Popular Doctor Horizontal List
                    const Text(
                      'Popular Doctor',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _popularDoctors.length,
                        itemBuilder: (context, index) {
                          final doc = _popularDoctors[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => DoctorDetailsScreen(
                                    name: doc['name'],
                                    specialty: doc['specialty'],
                                    imageAsset: doc['imageAsset'],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 154,
                              margin: const EdgeInsets.only(right: 14),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      doc['imageAsset'],
                                      width: double.infinity,
                                      height: 110,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    doc['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: AppColors.textMain,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    doc['specialty'],
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textSub,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      5,
                                      (i) => const Icon(Icons.star_rounded, color: Colors.amber, size: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Section 2: Category Vertical List
                    const Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _categoryDoctors.length,
                      itemBuilder: (context, index) {
                        final doc = _categoryDoctors[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => DoctorDetailsScreen(
                                  name: doc['name'],
                                  specialty: doc['specialty'],
                                  imageAsset: doc['imageAsset'],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    doc['imageAsset'],
                                    width: 72,
                                    height: 72,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              doc['name'],
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textMain,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _categoryDoctors[index]['isFavorite'] = !_categoryDoctors[index]['isFavorite'];
                                              });
                                            },
                                            child: Icon(
                                              doc['isFavorite'] ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                              color: doc['isFavorite'] ? Colors.red : AppColors.textSub,
                                              size: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        doc['specialty'],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSub,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Row(
                                            children: List.generate(
                                              4,
                                              (i) => const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            doc['views'],
                                            style: const TextStyle(
                                              fontSize: 11,
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
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
