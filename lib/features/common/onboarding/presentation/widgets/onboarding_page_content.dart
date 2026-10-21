import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:doctor_hunt/core/themes/app_colors.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class OnboardingPageContent extends StatelessWidget {
  final String title;
  final String description;
  final String? imageAsset;
  final IconData? iconData;
  final Alignment arcAlignment;

  const OnboardingPageContent({
    super.key,
    required this.title,
    required this.description,
    this.imageAsset,
    this.iconData,
    this.arcAlignment = Alignment.topLeft,
  });

  Widget _buildImage(double circleRadius) {
    if (imageAsset == null) {
      return Icon(
        iconData ?? Icons.medical_services_outlined,
        size: circleRadius * 0.4,
        color: AppColors.primary,
      );
    }

    if (imageAsset!.endsWith('.svg')) {
      return SvgPicture.asset(
        imageAsset!,
        width: circleRadius * 0.9,
        height: circleRadius * 0.9,
        fit: BoxFit.contain,
        placeholderBuilder: (_) => Icon(
          iconData ?? Icons.medical_services_outlined,
          size: circleRadius * 0.4,
          color: AppColors.primary,
        ),
      );
    }

    return Image.asset(
      imageAsset!,
      width: circleRadius,
      height: circleRadius,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => Icon(
        iconData ?? Icons.medical_services_outlined,
        size: circleRadius * 0.4,
        color: AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isSmallScreen = size.height < 680;
    final circleRadius = isSmallScreen ? size.width * 0.58 : size.width * 0.68;
    final topHeight = isSmallScreen ? size.height * 0.40 : size.height * 0.44;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(
            height: topHeight,
            width: double.infinity,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -size.width * 0.25,
                  left: arcAlignment == Alignment.topLeft ? -size.width * 0.2 : null,
                  right: arcAlignment == Alignment.topRight ? -size.width * 0.2 : null,
                  child: Container(
                    width: size.width * 0.85,
                    height: size.width * 0.85,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: circleRadius,
                    height: circleRadius,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      border: Border.all(color: AppColors.white, width: 4),
                    ),
                    child: ClipOval(
                      child: Container(
                        color: AppColors.primaryLight,
                        child: Center(
                          child: _buildImage(circleRadius),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: context.bold24TextMain.copyWith(
                fontSize: isSmallScreen ? 20 : 24,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: context.regular14TextSub.copyWith(
                height: 1.45,
                fontSize: isSmallScreen ? 13 : 14,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
