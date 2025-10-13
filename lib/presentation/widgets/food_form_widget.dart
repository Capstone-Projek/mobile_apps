import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_apps/data/models/main/food/food_model.dart';
import 'package:mobile_apps/presentation/styles/color/jejak_rasa_color.dart';
import 'package:mobile_apps/presentation/widgets/custom_button.dart';
import 'package:mobile_apps/presentation/widgets/custom_dropdown_with_text_widget.dart';
import 'package:mobile_apps/presentation/widgets/custom_input_widget_with_text.dart';

class FoodForm extends StatefulWidget {
  final FoodModel? initialData;
  final void Function(Map<String, dynamic>) onSubmit;
  final bool isEdit;

  const FoodForm({
    super.key,
    this.initialData,
    required this.onSubmit,
    this.isEdit = false,
  });

  @override
  State<FoodForm> createState() => _FoodFormState();
}

class _FoodFormState extends State<FoodForm> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  late final TextEditingController _foodNameController;
  late final TextEditingController _fromController;
  late final TextEditingController _descController;
  late final TextEditingController _historyController;
  late final TextEditingController _materialController;
  late final TextEditingController _recipesController;
  late final TextEditingController _timeCookController;
  late final TextEditingController _servingController;
  late final TextEditingController _videoUrlController;

  final List<String> _categories = [
    "Makanan Berat",
    "Makanan Ringan",
    "Makanan Berkuah",
    "Makanan Penutup",
    "Minuman",
  ];
  String? _selectedCategory;

  // Untuk menyimpan gambar yang dipilih
  List<XFile> _selectedImages = [];
  // Untuk menyimpan URL gambar existing (saat edit)
  List<String> _existingImageUrls = [];

  @override
  void initState() {
    super.initState();

    _foodNameController = TextEditingController(
      text: widget.initialData?.foodName ?? "",
    );
    _fromController = TextEditingController(
      text: widget.initialData?.from ?? "",
    );
    _descController = TextEditingController(
      text: widget.initialData?.desc ?? "",
    );
    _historyController = TextEditingController(
      text: widget.initialData?.history ?? "",
    );
    _materialController = TextEditingController(
      text: widget.initialData?.material ?? "",
    );
    _recipesController = TextEditingController(
      text: widget.initialData?.recipes ?? "",
    );
    _timeCookController = TextEditingController(
      text: widget.initialData?.timeCook ?? "",
    );
    _servingController = TextEditingController(
      text: widget.initialData?.serving ?? "",
    );
    _videoUrlController = TextEditingController(
      text: widget.initialData?.vidioUrl ?? "",
    );

    _selectedCategory = widget.initialData?.category;

    // Load existing images jika edit mode
    if (widget.initialData?.images != null) {
      _existingImageUrls = widget.initialData!.images
          .map((img) => img.imageUrl)
          .where((url) => url.isNotEmpty)
          .toList();
    }
  }

  @override
  void dispose() {
    _foodNameController.dispose();
    _fromController.dispose();
    _descController.dispose();
    _historyController.dispose();
    _materialController.dispose();
    _recipesController.dispose();
    _timeCookController.dispose();
    _servingController.dispose();
    _videoUrlController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(images);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error memilih gambar: $e')));
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _removeExistingImage(int index) {
    setState(() {
      _existingImageUrls.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nama Makanan (Required)
              CustomInputWidgetWithText(
                controller: _foodNameController,
                label: "Nama Makanan *",
                hintText: "Masukkan nama makanan",
              ),
              const SizedBox(height: 12),

              // Kategori (Optional)
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

              // Asal Makanan (Optional)
              CustomInputWidgetWithText(
                controller: _fromController,
                label: "Asal Makanan",
                hintText: "Masukkan asal makanan",
              ),
              const SizedBox(height: 12),

              // Deskripsi (Optional)
              CustomInputWidgetWithText(
                controller: _descController,
                label: "Deskripsi",
                hintText: "Masukkan deskripsi makanan",
                maxLines: 4,
              ),
              const SizedBox(height: 12),

              // Sejarah (Optional)
              CustomInputWidgetWithText(
                controller: _historyController,
                label: "Sejarah",
                hintText: "Masukkan sejarah makanan",
                maxLines: 4,
              ),
              const SizedBox(height: 12),

              // Bahan (Optional)
              CustomInputWidgetWithText(
                controller: _materialController,
                label: "Bahan",
                hintText: "Contoh: Daging sapi, tepung, gula",
                maxLines: 3,
              ),
              const SizedBox(height: 12),

              // Resep (Optional)
              CustomInputWidgetWithText(
                controller: _recipesController,
                label: "Resep",
                hintText: "Contoh: Rebus daging, uleg, aduk",
                maxLines: 3,
              ),
              const SizedBox(height: 12),

              // Waktu Memasak (Optional)
              CustomInputWidgetWithText(
                controller: _timeCookController,
                label: "Waktu Memasak",
                hintText: "Contoh: 45 menit",
              ),
              const SizedBox(height: 12),

              // Porsi (Optional)
              CustomInputWidgetWithText(
                controller: _servingController,
                label: "Porsi",
                hintText: "Contoh: 1 mangkok",
              ),
              const SizedBox(height: 12),

              // Video URL (Optional)
              CustomInputWidgetWithText(
                controller: _videoUrlController,
                label: "Video URL",
                hintText: "Masukkan URL video (opsional)",
              ),
              const SizedBox(height: 12),

              // Upload Images Section
              if (!widget.isEdit) ...[
                Text(
                  "Gambar Makanan",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),

                // Existing Images (Edit mode)
                if (_existingImageUrls.isNotEmpty) ...[
                  Text(
                    "Gambar Saat Ini:",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(
                      _existingImageUrls.length,
                      (index) => Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              _existingImageUrls[index],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.broken_image),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => _removeExistingImage(index),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // New Selected Images
                if (_selectedImages.isNotEmpty) ...[
                  Text(
                    "Gambar Baru:",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(
                      _selectedImages.length,
                      (index) => Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(_selectedImages[index].path),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Button to add images
                OutlinedButton.icon(
                  onPressed: _pickImages,
                  icon: const Icon(Icons.add_photo_alternate),
                  label: const Text("Tambah Gambar"),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    side: BorderSide(color: JejakRasaColor.secondary.color),
                    foregroundColor: JejakRasaColor.secondary.color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "* Gambar bersifat opsional. Anda dapat menambahkan beberapa gambar.",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],

              const SizedBox(height: 50),

              // Submit Button
              CustomButton(
                text: widget.isEdit ? "Update" : "Simpan",
                color: JejakRasaColor.secondary.color,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final foodData = {
                      "food_name": _foodNameController.text.trim(),
                      "category": _selectedCategory,
                      "from": _fromController.text.trim(),
                      "desc": _descController.text.trim(),
                      "history": _historyController.text.trim(),
                      "material": _materialController.text.trim(),
                      "recipes": _recipesController.text.trim(),
                      "time_cook": _timeCookController.text.trim(),
                      "serving": _servingController.text.trim(),
                      "vidio_url": _videoUrlController.text.trim(),
                      "images": _selectedImages,
                      "existing_images": _existingImageUrls,
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
