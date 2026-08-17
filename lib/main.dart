import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/constants/app_theme.dart';
import 'features/lsa_verification/bindings/lsa_verification_binding.dart';
import 'features/lsa_verification/views/lsa_profile_verification_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const LsaVerificationApp());
}

class LsaVerificationApp extends StatelessWidget {
  const LsaVerificationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'LSA Profile Verification',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialBinding: LsaVerificationBinding(),
      home: const LsaProfileVerificationScreen(),
    );
  }
}
