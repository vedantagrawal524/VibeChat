import 'package:flutter/material.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({
    super.key,
    required this.verificationId,
  });
  final String verificationId;
  static const routeName = '/otp-screen';

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
