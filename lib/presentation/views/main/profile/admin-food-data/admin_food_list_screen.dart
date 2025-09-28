import 'package:flutter/material.dart';
import 'package:mobile_apps/presentation/styles/color/jejak_rasa_color.dart';
import 'package:mobile_apps/presentation/styles/theme/jejak_rasa_theme.dart';
import 'package:mobile_apps/presentation/widgets/search_bar_widget.dart';

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
          // aksi
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
              onSubmitted: _searchFood(),
              hintText: "Cari makanan pilihanmu",
              searchController: _searchController,
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.asset(
                              "assets/images/welcome_screen_2_background.jpg",
                              height: 80,
                              width: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.broken_image,
                                  size: 80,
                                  color: Colors.grey,
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 10),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Title",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                Text(
                                  "Description",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall!.copyWith(fontSize: 12),
                                ),
                              ],
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
    );
  }
}
