import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_apps/presentation/static/navigation_route.dart';
import 'package:mobile_apps/presentation/styles/color/jejak_rasa_color.dart';
import 'package:mobile_apps/presentation/widgets/button_navigate_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final controller = PageController();
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Widget welcome1() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          "assets/images/welcome_screen_1_background.jpeg",
          fit: BoxFit.cover,
          alignment: Alignment.bottomCenter,
        ),
        Container(color: Colors.black.withOpacity(0.4)),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.50),
              Text(
                "Jelajahi Rasa\nKenali Budaya\nBangka Belitung",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Pelajari keunikan makanan khas\nBangka Belitung dan lestarikan\nkekayaan kuliner nusantara\nbersama kami.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget welcome2() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          "assets/images/welcome_screen_2_background.jpg",
          fit: BoxFit.cover,
          alignment: Alignment.bottomCenter,
        ),
        Container(color: Colors.black.withOpacity(0.4)),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.50),
              Container(
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Ayo Bergabung",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Kenali cita rasa, sejarah, dan filosofi\nkuliner Bangka Belitung dalam satu \naplikasi.",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 40),
                      Center(
                        child: ButtonNavigateWidget(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.height * 0.07,
                          onTap: () {
                            Navigator.popAndPushNamed(
                              context,
                              NavigationRoute.loginRoute.path,
                            );
                          },
                          title: "M U L A I",
                        ),
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          children: [welcome1(), welcome2()],
        ),
      ),
      bottomSheet: Container(
        color: JejakRasaColor.primary.color,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                controller.previousPage(
                  duration: const Duration(microseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: Text(
                "Back",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: JejakRasaColor.secondary.color,
                ),
              ),
            ),
            Center(
              child: SmoothPageIndicator(
                controller: controller,
                count: 2,
                effect: WormEffect(
                  spacing: 16,
                  dotColor: JejakRasaColor.secondary.color,
                  activeDotColor: JejakRasaColor.accent.color,
                ),
                onDotClicked: (index) => controller.animateToPage(
                  index,
                  duration: const Duration(microseconds: 500),
                  curve: Curves.easeIn,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                controller.nextPage(
                  duration: const Duration(microseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: Text(
                "Next",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: JejakRasaColor.secondary.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
