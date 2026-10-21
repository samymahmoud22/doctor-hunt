import 'package:flutter/material.dart';
import '../../generated/image_assets.dart';

class DoctorImageHelper {
  DoctorImageHelper._();

  static const List<String> allDoctorPhotos = [
    ImageAssets.doctorPopularFemale,
    ImageAssets.doctorMaleCoat,
    ImageAssets.doctorMaleScrubs,
    ImageAssets.doctorCard1,
    ImageAssets.doctorCard2,
    ImageAssets.doctorCard3,
    ImageAssets.doctorCard4,
    ImageAssets.doctorFeature1,
    ImageAssets.doctorFeature3,
    ImageAssets.doctorFeature4,
  ];

  static String getDoctorPhoto(String name, [int index = 0]) {
    final lower = name.toLowerCase();
    if (lower.contains('fillerup') || lower.contains('grab')) {
      return ImageAssets.doctorPopularFemale;
    }
    if (lower.contains('crick')) {
      return ImageAssets.doctorFeature1;
    }
    if (lower.contains('strain')) {
      return ImageAssets.doctorFeature3;
    }
    if (lower.contains('lachinet')) {
      return ImageAssets.doctorFeature4;
    }
    if (lower.contains('blessing')) {
      return ImageAssets.doctorMaleCoat;
    }
    if (lower.contains('kedia') || lower.contains('shruti')) {
      return ImageAssets.doctorCard1;
    }
    if (lower.contains('shah') || lower.contains('ananya')) {
      return ImageAssets.doctorCard2;
    }
    if (lower.contains('tranquilli') || lower.contains('sarah')) {
      return ImageAssets.doctorCard3;
    }
    if (lower.contains('whitesell') || lower.contains('luke')) {
      return ImageAssets.doctorMaleScrubs;
    }
    if (lower.contains('shoemaker') || lower.contains('emily')) {
      return ImageAssets.doctorCard4;
    }

    return allDoctorPhotos[index.abs() % allDoctorPhotos.length];
  }

  static Widget buildDoctorAvatar({
    required String doctorName,
    String? imageUrl,
    double radius = 28,
    BoxFit fit = BoxFit.cover,
  }) {
    final size = radius * 2;
    final fallbackAsset = getDoctorPhoto(doctorName);

    Widget imageWidget;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
        imageWidget = Image.network(
          imageUrl,
          width: size,
          height: size,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            fallbackAsset,
            width: size,
            height: size,
            fit: fit,
          ),
        );
      } else {
        imageWidget = Image.asset(
          imageUrl,
          width: size,
          height: size,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            fallbackAsset,
            width: size,
            height: size,
            fit: fit,
          ),
        );
      }
    } else {
      imageWidget = Image.asset(
        fallbackAsset,
        width: size,
        height: size,
        fit: fit,
      );
    }

    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: imageWidget,
      ),
    );
  }
}
