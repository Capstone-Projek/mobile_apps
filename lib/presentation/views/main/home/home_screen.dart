import 'package:flutter/material.dart';
import 'package:mobile_apps/presentation/static/main/beranda/food_list_resul_state.dart';
import 'package:mobile_apps/presentation/static/main/beranda/resto_list_result_state.dart';
import 'package:mobile_apps/presentation/viewmodels/auth/user/shared_preferences_provider.dart';
import 'package:mobile_apps/presentation/viewmodels/main/beranda/home_provider.dart';
import 'package:mobile_apps/presentation/views/main/home/body_of_home_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (mounted) {
        final sharedProvider = context.read<SharedPreferencesProvider>();
        sharedProvider.getRefreshToken();
        sharedProvider.getAccessToken();
        sharedProvider.getshowUsername();
        sharedProvider.getshowEmail();
        sharedProvider.syncToken();

        //get food
        context.read<HomeProvider>().fetchFoodList(sharedProvider.accessToken!);
        //get resto
        context.read<HomeProvider>().fetchRestoList(
          sharedProvider.accessToken!,
        );
      }
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
          final restoList = (value.restoState is RestoListLoadedState)
              ? (value.restoState as RestoListLoadedState).data
              : [];

          // ✅ Debug print seluruh list
          debugPrint("Resto list length: ${restoList.length}");

          return switch (value.resultState) {
            FoodListLoadingState() => const Center(
              child: CircularProgressIndicator(),
            ),
            FoodListErrorState(error: var message) => Center(
              child: Text(message),
            ),
            FoodListLoadedState(data: var restaurantList) => RefreshIndicator(
              child: BodyOfHomeScreen(
                restoList: (value.restoState is RestoListLoadedState)
                    ? (value.restoState as RestoListLoadedState).data
                    : [],
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
