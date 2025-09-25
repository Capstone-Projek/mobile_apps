import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_apps/presentation/viewmodels/main/camera/camera_provider.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                    onPressed: () {
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      scaffoldMessenger.showSnackBar(
                        SnackBar(content: Text("Feature under development 🙏")),
                      );
                    },
                    child: const Text("Analyze"),
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
