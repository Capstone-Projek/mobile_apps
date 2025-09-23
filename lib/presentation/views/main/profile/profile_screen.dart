import 'package:flutter/material.dart';
import 'package:mobile_apps/presentation/static/navigation_route.dart';
import 'package:mobile_apps/presentation/styles/theme/jejak_rasa_theme.dart';
import 'package:mobile_apps/presentation/widgets/button_navigate_widget.dart';
import 'package:mobile_apps/presentation/widgets/header_layout_widget.dart';
import 'package:mobile_apps/presentation/widgets/setting_button_widget.dart';
import 'package:mobile_apps/presentation/widgets/setting_switch_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Padding(
              padding: EdgeInsetsGeometry.only(
                left: JejakRasaTheme.defaultPadding,
                right: JejakRasaTheme.defaultPadding,
                top: 45,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage(
                            "assets/images/welcome_screen_1_background.jpeg",
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Dinusian",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Dinusian@gmail.com",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displayLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 22),
                  HeaderLayoutWidget(title: "Informasi Akun"),
                  SettingButtonWidget(title: "Ubah Profil", onTap: () {}),
                  SettingButtonWidget(title: "Ubah Password", onTap: () {}),
                  SizedBox(height: 5),
                  HeaderLayoutWidget(title: "Preferensi"),
                  SettingSwitchWidget(
                    title: "Tema saat ini",
                    isDarkTheme: isDarkTheme,
                    onChanged: (value) {
                      setState(() {
                        isDarkTheme = value;
                      });
                    },
                  ),
                  SizedBox(height: 5),
                  HeaderLayoutWidget(title: "Masukan Data Admin"),
                  SettingButtonWidget(title: "Data Makanan", onTap: () {}),
                  SettingButtonWidget(title: "Data Toko", onTap: () {}),
                  SizedBox(height: 56),
                  ButtonNavigateWidget(
                    width: double.infinity,
                    height: 22,
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        NavigationRoute.loginRoute.path,
                        (route) => false,
                      );
                    },
                    title: "K E L U A R",
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
