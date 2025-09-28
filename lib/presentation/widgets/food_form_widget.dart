import 'package:flutter/material.dart';
import 'package:mobile_apps/presentation/styles/color/jejak_rasa_color.dart';
import 'package:mobile_apps/presentation/widgets/custom_button.dart';
import 'package:mobile_apps/presentation/widgets/custom_dropdown_with_text_widget.dart';
import 'package:mobile_apps/presentation/widgets/custom_input_widget_with_text.dart';

class FoodForm extends StatefulWidget {
  final Map<String, dynamic>? initialData; // null = create, ada data = edit
  final void Function(Map<String, dynamic>) onSubmit;

  const FoodForm({super.key, this.initialData, required this.onSubmit});

  @override
  State<FoodForm> createState() => _FoodFormState();
}

class _FoodFormState extends State<FoodForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _foodNameController;
  late final TextEditingController _fromController;
  late final TextEditingController _descController;
  late final TextEditingController _historyController;
  late final TextEditingController _materialController;
  late final TextEditingController _recipesController;
  late final TextEditingController _timeCookController;
  late final TextEditingController _servingController;
  late final TextEditingController _videoUrlController;

  final List<String> _categories = ["Makanan Berat", "Makanan Ringan"];
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();

    _foodNameController = TextEditingController(
      text: widget.initialData?["food_name"] ?? "",
    );
    _fromController = TextEditingController(
      text: widget.initialData?["from"] ?? "",
    );
    _descController = TextEditingController(
      text: widget.initialData?["desc"] ?? "",
    );
    _historyController = TextEditingController(
      text: widget.initialData?["history"] ?? "",
    );
    _materialController = TextEditingController(
      text: widget.initialData?["material"] ?? "",
    );
    _recipesController = TextEditingController(
      text: widget.initialData?["recipes"] ?? "",
    );
    _timeCookController = TextEditingController(
      text: widget.initialData?["time_cook"] ?? "",
    );
    _servingController = TextEditingController(
      text: widget.initialData?["serving"] ?? "",
    );
    _videoUrlController = TextEditingController(
      text: widget.initialData?["vidio_url"] ?? "",
    );

    _selectedCategory = widget.initialData?["category"];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              CustomInputWidgetWithText(
                controller: _foodNameController,
                label: "Nama Makanan",
                hintText: "Masukkan nama makanan",
              ),
              const SizedBox(height: 12),
              CustomDropdownWithTextWidget(
                label: "Kategori",
                hintText: "Pilih kategori makanan",
                items: _categories,
                value: _selectedCategory,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              CustomInputWidgetWithText(
                controller: _fromController,
                label: "Asal Makanan",
                hintText: "Masukkan asal makanan",
              ),
              const SizedBox(height: 12),
              CustomInputWidgetWithText(
                controller: _descController,
                label: "Deskripsi",
                hintText: "Masukkan deskripsi makanan",
                maxLines: 4,
              ),
              const SizedBox(height: 12),
              CustomInputWidgetWithText(
                controller: _historyController,
                label: "Sejarah",
                hintText: "Masukkan sejarah makanan",
                maxLines: 4,
              ),
              const SizedBox(height: 12),
              CustomInputWidgetWithText(
                controller: _materialController,
                label: "Bahan",
                hintText: "Masukkan bahan makanan",
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              CustomInputWidgetWithText(
                controller: _recipesController,
                label: "Resep",
                hintText: "Masukkan resep makanan",
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              CustomInputWidgetWithText(
                controller: _timeCookController,
                label: "Waktu Memasak",
                hintText: "Contoh: 30 menit",
              ),
              const SizedBox(height: 12),
              CustomInputWidgetWithText(
                controller: _servingController,
                label: "Porsi",
                hintText: "Contoh: 2 orang",
              ),
              const SizedBox(height: 12),
              CustomInputWidgetWithText(
                controller: _videoUrlController,
                label: "Video URL",
                hintText: "Masukkan URL video",
              ),
              const SizedBox(height: 50),
              CustomButton(
                text: "Simpan",
                color: JejakRasaColor.secondary.color,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final foodData = {
                      "food_name": _foodNameController.text,
                      "category": _selectedCategory,
                      "from": _fromController.text,
                      "desc": _descController.text,
                      "history": _historyController.text,
                      "material": _materialController.text,
                      "recipes": _recipesController.text,
                      "time_cook": _timeCookController.text,
                      "serving": _servingController.text,
                      "vidio_url": _videoUrlController.text,
                    };
                    widget.onSubmit(foodData);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
