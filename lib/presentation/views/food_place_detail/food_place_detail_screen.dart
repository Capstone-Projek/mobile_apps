import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_apps/presentation/viewmodels/auth/user/shared_preferences_provider.dart';
import 'package:mobile_apps/presentation/viewmodels/food_place/food_place_detail_provider.dart';
import 'package:mobile_apps/presentation/static/food_place/food_place_detail_result_state.dart';

class FoodPlaceDetailScreen extends StatefulWidget {
  const FoodPlaceDetailScreen({super.key});

  @override
  State<FoodPlaceDetailScreen> createState() => _FoodPlaceDetailScreenState();
}

class _FoodPlaceDetailScreenState extends State<FoodPlaceDetailScreen> {
  final List<Map<String, String>> menuItems = [
    {
      "image": "images/makanan.jpg",
      "title": "Soto Bangka Beli",
      "desc": "Soto Bangka Beli adalah Soto khas daerah ini kar",
    },
    {
      "image": "images/makanan.jpg",
      "title": "Nasi Goreng Pak Kumis",
      "desc": "Nasi goreng terenak di kota dengan bumbu khas tradisional.",
    },
    {
      "image": "images/makanan.jpg",
      "title": "Ayam Penyet Bu Rini",
      "desc": "Ayam penyet pedas mantap dengan sambal terasi khas rumah makan ini.",
    },
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final id = ModalRoute.of(context)!.settings.arguments as int;

      final sharedProvider = context.read<SharedPreferencesProvider>();
      sharedProvider.getAccessToken();
      
      final token = sharedProvider.accessToken;

      if (!mounted || token == null) return;

      await context.read<FoodPlaceDetailProvider>().fetchFoodPlaceById(
        token,
        id,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FoodPlaceDetailProvider>().resultState;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(
        builder: (context) {
          if (state is FoodPlaceDetailLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FoodPlaceDetailErrorState) {
            return Center(child: Text(state.error));
          } else if (state is FoodPlaceDetailLoadedState) {
            final place = state.data;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Image.network(
                        place.images.imageUrl,
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
                                style: TextStyle(color: Colors.white, fontSize: 12),
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
                            Text(place.foodName),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.local_offer),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text("IDR ${place.priceRange}"),
                            ),
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
                            Text("${place.openHours} - ${place.closeHours} WIB"),
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
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) {
                        final item = menuItems[index];
                        return Container(
                          width: 160,
                          margin: const EdgeInsets.only(right: 12),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: Colors.grey),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: Image.asset(
                                    item["image"]!,
                                    width: double.infinity,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    item["title"]!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    item["desc"]!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
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
