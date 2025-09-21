import 'package:flutter/material.dart';
import 'package:mobile_apps/presentation/static/navigation_route.dart';
import 'package:mobile_apps/presentation/styles/theme/jejak_rasa_theme.dart';
import 'package:mobile_apps/presentation/views/login_screen.dart';
import 'package:mobile_apps/presentation/views/splash_screen.dart';
import 'package:mobile_apps/presentation/views/welcome_screen.dart';

void main() {
  String route = NavigationRoute.splashRoute.path;
  runApp(MyApp(initialRoute: route));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jejak Rasa',
      debugShowCheckedModeBanner: false,
      theme: JejakRasaTheme.lightTheme,
      darkTheme: JejakRasaTheme.darkTheme,
      themeMode: ThemeMode.light,
      initialRoute: initialRoute,
      routes: {
        NavigationRoute.splashRoute.path: (context) => SplashScreen(),
        NavigationRoute.welcomeRoute.path: (context) => WelcomeScreen(),
        NavigationRoute.loginRoute.path: (context) => LoginScreen(),
      },
    );
  }
}
