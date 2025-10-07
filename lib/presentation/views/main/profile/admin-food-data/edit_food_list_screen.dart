import 'package:flutter/material.dart';
import 'package:mobile_apps/presentation/widgets/food_form_widget.dart';

class EditFoodListScreen extends StatelessWidget {
  final Map<String, dynamic> foodData;

  const EditFoodListScreen({super.key, required this.foodData});

  @override
  Widget build(BuildContext context) {
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
      body: FoodForm(
        initialData: foodData,
        onSubmit: (updatedData) {
          Navigator.pop(context, updatedData);
        },
      ),
    );
  }
}
