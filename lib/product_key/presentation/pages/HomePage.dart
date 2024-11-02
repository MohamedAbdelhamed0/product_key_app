import 'package:flutter/material.dart';

import 'CacheHelper.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _logout(BuildContext context) {
    CacheHelper.clearAuthData();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    String? userId = CacheHelper.getUserId();
    String? name = CacheHelper.getName();
    String? phone = CacheHelper.getPhone();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, $name!\nYour user ID is $userId\nPhone: $phone'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
