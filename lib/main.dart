import 'package:fatureicurso/data/features/auth/binds/user.dart';
import 'package:fatureicurso/data/features/month_balance/binds/month_balance.dart';
import 'package:fatureicurso/firebase_options.dart';
import 'package:fatureicurso/data/i10/auth.dart';
import 'package:fatureicurso/presenter/pages/auth.dart';
import 'package:fatureicurso/presenter/pages/home/home.dart';
import 'package:fatureicurso/presenter/pages/profile.dart';
import 'package:fatureicurso/presenter/pages/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

bool shouldUseFirebaseEmulator = false;

late final FirebaseApp app;
late final FirebaseAuth auth;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

   await GetStorage.init();
     await initializeDateFormatting('pt_BR', null);


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        FirebaseUILocalizations.withDefaultOverrides(const LabelOverrides()),
        FirebaseUILocalizations.delegate,
      ],
      title: 'Minha Renda',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 209, 5, 5)),
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/auth', page: () => const AuthPage(),binding: UserBind()),
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/home', page: () => const Home(), bindings: [UserBind(), MonthBalance()]),
        GetPage(
            name: '/profile', page: () => const Profile(), binding: UserBind()),
      ],
    );
  }
}
