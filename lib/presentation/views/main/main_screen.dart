import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:mobile_apps/presentation/viewmodels/auth/user/shared_preferences_provider.dart';
import 'package:mobile_apps/presentation/viewmodels/main/index_nav_provider.dart';
import 'package:mobile_apps/presentation/views/main/camera/camera_screen.dart';
import 'package:mobile_apps/presentation/views/main/home/home_screen.dart';
import 'package:mobile_apps/presentation/views/main/profile/profile_screen.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(Icons.camera, size: 30),
      Icon(Icons.home, size: 30),
      Icon(Icons.person, size: 30),
    ];

    final index = context.watch<IndexNavProvider>().indexBottomNavbar;

    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: SafeArea(
        top: false,
        child: ClipRRect(
          child: Scaffold(
            extendBody: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            body: SafeArea(
              child: IndexedStack(
                index: index,
                children: [CameraScreen(), HomeScreen(), ProfileScreen()],
              ),
            ),
            bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(
                iconTheme: IconThemeData(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              child: CurvedNavigationBar(
                color: Theme.of(context).colorScheme.secondary,
                buttonBackgroundColor: Theme.of(
                  context,
                ).colorScheme.onSecondary,
                backgroundColor: Colors.transparent,
                height: 60,
                items: items,
                index: index,
                onTap: (value) {
                  context.read<IndexNavProvider>().setIndexBottomNavbar = value;
                },
                animationCurve: Curves.easeInOut,
                animationDuration: Duration(milliseconds: 300),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
