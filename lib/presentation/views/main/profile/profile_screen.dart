import 'package:flutter/material.dart';
import 'package:mobile_apps/core/utils/setting_state.dart';
import 'package:mobile_apps/presentation/viewmodels/main/profile/setting_state_provider.dart';
import 'package:mobile_apps/presentation/viewmodels/shared_preferences_provider.dart';
import 'package:mobile_apps/presentation/static/main/navigation_route.dart';
import 'package:mobile_apps/presentation/styles/theme/jejak_rasa_theme.dart';
import 'package:mobile_apps/presentation/widgets/button_navigate_widget.dart';
import 'package:mobile_apps/presentation/widgets/header_layout_widget.dart';
import 'package:mobile_apps/presentation/widgets/setting_button_widget.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isDarkTheme = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<SettingStateProvider>();

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
                  SettingButtonWidget(
                    title: "Ubah Profil",
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        NavigationRoute.editProfileRoute.path,
                      );
                    },
                  ),
                  SettingButtonWidget(
                    title: "Ubah Password",
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        NavigationRoute.changePasswordRoute.path,
                      );
                    },
                  ),
                  SizedBox(height: 5),
                  HeaderLayoutWidget(title: "Preferensi"),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                    margin: const EdgeInsets.only(bottom: 5, top: 7),
                    width: double.infinity,
                    height: 42,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tema saat ini: ${themeProvider.isDarkThemeState.isEnable ? "Gelap" : "Terang"}",
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                        Switch(
                          value: themeProvider.isDarkThemeState.isEnable,
                          onChanged: (value) async {
                            themeProvider.isDarkThemeState = value
                                ? SettingState.enable
                                : SettingState.dissable;

                            final scaffoldMessager = ScaffoldMessenger.of(
                              context,
                            );

                            final sharedPreferencesProvider = context
                                .read<SharedPreferencesProvider>();

                            await sharedPreferencesProvider
                                .saveIsDarkThemeValue(value);

                            scaffoldMessager.showSnackBar(
                              SnackBar(
                                content: Text(
                                  sharedPreferencesProvider.message,
                                ),
                              ),
                            );
                          },
                          inactiveThumbColor: Theme.of(
                            context,
                          ).colorScheme.onSecondary,
                          activeThumbColor: Theme.of(
                            context,
                          ).colorScheme.secondary,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  HeaderLayoutWidget(title: "Masukan Data Admin"),
                  SettingButtonWidget(
                    title: "Data Makanan",
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        NavigationRoute.adminFoodList.path,
                      );
                    },
                  ),
                  SettingButtonWidget(title: "Data Toko", onTap: () {}),
                  SizedBox(height: 56),
                  ButtonNavigateWidget(
                    width: double.infinity,
                    height: 32,
                    onTap: () async {
                      final sharedPreverencesProvider = context
                          .read<SharedPreferencesProvider>();

                      await sharedPreverencesProvider.setShowMain(false);

                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        NavigationRoute.loginRoute.path,
                        (route) => false,
                      );
                    },
                    title: "Keluar",
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
