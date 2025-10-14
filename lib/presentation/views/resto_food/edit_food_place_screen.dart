import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart'; // Import Image Picker

// Ganti dengan path yang benar
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
  final ImagePicker _picker = ImagePicker(); // Inisialisasi Image Picker

  // Controllers
  late TextEditingController _shopNameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _openHoursController;
  late TextEditingController _closeHoursController;
  late TextEditingController _priceRangeController;
  late TextEditingController _foodNameController;
  late TextEditingController _foodIdController;

  // State untuk gambar baru
  List<File> _newImages = [];

  // Data awal dari arguments
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

      // Inisialisasi Controllers
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

  @override
  void dispose() {
    if (_isDataInitialized) {
      _shopNameController.dispose();
      _addressController.dispose();
      _phoneController.dispose();
      _openHoursController.dispose();
      _closeHoursController.dispose();
      _priceRangeController.dispose();
      _foodNameController.dispose();
      _foodIdController.dispose();
    }
    super.dispose();
  }

  // --- IMAGE PICKER FUNCTION ---
  Future<void> _pickImages() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage(
      imageQuality: 75, // Kualitas gambar
    );

    if (selectedImages != null && selectedImages.isNotEmpty) {
      setState(() {
        // Konversi XFile ke File dan simpan ke state
        _newImages = selectedImages.map((xFile) => File(xFile.path)).toList();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${_newImages.length} gambar terpilih.")),
      );
    }
  }

  // --- SUBMIT FUNCTION ---
  void _submitUpdate(UpdateFoodPlaceViewModel viewModel) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

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
      images: _newImages.isNotEmpty ? _newImages : null,
    );

    await viewModel.updateFoodPlace(_initialData.id, requestData);

    if (viewModel.updatedFoodPlace != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${viewModel.updatedFoodPlace!.shopName} berhasil diupdate!")),
      );
      Navigator.pop(context);
    }
  }

  // Helper untuk MD3 InputDecoration
  InputDecoration _md3InputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      filled: true,
      fillColor: Theme.of(context).colorScheme.surfaceContainerLow,
      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
    );
  }

  // Helper untuk spacing
  Widget _buildFormSpacer() => const SizedBox(height: 16);

  @override
  Widget build(BuildContext context) {
    if (!_isDataInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final viewModel = context.watch<UpdateFoodPlaceViewModel>();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Resto: ${_initialData.shopName}"),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 1, // Sedikit shadow untuk AppBar MD3
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0), // Padding lebih besar
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ID Resto: ${_initialData.id}",
                style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
              const Divider(height: 32),

              // --- INFORMASI GAMBAR ---
              Text(
                "Gambar:",
                style: textTheme.titleMedium?.copyWith(color: colorScheme.primary),
              ),
              const SizedBox(height: 16),

              // Tampilan Gambar Saat Ini / Gambar Baru
              _buildImagePreview(context),

              const SizedBox(height: 24),
              Center(
                child: FilledButton.icon(
                  onPressed: _pickImages,
                  icon: const Icon(Icons.photo_library),
                  label: Text(_newImages.isEmpty ? "Pilih Gambar Baru (Galeri)" : "Ubah/Tambah ${_newImages.length} Gambar"),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: textTheme.labelLarge,
                  ),
                ),
              ),
              const Divider(height: 48),

              // --- FORM FIELDS UTAMA ---
              Text("Detail Restoran", style: textTheme.titleLarge),
              _buildFormSpacer(),

              TextFormField(
                controller: _shopNameController,
                decoration: _md3InputDecoration("Nama Toko (Wajib)"),
                validator: (value) => value!.isEmpty ? 'Nama toko tidak boleh kosong' : null,
              ),
              _buildFormSpacer(),

              TextFormField(
                controller: _foodNameController,
                decoration: _md3InputDecoration("Nama Makanan/Menu"),
              ),
              _buildFormSpacer(),

              TextFormField(
                controller: _priceRangeController,
                decoration: _md3InputDecoration("Rentang Harga (Rp)"),
              ),
              _buildFormSpacer(),

              TextFormField(
                controller: _addressController,
                decoration: _md3InputDecoration("Alamat"),
                maxLines: 3,
              ),
              _buildFormSpacer(),

              TextFormField(
                controller: _phoneController,
                decoration: _md3InputDecoration("Nomor Telepon"),
                keyboardType: TextInputType.phone,
              ),
              _buildFormSpacer(),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _openHoursController,
                      decoration: _md3InputDecoration("Jam Buka (contoh: 09:00)"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _closeHoursController,
                      decoration: _md3InputDecoration("Jam Tutup (contoh: 21:00)"),
                    ),
                  ),
                ],
              ),
              _buildFormSpacer(),

              // Field Food ID
              TextFormField(
                controller: _foodIdController,
                decoration: _md3InputDecoration("Food ID (Jika ada)"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 40),

              // TOMBOL SIMPAN
              Center(
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
                    textStyle: textTheme.titleMedium,
                  ),
                ),
              ),

              // Tampilkan pesan error jika ada
              if (viewModel.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    "Error: ${viewModel.errorMessage}",
                    style: textTheme.bodyLarge?.copyWith(color: colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk menampilkan gambar saat ini atau yang baru dipilih
  Widget _buildImagePreview(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_newImages.isNotEmpty) {
      // Tampilkan gambar baru yang dipilih (Horizontal List)
      return SizedBox(
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _newImages.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  _newImages[index],
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      );
    } else if (_initialData.images != null) {
      // Tampilkan gambar lama
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          _initialData.images!.imageUrl,
          height: 150,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            height: 150,
            color: colorScheme.surfaceContainerLow,
            child: Center(child: Icon(Icons.broken_image, color: colorScheme.error)),
          ),
        ),
      );
    } else {
      // Tidak ada gambar
      return Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Icon(Icons.image_not_supported, size: 40, color: colorScheme.onSurfaceVariant),
        ),
      );
    }
  }
}