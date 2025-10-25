import 'package:flutter/material.dart';
import 'package:mobile_apps/presentation/viewmodels/food/food_detail_provider.dart';
import 'package:provider/provider.dart';
import 'package:mobile_apps/presentation/viewmodels/auth/user/shared_preferences_provider.dart';
import 'package:mobile_apps/presentation/viewmodels/food_place/food_place_detail_provider.dart';
import 'package:mobile_apps/presentation/static/food_place/food_place_detail_result_state.dart';
import 'package:mobile_apps/presentation/static/food/food_detail_result_state.dart';
import 'package:mobile_apps/presentation/styles/color/jejak_rasa_color.dart';

class FoodPlaceDetailScreen extends StatefulWidget {
  const FoodPlaceDetailScreen({super.key});

  @override
  State<FoodPlaceDetailScreen> createState() => _FoodPlaceDetailScreenState();
}

class _FoodPlaceDetailScreenState extends State<FoodPlaceDetailScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    final Object? args = ModalRoute.of(context)?.settings.arguments;

    if (args == null || args is! int) {
      context.read<FoodPlaceDetailProvider>().setError("ID tempat makan tidak valid");
      return;
    }

    final int id = args;

    final sharedProvider = context.read<SharedPreferencesProvider>();
    final foodPlaceDetailProvider = context.read<FoodPlaceDetailProvider>();
    final foodDetailProvider = context.read<FoodDetailProvider>();

    sharedProvider.getAccessToken();
    final token = sharedProvider.accessToken;

    if (!mounted || token == null) return;

    await foodPlaceDetailProvider.fetchFoodPlaceById(id);
  
    if (!mounted) return;

    final foodPlaceState = foodPlaceDetailProvider.resultState;

    if (foodPlaceState is FoodPlaceDetailLoadedState) {
      final foodId = foodPlaceState.data.foodId;
      await foodDetailProvider.fetchFoodById(foodId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final foodPlaceState = context.watch<FoodPlaceDetailProvider>().resultState;
    final foodState = context.watch<FoodDetailProvider>().resultState;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(
        builder: (context) {
          if (foodPlaceState is FoodPlaceDetailLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (foodPlaceState is FoodPlaceDetailErrorState) {
            return Center(child: Text(foodPlaceState.error));
          } else if (foodPlaceState is FoodPlaceDetailLoadedState) {
            final place = foodPlaceState.data;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Image.network(
                        place.images?.isNotEmpty == true ? place.images!.first.imageUrl : '',
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 220,
                          color: Colors.grey,
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 60,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 12,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF26599A).withAlpha(150),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Container(
                    width: double.infinity,
                    color: const Color(0xFF26599A),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          place.shopName,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.greenAccent),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                place.address,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.food_bank_rounded),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                place.foodName,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.local_offer),
                            SizedBox(width: 8),
                            Expanded(child: Text("IDR ${place.priceRange}")),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.phone),
                            SizedBox(width: 8),
                            Text(place.phone),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.access_time_rounded),
                            SizedBox(width: 8),
                            Text(
                              "${place.openHours} - ${place.closeHours} WIB",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Menu",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    height: 220,
                    child: Builder(
                      builder: (context) {
                        if (foodState is FoodDetailLoadingState) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (foodState is FoodDetailErrorState) {
                          return Center(child: Text(foodState.error));
                        } else if (foodState is FoodDetailLoadedState) {
                          final foodDetail = foodState.data;

                          final safeFoodDetail = [
                            foodDetail
                          ];

                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: safeFoodDetail.length,
                            itemBuilder: (context, index) {
                              final item = safeFoodDetail[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: Material(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondary,
                                  borderRadius: BorderRadius.circular(10),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, '/food-detail', arguments: item.idFood);
                                    },
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      padding: const EdgeInsets.all(13),
                                      height: 201,
                                      width: 180,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: JejakRasaColor.tersier.color,
                                          strokeAlign: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: item.images.isNotEmpty == true
                                                ? ClipRRect(
                                                    borderRadius: BorderRadius.circular(8),
                                                    child: Image.network(
                                                      item.images.first.imageUrl,
                                                      width: double.infinity,
                                                      fit: BoxFit.fill,
                                                      errorBuilder: (context, error, stackTrace) {
                                                        return Container(
                                                          color: Colors.grey[200],
                                                          child: const Center(
                                                            child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  )
                                                : Container(
                                                    color: Colors.grey[200],
                                                    child: const Center(
                                                      child: Icon(
                                                        Icons.image,
                                                        color: Colors.grey,
                                                        size: 40,
                                                      ),
                                                    ),
                                                  ),
                                          ),

                                          const SizedBox(height: 12),

                                          Text(
                                            item.foodName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                                ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 5),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              item.desc,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displaySmall
                                                  ?.copyWith(
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                                  ),
                                              textAlign: TextAlign.justify,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
