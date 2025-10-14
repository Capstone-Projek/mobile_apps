import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:mobile_apps/presentation/viewmodels/auth/user/shared_preferences_provider.dart';
import 'package:mobile_apps/presentation/viewmodels/food_place/food_place_list_provider.dart';
import 'package:mobile_apps/presentation/static/food_place/food_place_list_result_state.dart';
import 'package:mobile_apps/data/models/food_place/food_place_list_response_model.dart';

class Place {
  final int id;
  final String name;
  final String address;
  final String price;
  final String image;
  final LatLng location;

  Place({
    required this.id,
    required this.name,
    required this.address,
    required this.price,
    required this.image,
    required this.location,
  });
}

class FoodPlaceScreen extends StatefulWidget {
  const FoodPlaceScreen({super.key});

  @override
  State<FoodPlaceScreen> createState() => _FoodPlaceScreenState();
}

class _FoodPlaceScreenState extends State<FoodPlaceScreen> {
  final MapController _mapController = MapController();
  final ScrollController _scrollController = ScrollController();
  
  LatLngBounds? _visibleBounds;
  int? activeIndex;
  int? _lastTappedIndex;
  bool _hasFittedCamera = false;
  double _mapZoom = 13.0;
  List<Place> places = [];

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final sharedProvider = context.read<SharedPreferencesProvider>();
      sharedProvider.getAccessToken();

      final token = sharedProvider.accessToken;
      if (token == null) return;

      await context.read<FoodPlaceListProvider>().fetchFoodPlaceList(token);
      if (!mounted) return;
    });

    _mapController.mapEventStream.listen((event) {
      setState(() {
        _mapZoom = event.camera.zoom;
      });
    });
  }

  List<Place> _mapApiModelToPlace(List<FoodPlaceListResponseModel> apiData) {
    return apiData.map((item) {
      return Place(
        id: item.id,
        name: item.shopName,
        address: item.address,
        price: item.priceRange,
        image: item.images.imageUrl,
        location: LatLng(
          double.tryParse(item.latitude.toString()) ?? 0.0,
          double.tryParse(item.longitude.toString()) ?? 0.0,
        ),
      );
    }).toList();
  }

  void _onMarkerTap(int index) {
    setState(() {
      if (activeIndex == index) {
        return;
      }
      activeIndex = index;
      _lastTappedIndex = index;
    });

    _animateToLocation(places[index].location);

    _scrollController.animateTo(
      index * 140,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _animateToLocation(LatLng target) async {
    final zoom = _mapController.camera.zoom;
    final currentCenter = _mapController.camera.center;

    const duration = Duration(milliseconds: 500);
    const steps = 30;

    for (int i = 0; i <= steps; i++) {
      final t = i / steps;
      final lat =
          currentCenter.latitude +
          (target.latitude - currentCenter.latitude) * t;
      final lng =
          currentCenter.longitude +
          (target.longitude - currentCenter.longitude) * t;

      _mapController.move(LatLng(lat, lng), zoom);
      await Future.delayed(duration ~/ steps);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Map Screen",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        backgroundColor: const Color(0xFF26599A),
      ),
      body: Consumer<FoodPlaceListProvider>(
        builder: (context, provider, _) {
          final state = provider.resultState;

          if (state is FoodPlaceListLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FoodPlaceListErrorState) {
            return Center(child: Text(state.error));
          } else if (state is FoodPlaceListLoadedState) {
            places = _mapApiModelToPlace(state.data);

            if (places.isNotEmpty && !_hasFittedCamera) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final bounds = LatLngBounds.fromPoints(
                  places.map((e) => e.location).toList(),
                );
                _mapController.fitCamera(CameraFit.bounds(bounds: bounds));
                _hasFittedCamera = true;
              });
            }

            final visiblePlaces = _visibleBounds == null
                ? places
                : places
                      .where((p) => _visibleBounds!.contains(p.location))
                      .toList();

            return Column(
              children: [
                Expanded(
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: LatLng(-6.9833, 110.4167),
                      initialZoom: _mapZoom,
                      onMapEvent: (event) {
                        final bounds = _mapController.camera.visibleBounds;
                        setState(() {
                          _visibleBounds = bounds;
                        });
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                      MarkerLayer(
                        markers: List.generate(places.length, (index) {
                          final place = places[index];
                          final isActive = activeIndex == index;
                          final bool showLabel = _mapZoom >= 13;

                          return Marker(
                            point: place.location,
                            width: 120,
                            height: 80,
                            child: GestureDetector(
                              onTap: () => _onMarkerTap(index),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (showLabel)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isActive
                                          ? const Color(0xFF26599A)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.2),
                                          blurRadius: 3,
                                          offset: const Offset(1, 1),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      place.name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                        color: isActive
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Icon(
                                    Icons.location_on,
                                    color: isActive
                                        ? const Color(0xFF26599A)
                                        : Colors.red,
                                    size: isActive ? 40 : 30,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 320,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: visiblePlaces.isEmpty
                      ? const Center(child: Text("Tidak ada data"))
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: visiblePlaces.length,
                          itemBuilder: (context, index) {
                            final place = visiblePlaces[index];
                            final isActive =
                                activeIndex != null &&
                                places[activeIndex!].name == place.name;

                            return GestureDetector(
                              onTap: () {
                                final originalIndex = places.indexWhere(
                                  (p) => p.name == place.name,
                                );
                                if (_lastTappedIndex == originalIndex) {
                                  Navigator.pushNamed(
                                    context,
                                    '/food-place-detail',
                                    arguments: place.id,
                                  );
                                } else {
                                  _onMarkerTap(originalIndex);
                                  _lastTappedIndex = originalIndex;
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? const Color(0xFF26599A)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isActive
                                        ? const Color(0xFF26599A)
                                        : Colors.grey.shade300,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        bottomLeft: Radius.circular(12),
                                      ),
                                      child: Image.network(
                                        place.image,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                width: 100,
                                                height: 100,
                                                color: Colors.grey[300],
                                                child: const Icon(
                                                  Icons.image_not_supported,
                                                  size: 40,
                                                  color: Colors.grey,
                                                ),
                                              );
                                            },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              place.name,
                                              style: TextStyle(
                                                color: isActive
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.location_on,
                                                  color: isActive
                                                      ? Colors.white
                                                      : Colors.grey,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    place.address,
                                                    style: TextStyle(
                                                      color: isActive
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 14,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.local_offer,
                                                  color: isActive
                                                      ? Colors.white
                                                      : Colors.grey,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  "IDR ${place.price}",
                                                  style: TextStyle(
                                                    color: isActive
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
