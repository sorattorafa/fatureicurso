import 'package:fatureicurso/data/features/auth/controllers/user.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final user = await Get.find<UserController>().getUser;
      if (user != '') {
        Get.offNamed('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final providers = [EmailAuthProvider()];
    return SignInScreen(
      providers: providers,
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) async {
          Get.find<UserController>().setUserToken =
              await state.user?.getIdToken();

          Get.offNamed('/home');
        }),
        AuthStateChangeAction<UserCreated>((context, state) {
          Get.offNamed('/home');
        }),
      ],
      headerBuilder: (context, constraints, shrinkOffset) {
        return Image.asset(
          'assets/icons/logo.png',
          height: constraints.maxHeight,
          width: constraints.maxWidth,
        );
      },
      sideBuilder: (context, constraints) {
        return Image.asset(
          'assets/icons/logo.png',
          height: constraints.maxHeight,
          width: constraints.maxWidth,
        );
      },
      subtitleBuilder: (context, action) {
        final actionText = switch (action) {
          AuthAction.signIn => 'Por favor, insira as credenciais.',
          AuthAction.signUp => 'Por favor, cadastre seu email e senha.',
          _ => throw Exception('Invalid action: $action'),
        };
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text('Bem vindo ao MinhaRenda! $actionText.'),
        );
      },
      footerBuilder: (context, action) {
        final actionText = switch (action) {
          AuthAction.signIn => 'Entrar',
          AuthAction.signUp => 'Cadastrar',
          _ => throw Exception('Invalid action: $action'),
        };

        return Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              'Após $actionText, você aceita os termos e condições.',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        );
      },
    );
  }
}
