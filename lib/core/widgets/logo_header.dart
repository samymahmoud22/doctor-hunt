import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../themes/app_colors.dart';

class LogoHeader extends StatelessWidget {
  final double size;
  final bool showText;
  final String titleFirst;
  final String titleSecond;

  const LogoHeader({
    super.key,
    this.size = 64,
    this.showText = true,
    this.titleFirst = 'Doctor ',
    this.titleSecond = 'Hunt',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/images/Frame.svg',
          width: size,
          height: size,
        ),
        if (showText) ...[
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: titleFirst,
                  style: const TextStyle(
                    color: AppColors.textMain,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: titleSecond,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
