import 'package:flutter/material.dart';
import 'package:mobile_apps/core/static/navigation_route.dart';
import 'package:mobile_apps/presentation/styles/theme/jejak_rasa_theme.dart';
import 'package:mobile_apps/presentation/views/splash_screen.dart';

void main() {
  String route = NavigationRoute.splashRoute.path;
  runApp(MyApp(initialRoute: route));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  // This widget is the root of your application.
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
        NavigationRoute.splashRoute.path : (context) => SplashScreen(),
        
      },
    );
  }
}
