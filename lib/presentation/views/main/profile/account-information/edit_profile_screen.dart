import 'package:flutter/material.dart';
import 'package:mobile_apps/data/models/main/profile/change_profile_request.dart';
import 'package:mobile_apps/presentation/static/main/navigation_route.dart';
import 'package:mobile_apps/presentation/static/profile/change_profile_result_state.dart';
import 'package:mobile_apps/presentation/styles/color/jejak_rasa_color.dart';
import 'package:mobile_apps/presentation/viewmodels/profile/change_profile_provider.dart';
import 'package:mobile_apps/presentation/widgets/custom_button.dart';
import 'package:mobile_apps/presentation/widgets/custom_input_widget_with_text.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          'Ubah Profil',
          style: Theme.of(
            context,
          ).textTheme.titleSmall!.copyWith(color: Colors.white),
        ),
      ),
      body: Consumer<ChangeProfileProvider>(
        builder: (context, provider, child) {
          final state = provider.resultState;

          // Jika loading, tampilkan indikator
          if (state is ChangeProfileResultLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          // Jika berhasil ubah profil
          if (state is ChangeProfileResultLoadedState) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('MY_SHOW_USERNAME', state.data.name);
              await prefs.setString('MY_SHOW_EMAIL', state.data.email);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pushNamed(context, NavigationRoute.mainRoute.path);
                context.read<ChangeProfileProvider>().resetState();
              }
            });
          }

          // Jika error
          if (state is ChangeProfileResultErrorState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error)));
            });
          }

          // Form utama
          return Center(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    CustomInputWidgetWithText(
                      label: "Nama",
                      hintText: "Masukkan nama Anda",
                      controller: _nameController,
                    ),
                    const SizedBox(height: 12),
                    CustomInputWidgetWithText(
                      label: "Email",
                      hintText: "Masukkan email Anda",
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 50),
                    CustomButton(
                      text: "Simpan",
                      color: JejakRasaColor.secondary.color,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_nameController.text.isNotEmpty &&
                              _emailController.text.isNotEmpty) {
                            context.read<ChangeProfileProvider>().changeProfile(
                              ChangeProfileRequest(
                                email: _emailController.text.trim(),
                                name: _nameController.text.trim(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Semua field harus diisi"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
  }
}
