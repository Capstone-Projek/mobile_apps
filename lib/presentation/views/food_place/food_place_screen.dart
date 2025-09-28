import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Place {
  final String name;
  final String address;
  final double price;
  final String image;
  final LatLng location;

  Place({
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

  final List<Place> places = [
    Place(
      name: "Toko Haji Makmur",
      address: "Jl. Pekunden Rayano",
      price: 5000,
      image: "images/makanan.jpg",
      location: LatLng(-6.9833, 110.4167),
    ),
    Place(
      name: "Warung Bu Siti",
      address: "Jl. Simpang Lima",
      price: 10000,
      image: "images/makanan.jpg",
      location: LatLng(-6.9900, 110.4200),
    ),
    Place(
      name: "Kedai Kopi Bang Jo",
      address: "Jl. Pemuda",
      price: 15000,
      image: "images/makanan.jpg",
      location: LatLng(-6.9820, 110.4300),
    ),
  ];

  LatLngBounds? _visibleBounds;
  int? activeIndex;
  int? _lastTappedIndex;

  void _onMarkerTap(int index) {
    setState(() {
      activeIndex = index;
    });

    _mapController.move(places[index].location, _mapController.camera.zoom);

    _scrollController.animateTo(
      index * 140,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final visiblePlaces = _visibleBounds == null
        ? places
        : places.where((p) => _visibleBounds!.contains(p.location)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Map Screen",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        backgroundColor: Color(0xFF26599A),
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(-6.9833, 110.4167),
                initialZoom: 13,
                onMapEvent: (event) {
                  final bounds = _mapController.camera.visibleBounds;
                  setState(() {
                    _visibleBounds = bounds;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: List.generate(places.length, (index) {
                    final place = places[index];
                    final isActive = activeIndex == index;

                    return Marker(
                      point: place.location,
                      width: 50,
                      height: 50,
                      child: GestureDetector(
                        onTap: () => _onMarkerTap(index),
                        child: Icon(
                          Icons.location_on,
                          color: isActive ? Color(0xFF26599A) : Colors.red,
                          size: isActive ? 50 : 40,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFF3F3F3),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 320,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Rekomendasi Tempat",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (visiblePlaces.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              "Tidak ada data",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            physics: const BouncingScrollPhysics(),
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
                                    );
                                  } else {
                                    _onMarkerTap(originalIndex);
                                    setState(() {
                                      _lastTappedIndex = originalIndex;
                                    });
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? Color(0xFF26599A)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isActive
                                          ? Color(0xFF26599A)
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
                                        child: Image.asset(
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
                                                    place.price.toStringAsFixed(
                                                      0,
                                                    ),
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
