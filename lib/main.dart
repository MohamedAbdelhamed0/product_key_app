import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_key_app/product_key/data/repositories/product_key_repository_impl.dart';
import 'package:product_key_app/product_key/domain/use_cases/AssignProductKey.dart';
import 'package:product_key_app/product_key/domain/use_cases/validate_product_key.dart';
import 'package:product_key_app/product_key/presentation/manager/product_key_cubit.dart';
import 'package:product_key_app/product_key/presentation/pages/CacheHelper.dart';
import 'package:product_key_app/product_key/presentation/pages/HomePage.dart';
import 'package:product_key_app/product_key/presentation/pages/SplashScreen.dart';
import 'package:product_key_app/product_key/presentation/pages/admin_page.dart';
import 'package:product_key_app/product_key/presentation/pages/login_page.dart';

import 'firebase_options.dart'; // Import the generated file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await CacheHelper.init();

  final firestore = FirebaseFirestore.instance;
  final repository = ProductKeyRepositoryImpl(firestore);

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final ProductKeyRepositoryImpl repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Key App',
      routes: {
        '/': (context) => SplashScreen(repository: repository),
        '/login': (context) => BlocProvider(
              create: (context) => ProductKeyCubit(
                validateProductKey: ValidateProductKey(repository),
                assignProductKey: AssignProductKey(repository),
              ),
              child: LoginPage(),
            ),
        '/home': (context) => HomePage(),
        '/admin': (context) => AdminPage(),
      },
      initialRoute: '/',
    );
  }
}
