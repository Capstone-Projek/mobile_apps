import 'package:flutter/material.dart';
import 'package:mobile_apps/presentation/widgets/food_form_widget.dart';

class CreateFoodListScreen extends StatelessWidget {
  const CreateFoodListScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: FoodForm(
        onSubmit: (newData) {
          Navigator.pop(context, newData);
        },
      ),
    );
  }
}
