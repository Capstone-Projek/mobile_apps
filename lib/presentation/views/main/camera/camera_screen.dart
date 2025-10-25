import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_apps/data/models/main/camera/upload_response.dart';
import 'package:mobile_apps/presentation/styles/color/jejak_rasa_color.dart';
import 'package:mobile_apps/presentation/viewmodels/auth/user/shared_preferences_provider.dart';
import 'package:mobile_apps/presentation/viewmodels/main/camera/camera_provider.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  void initState() {
    super.initState();

    final cameraProvider = context.read<CameraProvider>();

    cameraProvider.addListener(() {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final message = cameraProvider.message;

      if (message != null) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(
              message,
              style: TextStyle(color: JejakRasaColor.secondary.color),
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sharedProvider = context.read<SharedPreferencesProvider>();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 4,
            children: [
              Expanded(
                child: Consumer<CameraProvider>(
                  builder: (context, value, child) {
                    final imagePath = value.imagePath;
                    return imagePath == null
                        ? const Align(
                            alignment: Alignment.center,
                            child: Icon(Icons.image, size: 100),
                          )
                        : Image.file(File(imagePath.toString()));
                  },
                ),
              ),
              Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Consumer<CameraProvider>(
                    builder: (context, value, child) {
                      final uploadResponse = value.uploadResponse;
                      if (uploadResponse == null) {
                        return const SizedBox.shrink();
                      }

                      // Format foodName: huruf pertama kapital, sisanya kecil
                      final formattedFoodName =
                          uploadResponse.prediction.isNotEmpty
                          ? uploadResponse.prediction[0].toUpperCase() +
                                uploadResponse.prediction
                                    .substring(1)
                                    .toLowerCase()
                          : uploadResponse.prediction;

                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Hasil Analisis",
                                style: Theme.of(context).textTheme.titleMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                              ),
                              const SizedBox(height: 8),

                              // Nama makanan
                              Text(
                                formattedFoodName,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                      color: JejakRasaColor.tersier.color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 6),

                              // Confidence
                              Text(
                                "Confidence: ${uploadResponse.confidence.toStringAsFixed(2)}%",
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(color: Colors.grey[700]),
                              ),
                              const SizedBox(height: 16),

                              // Tombol detail
                              ElevatedButton.icon(
                                icon: const Icon(Icons.info_outline),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      JejakRasaColor.secondary.color,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () =>
                                    context.read<CameraProvider>().detailScreen(
                                      context,
                                      sharedProvider.accessToken!,
                                      uploadResponse.prediction,
                                    ),
                                label: const Text("Lihat Detail Makanan"),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  Row(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.secondary,
                        ),
                        onPressed: () =>
                            context.read<CameraProvider>().openGallery(),
                        child: const Text("Gallery"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.secondary,
                        ),
                        onPressed: () =>
                            context.read<CameraProvider>().openCamera(),
                        child: const Text("Camera"),
                      ),
                    ],
                  ),
                  FilledButton.tonal(
                    onPressed: () => context.read<CameraProvider>().upload(),
                    child: Consumer<CameraProvider>(
                      builder: (context, value, child) {
                        if (value.isUploading) {
                          return Center(child: CircularProgressIndicator());
                        }

                        return const Text("Analyze");
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
