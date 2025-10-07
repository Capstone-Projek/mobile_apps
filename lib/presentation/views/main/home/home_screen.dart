import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mobile_apps/data/models/main/home/carousel_item_model.dart';
import 'package:mobile_apps/data/models/main/home/recomendation_food_model.dart';
import 'package:mobile_apps/presentation/static/main/beranda/food_list_resul_state.dart';
import 'package:mobile_apps/presentation/styles/color/jejak_rasa_color.dart';
import 'package:mobile_apps/presentation/styles/theme/jejak_rasa_theme.dart';
import 'package:mobile_apps/presentation/viewmodels/auth/user/shared_preferences_provider.dart';
import 'package:mobile_apps/presentation/viewmodels/main/beranda/home_provider.dart';
import 'package:mobile_apps/presentation/views/main/home/body_of_home_screen.dart';
import 'package:mobile_apps/presentation/widgets/button_filter_widget.dart';
import 'package:mobile_apps/presentation/widgets/recommendation_food_widget.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int activeIndex = 0;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final sharedProvider = context.read<SharedPreferencesProvider>();
      sharedProvider.getRefreshToken();
      sharedProvider.getAccessToken();
      sharedProvider.getshowUsername();
      sharedProvider.getshowEmail();
      sharedProvider.syncToken();

      print("data user ${sharedProvider.refreshToken}");
      print("data user ${sharedProvider.showUsername}");
      print("data user ${sharedProvider.accessToken}");
      print("data user ${sharedProvider.showEmail}");

      //get food
      context.read<HomeProvider>().fetchFoodList(sharedProvider.accessToken!);
    });
  }

  void _fetchData() {
    final sharedProvider = context.read<SharedPreferencesProvider>();

    context.read<HomeProvider>().fetchFoodList(sharedProvider.accessToken!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Consumer<HomeProvider>(
        builder: (context, value, child) {
          return switch (value.resultState) {
            FoodListLoadingState() => const Center(
              child: CircularProgressIndicator(),
            ),
            FoodListErrorState(error: var message) => Center(
              child: Text(message),
            ),
            FoodListLoadedState(data: var restaurantList) => RefreshIndicator(
              child: BodyOfHomeScreen(
                foodList: restaurantList,
                searchController: searchController,
              ),
              onRefresh: () async {
                _fetchData();
              },
            ),
            _ => const SizedBox(),
          };
        },
      ),
    );
  }
}
