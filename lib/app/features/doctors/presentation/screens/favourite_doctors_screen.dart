import 'package:flutter/material.dart';
import 'package:doctor_hunt/app/core/themes/app_colors.dart';
import 'package:doctor_hunt/generated/image_assets.dart';
import 'doctor_details_screen.dart';

class FavouriteDoctorsScreen extends StatefulWidget {
  const FavouriteDoctorsScreen({super.key});

  @override
  State<FavouriteDoctorsScreen> createState() => _FavouriteDoctorsScreenState();
}

class _FavouriteDoctorsScreenState extends State<FavouriteDoctorsScreen> {
  final TextEditingController _searchController = TextEditingController(text: 'Dentist');

  final List<Map<String, dynamic>> _favDoctors = [
    {
      'name': 'Dr. Shouey',
      'specialty': 'Specialist Cardiology',
      'imageAsset': ImageAssets.onboarding1Jpg,
      'isFavorite': false,
    },
    {
      'name': 'Dr. Christenfeld N',
      'specialty': 'Specialist Cancer',
      'imageAsset': ImageAssets.onboarding2Jpg,
      'isFavorite': true,
    },
    {
      'name': 'Dr. Shouey',
      'specialty': 'Specialist Medicine',
      'imageAsset': ImageAssets.onboarding3Jpg,
      'isFavorite': true,
    },
    {
      'name': 'Dr. Shouey',
      'specialty': 'Specialist Dentist',
      'imageAsset': ImageAssets.onboarding1Jpg,
      'isFavorite': false,
    },
  ];

  final List<Map<String, dynamic>> _featureDoctors = [
    {
      'name': 'Dr. Crick',
      'rating': 3.7,
      'price': '\$25.00/ hours',
      'imageAsset': ImageAssets.onboarding3Jpg,
    },
    {
      'name': 'Dr. Strain',
      'rating': 3.0,
      'price': '\$22.00/ hours',
      'imageAsset': ImageAssets.onboarding2Jpg,
    },
    {
      'name': 'Dr. Lachinet',
      'rating': 2.9,
      'price': '\$24.00/ hours',
      'imageAsset': ImageAssets.onboarding1Jpg,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                    'Favourite Doctors',
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
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20, color: AppColors.textSub),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                    ),
                    hintText: 'Search favourite...',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2x2 Grid of Favorite Doctors
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.82,
                      ),
                      itemCount: _favDoctors.length,
                      itemBuilder: (context, index) {
                        final doc = _favDoctors[index];
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
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
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
                                Align(
                                  alignment: Alignment.topRight,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _favDoctors[index]['isFavorite'] = !_favDoctors[index]['isFavorite'];
                                      });
                                    },
                                    child: Icon(
                                      doc['isFavorite'] ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                      color: doc['isFavorite'] ? Colors.red : AppColors.textSub,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 34,
                                  backgroundImage: AssetImage(doc['imageAsset']),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  doc['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: AppColors.textMain,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  doc['specialty'],
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Feature Doctor Section
                    const Text(
                      'Feature Doctor',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _featureDoctors.length,
                        itemBuilder: (context, index) {
                          final doc = _featureDoctors[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => DoctorDetailsScreen(
                                    name: doc['name'],
                                    imageAsset: doc['imageAsset'],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 110,
                              margin: const EdgeInsets.only(right: 14),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
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
                                      const Icon(Icons.favorite_border_rounded, size: 14, color: AppColors.textSub),
                                      Row(
                                        children: [
                                          const Icon(Icons.star_rounded, color: Colors.amber, size: 12),
                                          const SizedBox(width: 2),
                                          Text(
                                            '${doc['rating']}',
                                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  CircleAvatar(
                                    radius: 26,
                                    backgroundImage: AssetImage(doc['imageAsset']),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    doc['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: AppColors.textMain,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    doc['price'],
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
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
