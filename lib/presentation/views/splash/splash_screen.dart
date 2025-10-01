import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_apps/presentation/viewmodels/auth/user/shared_preferences_provider.dart';
import 'package:mobile_apps/presentation/static/main/navigation_route.dart';
import 'package:mobile_apps/presentation/styles/color/jejak_rasa_color.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    Future.microtask(() {
      final sharedPreverencesProvider = context
          .read<SharedPreferencesProvider>();

      sharedPreverencesProvider.getRefreshToken();
      sharedPreverencesProvider.getAccessToken();
      sharedPreverencesProvider.getshowUsername();
      sharedPreverencesProvider.getshowEmail();

      Timer(Duration(seconds: 3), () {
        if (sharedPreverencesProvider.showUsername != "" ||
            sharedPreverencesProvider.showUsername != "" ||
            sharedPreverencesProvider.accessToken != "" ||
            sharedPreverencesProvider.refreshToken != "") {
          Navigator.pushNamedAndRemoveUntil(
            context,
            NavigationRoute.mainRoute.path,
            (route) => false,
          );
        } else if (sharedPreverencesProvider.showMainScreen == true) {
          Navigator.pushNamed(context, NavigationRoute.loginRoute.path);
        } else {
          Navigator.pushNamed(context, NavigationRoute.welcomeRoute.path);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width * 0.40,
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage("assets/logo/jejak_rasa_logo.png"),
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Jejak",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: JejakRasaColor.secondary.color,
                      ),
                    ),
                    TextSpan(
                      text: " Rasa",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
