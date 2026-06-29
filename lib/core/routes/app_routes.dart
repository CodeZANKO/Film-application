import 'package:flutter/material.dart';
import 'package:film_app/features/auth/presentation/pages/login_page.dart';
import 'package:film_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:film_app/features/main/presentation/pages/main_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String main = '/main';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case signUp:
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case main:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}

