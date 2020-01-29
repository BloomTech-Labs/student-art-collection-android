import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppBarLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/artco_logo_large.svg',
      color: Colors.white,
      semanticsLabel: 'App Logo',
      fit: BoxFit.contain,
    );
  }
}
