import 'package:flutter/material.dart';
import 'package:mobile_apps/presentation/viewmodels/food/create_food_provider.dart';
import 'package:mobile_apps/presentation/widgets/food_form_widget.dart';
import 'package:provider/provider.dart';

class CreateFoodListScreen extends StatelessWidget {
  const CreateFoodListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateFoodProvider(),
      child: Consumer<CreateFoodProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              title: Text(
                'Tambah Data Makanan',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall!.copyWith(color: Colors.white),
              ),
            ),
            body: Stack(
              children: [
                FoodForm(
                  onSubmit: (newData) {
                    provider.createFood(context, newData);
                  },
                ),

                // Loading overlay
                if (provider.isLoading)
                  Container(
                    color: Colors.black.withValues(alpha: 0.3),
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
