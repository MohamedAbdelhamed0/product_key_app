import 'package:flutter/material.dart';
import 'package:product_key_app/product_key/data/repositories/product_key_repository_impl.dart';

import 'CacheHelper.dart';

class SplashScreen extends StatelessWidget {
  final ProductKeyRepositoryImpl repository;

  const SplashScreen({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    // Check authentication status
    bool isAuthValid = CacheHelper.isAuthValid();

    // Navigate to the appropriate screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isAuthValid) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });

    // Display a splash screen or loading indicator
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
