import 'package:flutter/material.dart';
import 'package:mobile_apps/data/models/main/food/food_model.dart';
import 'package:mobile_apps/presentation/viewmodels/food/edit_food_provider.dart';
import 'package:mobile_apps/presentation/widgets/food_form_widget.dart';
import 'package:provider/provider.dart';

class EditFoodListScreen extends StatelessWidget {
  final FoodModel foodData;

  const EditFoodListScreen({super.key, required this.foodData});

  @override
  Widget build(BuildContext context) {
    return Consumer<EditFoodProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            title: Text(
              'Edit Data Makanan',
              style: Theme.of(
                context,
              ).textTheme.titleSmall!.copyWith(color: Colors.white),
            ),
          ),
          body: Stack(
            children: [
              FoodForm(
                initialData: foodData,
                isEdit: true,
                onSubmit: (updatedData) {
                  debugPrint(updatedData.toString());
                  provider.updateFood(
                    context,
                    foodData.idFood.toString(),
                    updatedData,
                  );
                },
              ),

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
    );
  }
}
