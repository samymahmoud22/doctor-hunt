import 'package:flutter/material.dart';
import 'package:doctor_hunt/app/core/themes/app_colors.dart';
import 'package:doctor_hunt/generated/image_assets.dart';
import 'package:doctor_hunt/app/features/doctors/presentation/screens/find_doctors_screen.dart';
import 'package:doctor_hunt/app/features/doctors/presentation/screens/doctor_live_chat_screen.dart';
import 'package:doctor_hunt/app/features/doctors/presentation/screens/select_time_screen.dart';
import 'package:doctor_hunt/app/features/doctors/presentation/screens/popular_doctors_screen.dart';
import 'package:doctor_hunt/app/features/doctors/presentation/screens/doctor_details_screen.dart';

class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Top Header Banner with Gradient ---
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 54, bottom: 48),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0EBE7E), Color(0xFF07A86F)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Hi Handwerker!',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Find Your Doctor',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              image: const DecorationImage(
                                image: AssetImage(ImageAssets.onboarding1Jpg),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),

                // Floating Search Bar
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: -24,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const FindDoctorsScreen(),
                          ),
                        );
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(color: AppColors.textSub, fontSize: 14),
                        prefixIcon: Icon(Icons.search_rounded, color: AppColors.textSub),
                        suffixIcon: Icon(Icons.close_rounded, color: AppColors.textSub, size: 20),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // --- 2. Live Doctors Section ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text(
                'Live Doctors',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 170,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _LiveDoctorCard(
                    imageAsset: ImageAssets.onboarding1Jpg,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const DoctorLiveChatScreen(doctorName: 'Dr. Shruti Kedia'),
                        ),
                      );
                    },
                  ),
                  _LiveDoctorCard(
                    imageAsset: ImageAssets.onboarding2Jpg,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const DoctorLiveChatScreen(doctorName: 'Dr. Watamaniuk'),
                        ),
                      );
                    },
                  ),
                  _LiveDoctorCard(
                    imageAsset: ImageAssets.onboarding3Jpg,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const DoctorLiveChatScreen(doctorName: 'Dr. Crownover'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // --- 3. Categories Icons Grid ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CategorySquareCard(
                    icon: Icons.clean_hands_rounded,
                    gradientColors: const [Color(0xFF5B67F7), Color(0xFF6C5CE7)],
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const FindDoctorsScreen(initialQuery: 'Dentist'),
                        ),
                      );
                    },
                  ),
                  _CategorySquareCard(
                    icon: Icons.favorite_rounded,
                    gradientColors: const [Color(0xFF0EBE7E), Color(0xFF07A86F)],
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const FindDoctorsScreen(initialQuery: 'Cardiology'),
                        ),
                      );
                    },
                  ),
                  _CategorySquareCard(
                    icon: Icons.remove_red_eye_rounded,
                    gradientColors: const [Color(0xFFFF9F43), Color(0xFFFECA57)],
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const FindDoctorsScreen(initialQuery: 'Eye Care'),
                        ),
                      );
                    },
                  ),
                  _CategorySquareCard(
                    icon: Icons.accessibility_new_rounded,
                    gradientColors: const [Color(0xFFFF5252), Color(0xFFFF7675)],
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const FindDoctorsScreen(initialQuery: 'Body'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // --- 4. Popular Doctor Section ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Popular Doctor',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const PopularDoctorsScreen(),
                        ),
                      );
                    },
                    child: const Text('See All >', style: TextStyle(color: AppColors.textSub, fontSize: 12)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _PopularDoctorCard(
                    name: 'Dr. Fillerup Grab',
                    specialty: 'Medicine Specialist',
                    imageAsset: ImageAssets.onboarding1Jpg,
                    rating: 4.0,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const DoctorDetailsScreen(
                            name: 'Dr. Fillerup Grab',
                            specialty: 'Medicine Specialist',
                            imageAsset: ImageAssets.onboarding1Jpg,
                          ),
                        ),
                      );
                    },
                  ),
                  _PopularDoctorCard(
                    name: 'Dr. Blessing',
                    specialty: 'Dentist Specialist',
                    imageAsset: ImageAssets.onboarding2Jpg,
                    rating: 4.0,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const DoctorDetailsScreen(
                            name: 'Dr. Blessing',
                            specialty: 'Dentist Specialist',
                            imageAsset: ImageAssets.onboarding2Jpg,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // --- 5. Feature Doctor Section ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Feature Doctor',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const FindDoctorsScreen(),
                        ),
                      );
                    },
                    child: const Text('See All >', style: TextStyle(color: AppColors.textSub, fontSize: 12)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _FeatureDoctorCard(
                    name: 'Dr. Crick',
                    rating: 3.7,
                    pricePerHour: '\$25.00/ hours',
                    imageAsset: ImageAssets.onboarding3Jpg,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SelectTimeScreen(doctorName: 'Dr. Crick'),
                        ),
                      );
                    },
                  ),
                  _FeatureDoctorCard(
                    name: 'Dr. Strain',
                    rating: 3.0,
                    pricePerHour: '\$22.00/ hours',
                    imageAsset: ImageAssets.onboarding2Jpg,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SelectTimeScreen(doctorName: 'Dr. Strain'),
                        ),
                      );
                    },
                  ),
                  _FeatureDoctorCard(
                    name: 'Dr. Lachinet',
                    rating: 2.9,
                    pricePerHour: '\$24.00/ hours',
                    imageAsset: ImageAssets.onboarding1Jpg,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SelectTimeScreen(doctorName: 'Dr. Lachinet'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _LiveDoctorCard extends StatelessWidget {
  final String imageAsset;
  final VoidCallback onTap;

  const _LiveDoctorCard({
    required this.imageAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 124,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  imageAsset,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.15),
                ),
              ),

              // LIVE Tag
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.fiber_manual_record, color: Colors.white, size: 8),
                      SizedBox(width: 3),
                      Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Play Icon
              Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 26,
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

class _CategorySquareCard extends StatelessWidget {
  final IconData icon;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _CategorySquareCard({
    required this.icon,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: gradientColors.first.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 34),
      ),
    );
  }
}

class _PopularDoctorCard extends StatelessWidget {
  final String name;
  final String specialty;
  final String imageAsset;
  final double rating;
  final VoidCallback onTap;

  const _PopularDoctorCard({
    required this.name,
    required this.specialty,
    required this.imageAsset,
    required this.rating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 170,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                imageAsset,
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              name,
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
              specialty,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSub,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => Icon(
                  index < rating.floor() ? Icons.star_rounded : Icons.star_border_rounded,
                  color: Colors.amber,
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

class _FeatureDoctorCard extends StatelessWidget {
  final String name;
  final double rating;
  final String pricePerHour;
  final String imageAsset;
  final VoidCallback onTap;

  const _FeatureDoctorCard({
    required this.name,
    required this.rating,
    required this.pricePerHour,
    required this.imageAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                      '$rating',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            CircleAvatar(
              radius: 26,
              backgroundImage: AssetImage(imageAsset),
            ),
            const SizedBox(height: 6),
            Text(
              name,
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
              pricePerHour,
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
  }
}
