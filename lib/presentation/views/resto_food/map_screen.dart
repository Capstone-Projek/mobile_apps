import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

// Ganti dengan path ke ViewModel dan Model Anda yang sebenarnya
import '../../../data/models/main/resto/resto_food_model.dart';
import '../../static/main/navigation_route.dart';
import '../../viewmodels/resto/food_place_detail_view_model.dart';
import '../../viewmodels/resto/resto_food_viewmodel.dart'; // Asumsi ini MapViewModel

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Koordinat default (misalnya, pusat kota)
  static const LatLng _initialCenter = LatLng(-7.967, 112.632);
  final MapController _mapController = MapController(); // Controller untuk map

  // ⭐️ State BARU untuk melacak mode tambah resto
  bool _isAddingMode = false;

  @override
  void initState() {
    super.initState();
    // Panggil fetchFoodPlaces saat screen pertama kali dibuka
    Future.microtask(() =>
        Provider.of<MapViewModel>(context, listen: false).fetchFoodPlaces()
    );
  }

  // FUNGSI BARU: Menangani Tap di Peta untuk menangkap koordinat
  void _handleMapTap(LatLng latLng) {
    if (!_isAddingMode) {
      // Abaikan tap jika tidak dalam mode tambah (untuk menghindari konflik dengan marker)
      return;
    }

    // 1. Matikan mode tambah
    setState(() {
      _isAddingMode = false;
    });

    // 2. Tampilkan notifikasi
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Koordinat ditangkap: Lat ${latLng.latitude.toStringAsFixed(4)}, Long ${latLng.longitude.toStringAsFixed(4)}"),
        duration: const Duration(seconds: 2),
      ),
    );

    // 3. Navigasi ke halaman Form Insert dengan membawa koordinat
    Navigator.pushNamed(
      context,
      NavigationRoute.createFoodPlace.path, // Ganti dengan path route create Anda
      arguments: {'latitude': latLng.latitude, 'longitude': latLng.longitude},
    ).then((_) {
      // Muat ulang data peta setelah kembali dari form
      Provider.of<MapViewModel>(context, listen: false).fetchFoodPlaces();
    });
  }

  // Helper untuk membuat baris detail dengan ikon berwarna Primary MD3
  Widget _buildDetailRow({required IconData icon, required String label, required String value}) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isEmpty ? "Tidak tersedia" : value,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper untuk membuat card info kecil (Jam/Harga) dengan MD3 Card
  Widget _buildInfoCard({required IconData icon, required String title, required String subtitle}) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      color: colorScheme.surfaceContainerHigh,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28, color: colorScheme.secondary),
            const SizedBox(height: 12),
            Text(
              title,
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle.isEmpty ? "-" : subtitle,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // FUNGSI UNTUK MEMBANGUN KONTEN DETAIL
  Widget _buildDetailContent(RestoPlaceModel place, ScrollController scrollController) {
    // ⭐️ Penanganan List<ImageInfo> nullable
    final List<String> imageUrls = place.images != null && place.images!.isNotEmpty
        ? place.images!.map((img) => img.imageUrl).toList()
        : [];

    final screenHeight = MediaQuery.of(context).size.height;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        // Drag Handle
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withOpacity(0.4),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),

        // Konten utama yang dapat di-scroll
        Expanded(
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Image Slider (PageView)
                if (imageUrls.isNotEmpty)
                  Container(
                    height: screenHeight * 0.35,
                    width: double.infinity,
                    child: PageView.builder(
                      itemCount: imageUrls.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Image.network(
                              imageUrls[index],
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(child: CircularProgressIndicator(
                                  color: colorScheme.primary,
                                ));
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Center(child: Icon(Icons.broken_image, size: 50, color: colorScheme.onSurfaceVariant));
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  )
                else
                  Container(
                    height: screenHeight * 0.35,
                    color: colorScheme.surfaceContainerLow,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_not_supported, size: 50, color: colorScheme.onSurfaceVariant),
                          Text("Gambar tidak tersedia", style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                        ],
                      ),
                    ),
                  ),

                // 2. Detail Konten
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul Toko
                      Text(
                        place.shopName,
                        style: textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Food Name
                      Text(
                        "Menu Utama: ${place.foodName}",
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Grid Jam Buka & Harga
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoCard(
                              icon: Icons.schedule,
                              title: "Jam Operasi",
                              subtitle: "${place.openHours} - ${place.closeHours}",
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildInfoCard(
                              icon: Icons.price_change,
                              title: "Rentang Harga",
                              subtitle: "Rp ${place.priceRange}",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      Divider(height: 1, color: colorScheme.outlineVariant),
                      const SizedBox(height: 24),

                      // Sub-judul Detail Lokasi
                      Text(
                        "Informasi Kontak & Lokasi",
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Alamat & Kontak
                      _buildDetailRow(
                        icon: Icons.location_on,
                        label: "Alamat",
                        value: place.address,
                      ),
                      _buildDetailRow(
                        icon: Icons.phone,
                        label: "Nomor Telepon",
                        value: place.phone,
                      ),

                      const SizedBox(height: 30),

                      // Tombol Aksi (Edit)
                      Center(
                        child: FilledButton.icon(
                          onPressed: () {
                            Navigator.pop(context); // Tutup bottom sheet

                            // NAVIGASI KE HALAMAN EDIT
                            Navigator.pushNamed(
                              context,
                              NavigationRoute.editFoodPlaceRoute.path,
                              arguments: place,
                            );
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit Resto'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            textStyle: textTheme.titleMedium,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Fungsi untuk menampilkan detail di bottom sheet
  void _showDetailSheet(BuildContext context, RestoPlaceModel foodPlace) {
    final detailViewModel = Provider.of<FoodPlaceDetailViewModel>(context, listen: false);
    detailViewModel.clearData();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        Future.microtask(() {
          detailViewModel.fetchFoodPlaceById(foodPlace.id);
        });

        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.25,
          maxChildSize: 1.0,
          expand: false,
          builder: (context, scrollController) {
            return ChangeNotifierProvider.value(
              value: detailViewModel,
              child: Consumer<FoodPlaceDetailViewModel>(
                builder: (context, vm, child) {
                  if (vm.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  }

                  if (vm.errorMessage != null || vm.foodPlace == null) {
                    return Center(
                      child: Text(
                        vm.errorMessage ?? "Detail tidak ditemukan",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    );
                  }

                  return _buildDetailContent(vm.foodPlace!, scrollController);
                },
              ),
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Feedback visual untuk FAB
    final fabTooltip = _isAddingMode ? "Batal Menangkap Lokasi" : "Tambah Resto Baru";
    final fabIcon = _isAddingMode ? Icons.close : Icons.add;
    final fabColor = _isAddingMode ? colorScheme.error : colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Peta Tempat Makan"),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),

      // ⭐️ FLOATING ACTION BUTTON untuk mengaktifkan mode tap
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isAddingMode = !_isAddingMode; // Toggle mode
          });

          if (_isAddingMode) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Mode Tambah Resto Aktif! Ketuk di Peta untuk menangkap koordinat."),
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
        backgroundColor: fabColor,
        tooltip: fabTooltip,
        child: Icon(fabIcon, color: colorScheme.onPrimary),
      ),

      body: Consumer<MapViewModel>(
        builder: (context, mapVM, child) {
          if (mapVM.isLoading) {
            return Center(child: CircularProgressIndicator(color: colorScheme.primary));
          }

          if (mapVM.errorMessage != null) {
            return Center(child: Text("Gagal memuat data: ${mapVM.errorMessage}"));
          }

          final markers = mapVM.foodPlaces.map((place) {
            final LatLng point = LatLng(place.latitude, place.longitude);

            return Marker(
              point: point,
              width: 100,
              height: 100,
              child: GestureDetector(
                onTap: () => _showDetailSheet(context, place),
                child: Column(
                  children: [
                    // Label Marker MD3 Style
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHigh.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: colorScheme.onSurface, width: 0.5),
                      ),
                      child: Text(
                        place.shopName,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Ikon Marker
                    Icon(Icons.location_on, color: colorScheme.error, size: 30),
                  ],
                ),
              ),
            );
          }).toList();

          return FlutterMap(
            mapController: _mapController, // Pasang controller
            options: MapOptions(
              initialCenter: _initialCenter,
              initialZoom: 13.0,
              // ⭐️ PASANG LISTENER TAP DI SINI
              onTap: (tapPosition, latLng) => _handleMapTap(latLng),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.mobile_apps',
              ),
              MarkerLayer(markers: markers),
            ],
          );
        },
      ),
    );
  }
}