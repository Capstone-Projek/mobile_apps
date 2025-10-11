import 'package:flutter/material.dart';
import 'package:mobile_apps/presentation/static/food/food_list_result_state.dart';
import 'package:mobile_apps/presentation/static/food/search_food_result_state.dart';
import 'package:mobile_apps/presentation/static/main/navigation_route.dart';
import 'package:mobile_apps/presentation/styles/color/jejak_rasa_color.dart';
import 'package:mobile_apps/presentation/styles/theme/jejak_rasa_theme.dart';
import 'package:mobile_apps/presentation/viewmodels/food/food_list_provider.dart';
import 'package:mobile_apps/presentation/viewmodels/food/search_food_provider.dart';
import 'package:mobile_apps/presentation/widgets/search_bar_widget.dart';
import 'package:provider/provider.dart';

class AdminFoodListScreen extends StatefulWidget {
  const AdminFoodListScreen({super.key});

  @override
  State<AdminFoodListScreen> createState() => _AdminFoodListScreenState();
}

class _AdminFoodListScreenState extends State<AdminFoodListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FoodListProvider>().getFoodList();
    });
  }

  Future<void> _searchFood(String query) async {
    if (query.isEmpty) {
      context.read<FoodListProvider>().getFoodList();
      return;
    }

    final searchProvider = context.read<SearchFoodProvider>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await searchProvider.searchFood(query);
      if (mounted) {
        Navigator.pop(context);
      }

      final state = searchProvider.resultState;
      if (state is SearchFoodResultLoadedState) {
        final food = state.data;
        if (mounted) {
          Navigator.pushNamed(
            context,
            NavigationRoute.editAdminFoodList.path,
            arguments: food,
          ).then((_) {
            if (mounted) {
              context.read<FoodListProvider>().getFoodList();
            }
          });
        }
      } else if (state is SearchFoodResultErrorState) {
        debugPrint(state.error);
        _showErrorDialog(
          "Makanan \"$query\" tidak ditemukan atau gagal memuat data.",
        );
      } else {
        _showNotFoundDialog(query);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        _showErrorDialog(e.toString());
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Terjadi Kesalahan"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  void _showNotFoundDialog(String query) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Data Tidak Ditemukan"),
        content: Text('Makanan dengan nama "$query" tidak ditemukan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foodProvider = context.watch<FoodListProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          'Data Makanan',
          style: Theme.of(
            context,
          ).textTheme.titleSmall!.copyWith(color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: JejakRasaColor.secondary.color,
        foregroundColor: JejakRasaColor.primary.color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        onPressed: () {
          Navigator.pushNamed(
            context,
            NavigationRoute.createAdminFoodList.path,
          ).then((_) {
            if (context.mounted) {
              context.read<FoodListProvider>().getFoodList();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: JejakRasaTheme.defaultPadding,
          vertical: JejakRasaTheme.defaultPadding,
        ),
        child: Column(
          children: [
            SearchBarWidget(
              onSubmitted: _searchFood,
              hintText: "Cari makanan (langsung menuju edit)",
              searchController: _searchController,
            ),
            const SizedBox(height: 20),
            Expanded(child: _buildFoodList(context, foodProvider)),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodList(BuildContext context, FoodListProvider provider) {
    final state = provider.resultState;

    if (state is FoodListResultLoadingState) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is FoodListResultErrorState) {
      return _buildErrorState(state.error, () => provider.getFoodList());
    } else if (state is FoodListResultLoadedState) {
      if (state.data.isEmpty) {
        return _buildEmptyState("Tidak ada data makanan");
      }

      return ListView.builder(
        itemCount: state.data.length,
        itemBuilder: (context, index) {
          final food = state.data[index];
          final imageUrl = food.getFirstImageUrl();

          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  NavigationRoute.editAdminFoodList.path,
                  arguments: food,
                ).then((_) {
                  if (context.mounted) {
                    context.read<FoodListProvider>().getFoodList();
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: imageUrl != null
                          ? Image.network(
                              imageUrl,
                              height: 100,
                              width: 110,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildImagePlaceholder();
                              },
                            )
                          : _buildImagePlaceholder(),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            food.foodName,
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            food.desc,
                            style: Theme.of(context).textTheme.bodySmall!
                                .copyWith(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: JejakRasaColor.secondary.color.withValues(
                                alpha: 0.2,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              food.category,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: JejakRasaColor.secondary.color,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                food.from,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                food.timeCook,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'delete') {
                          _showDeleteConfirmation(
                            context,
                            food.idFood,
                            food.foodName,
                          );
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 20, color: Colors.red),
                              SizedBox(width: 8),
                              Text(
                                'Hapus',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildImagePlaceholder() {
    return Container(
      height: 100,
      width: 110,
      color: Colors.grey[300],
      child: const Icon(Icons.restaurant, size: 40, color: Colors.grey),
    );
  }

  Widget _buildErrorState(String error, VoidCallback onRetry) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            error,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Coba Lagi')),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    int foodId,
    String foodName,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus "$foodName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              // context.read<FoodListProvider>().deleteFood(foodId);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
