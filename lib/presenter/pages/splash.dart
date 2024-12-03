import 'package:fatureicurso/presenter/widgets/animatedlogo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Responsabilidades: contagem de tempo e navegação para a home
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Future.delayed(const Duration(seconds: 4), () {
        if (mounted) {
          Get.offNamed('/auth');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child: Scaffold(
      body: Center(
        child: AnimatedSplashLogo(),
      ),
    ));
  }
}
