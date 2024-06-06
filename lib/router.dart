import 'package:flutter/material.dart';
import 'package:whatsapp/common/widgets/error_screen.dart';
import 'package:whatsapp/features/auth/screens/login_screen.dart';
import 'package:whatsapp/features/auth/screens/otp_screen.dart';

Route<dynamic> generateRoute(RouteSettings setttings) {
  switch (setttings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case OTPScreen.routeName:
      final verificationId = setttings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPScreen(
          verificationId: verificationId,
        ),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: 'This page doesn\'t exist!'),
        ),
      );
  }
}
