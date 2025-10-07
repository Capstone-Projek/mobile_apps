import 'package:flutter/material.dart';
import 'package:mobile_apps/presentation/static/food/food_list_result_state.dart';
import 'package:mobile_apps/presentation/static/main/navigation_route.dart';
import 'package:mobile_apps/presentation/styles/color/jejak_rasa_color.dart';
import 'package:mobile_apps/presentation/styles/theme/jejak_rasa_theme.dart';
import 'package:mobile_apps/presentation/viewmodels/food/food_list_provider.dart';
import 'package:mobile_apps/presentation/widgets/search_bar_widget.dart';
import 'package:provider/provider.dart';

class AdminFoodListScreen extends StatefulWidget {
  const AdminFoodListScreen({super.key});

  @override
  State<AdminFoodListScreen> createState() => _AdminFoodListScreenState();
}

class _AdminFoodListScreenState extends State<AdminFoodListScreen> {
  final TextEditingController _searchController = TextEditingController();

  void Function(String) _searchFood() {
    return (String value) {};
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FoodListProvider>().getFoodList();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white),
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
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: JejakRasaTheme.defaultPadding,
          vertical: JejakRasaTheme.defaultPadding,
        ),
        child: RefreshIndicator(
          color: JejakRasaColor.secondary.color,
          onRefresh: () {
            return context.read<FoodListProvider>().getFoodList();
          },
          child: Column(
            children: [
              SearchBarWidget(
                onSubmitted: _searchFood(),
                hintText: "Cari makanan pilihanmu",
                searchController: _searchController,
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Consumer<FoodListProvider>(
                  builder: (context, provider, child) {
                    final state = provider.resultState;

                    if (state is FoodListResultLoadingState) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: JejakRasaColor.secondary.color,
                        ),
                      );
                    } else if (state is FoodListResultErrorState) {
                      return Center(child: Text(state.error));
                    } else if (state is FoodListResultLoadedState) {
                      if (state.data.isEmpty) {
                        return const Center(child: Text("Tidak ada data"));
                      }

                      return ListView.builder(
                        itemCount: state.data.length,
                        itemBuilder: (context, index) {
                          final food = state.data[index];
                          final imageUrl = food.getFirstImageUrl();

                          return Card(
                            elevation: 4,
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
                                            loadingBuilder:
                                                (
                                                  context,
                                                  child,
                                                  loadingProgress,
                                                ) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return Container(
                                                    height: 80,
                                                    width: 100,
                                                    color: Colors.grey[300],
                                                    child: const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                          ),
                                                    ),
                                                  );
                                                },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Container(
                                                    height: 100,
                                                    width: 110,
                                                    color: Colors.grey[300],
                                                    child: const Icon(
                                                      Icons.broken_image,
                                                      size: 40,
                                                      color: Colors.grey,
                                                    ),
                                                  );
                                                },
                                          )
                                        : Container(
                                            height: 100,
                                            width: 110,
                                            color: Colors.grey[300],
                                            child: const Icon(
                                              Icons.restaurant,
                                              size: 40,
                                              color: Colors.grey,
                                            ),
                                          ),
                                  ),

                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          food.foodName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          food.desc,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
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
                                            color: JejakRasaColor
                                                .secondary
                                                .color
                                                .withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Text(
                                            food.category,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: JejakRasaColor
                                                  .secondary
                                                  .color,
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
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
