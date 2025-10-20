import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../../data/models/main/resto/resto_food_model.dart';
import '../../viewmodels/resto/update_food_place_viewmodel.dart';
import '../../../data/models/main/resto/create_food_place_request.dart';

class EditFoodPlaceScreen extends StatefulWidget {
  const EditFoodPlaceScreen({super.key});

  @override
  State<EditFoodPlaceScreen> createState() => _EditFoodPlaceScreenState();
}

class _EditFoodPlaceScreenState extends State<EditFoodPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _shopNameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _openHoursController;
  late TextEditingController _closeHoursController;
  late TextEditingController _priceRangeController;
  late TextEditingController _foodNameController;
  late TextEditingController _foodIdController;

  late RestoPlaceModel _initialData;
  bool _isDataInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isDataInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args == null || args is! RestoPlaceModel) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error: Data resto tidak ditemukan.")),
          );
        });
        return;
      }

      _initialData = args;
      final viewModel = context.read<UpdateFoodPlaceViewModel>();

      viewModel.setInitialImages(
        _initialData.images.map((img) => img.imageUrl).toList(),
      );

      _shopNameController = TextEditingController(text: _initialData.shopName);
      _addressController = TextEditingController(text: _initialData.address);
      _phoneController = TextEditingController(text: _initialData.phone);
      _openHoursController = TextEditingController(text: _initialData.openHours);
      _closeHoursController = TextEditingController(text: _initialData.closeHours);
      _priceRangeController = TextEditingController(text: _initialData.priceRange);
      _foodNameController = TextEditingController(text: _initialData.foodName);
      _foodIdController = TextEditingController(text: _initialData.foodId.toString());

      _isDataInitialized = true;
    }
  }

  Future<void> _pickImages(UpdateFoodPlaceViewModel viewModel) async {
    final List<XFile>? selectedImages =
    await _picker.pickMultiImage(imageQuality: 75);
    if (selectedImages != null && selectedImages.isNotEmpty) {
      viewModel.addNewImages(selectedImages.map((x) => File(x.path)).toList());
    }
  }

  Future<void> _updateImages(UpdateFoodPlaceViewModel viewModel) async {
    if (viewModel.newImages.isEmpty &&
        viewModel.existingImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tidak ada gambar untuk diupdate.")),
      );
      return;
    }

    await viewModel.updateFoodPlaceImages(_initialData.id);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Gambar berhasil diperbarui.")),
    );
  }

  void _submitUpdate(UpdateFoodPlaceViewModel viewModel) async {
    if (!_formKey.currentState!.validate()) return;

    final requestData = CreateFoodPlaceRequest(
      foodId: int.tryParse(_foodIdController.text),
      shopName: _shopNameController.text,
      address: _addressController.text,
      phone: _phoneController.text,
      openHours: _openHoursController.text,
      closeHours: _closeHoursController.text,
      priceRange: _priceRangeController.text,
      latitude: _initialData.latitude,
      longitude: _initialData.longitude,
      foodName: _foodNameController.text,
      images: viewModel.newImages,
    );

    await viewModel.updateFoodPlace(_initialData.id, requestData);

    if (viewModel.updatedFoodPlace != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
            Text("${viewModel.updatedFoodPlace!.shopName} berhasil diupdate!")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<UpdateFoodPlaceViewModel>();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (!_isDataInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Resto: ${_initialData.shopName}"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Gambar Restoran", style: textTheme.titleLarge),
              const SizedBox(height: 12),
              _buildImagePreview(viewModel),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _pickImages(viewModel),
                      icon: const Icon(Icons.add_photo_alternate),
                      label: const Text("Tambah Gambar"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: viewModel.isLoading
                          ? null
                          : () => _updateImages(viewModel),
                      icon: const Icon(Icons.update),
                      label: Text(viewModel.isLoading
                          ? "Mengupdate..."
                          : "Update Gambar"),
                    ),
                  ),
                ],
              ),

              const Divider(height: 40),
              _buildTextFields(textTheme, colorScheme),
              const SizedBox(height: 20),
              _buildSubmitButton(viewModel, colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview(UpdateFoodPlaceViewModel viewModel) {
    final colorScheme = Theme.of(context).colorScheme;
    final allImages = [
      ...viewModel.existingImages
          .map((url) => Image.network(url, fit: BoxFit.cover)),
      ...viewModel.newImages
          .map((file) => Image.file(file, fit: BoxFit.cover)),
    ];

    if (allImages.isEmpty) {
      return Container(
        height: 150,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(child: Text("Belum ada gambar")),
      );
    }

    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: allImages.length,
        itemBuilder: (context, index) {
          final isOld = index < viewModel.existingImages.length;
          return Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 8),
                width: 150,
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: allImages[index],
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: InkWell(
                  onTap: () => isOld
                      ? viewModel.removeExistingImage(index)
                      : viewModel.removeNewImage(
                      index - viewModel.existingImages.length),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black54,
                    ),
                    child: const Icon(Icons.close,
                        color: Colors.white, size: 18),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTextFields(TextTheme textTheme, ColorScheme colorScheme) {
    InputDecoration deco(String label) => InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      border: const OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide:
        BorderSide(color: colorScheme.primary, width: 2),
      ),
      filled: true,
      fillColor: colorScheme.surfaceContainerLow,
    );

    return Column(
      children: [
        TextFormField(controller: _shopNameController, decoration: deco("Nama Resto")),
        const SizedBox(height: 16),
        TextFormField(controller: _addressController, decoration: deco("Alamat")),
        const SizedBox(height: 16),
        TextFormField(controller: _phoneController, decoration: deco("Nomor Telepon")),
        const SizedBox(height: 16),
        TextFormField(controller: _openHoursController, decoration: deco("Jam Buka")),
        const SizedBox(height: 16),
        TextFormField(controller: _closeHoursController, decoration: deco("Jam Tutup")),
      ],
    );
  }

  Widget _buildSubmitButton(UpdateFoodPlaceViewModel viewModel, ColorScheme colorScheme) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: viewModel.isLoading ? null : () => _submitUpdate(viewModel),
        icon: viewModel.isLoading
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : const Icon(Icons.save),
        label: Text(viewModel.isLoading ? "Menyimpan..." : "Simpan Perubahan"),
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size(double.infinity, 56),
        ),
      ),
    );
  }
}
