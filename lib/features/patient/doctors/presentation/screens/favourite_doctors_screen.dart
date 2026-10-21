import 'package:flutter/material.dart';
import 'find_doctors_screen.dart';

class FavouriteDoctorsScreen extends StatelessWidget {
  const FavouriteDoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FindDoctorsScreen(
      showBackButton: true,
      initialFavoritesOnly: true,
    );
  }
}
