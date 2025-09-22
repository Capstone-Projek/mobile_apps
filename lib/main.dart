import 'package:flutter/material.dart';
import 'package:mobile_apps/presentation/static/navigation_route.dart';
import 'package:mobile_apps/presentation/styles/theme/jejak_rasa_theme.dart';
import 'package:mobile_apps/presentation/viewmodels/index_nav_provider.dart';
import 'package:mobile_apps/presentation/views/login/login_screen.dart';
import 'package:mobile_apps/presentation/views/main/main_screen.dart';
import 'package:mobile_apps/presentation/views/register/register_screen.dart';
import 'package:mobile_apps/presentation/views/splash/splash_screen.dart';
import 'package:mobile_apps/presentation/views/welcome/welcome_screen.dart';
import 'package:provider/provider.dart';

void main() {
  String route = NavigationRoute.splashRoute.path;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => IndexNavProvider()),
      ],
      child: MyApp(initialRoute: route),
    ),
  );
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
        NavigationRoute.registerRoute.path: (context) => RegisterScreen(),
        NavigationRoute.mainRoute.path: (context) => MainScreen(),
      },
    );
  }
}
