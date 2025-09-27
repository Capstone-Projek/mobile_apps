import 'package:flutter/material.dart';
import 'package:mobile_apps/presentation/styles/color/jejak_rasa_color.dart';
import 'package:mobile_apps/presentation/widgets/custom_button.dart';
import 'package:mobile_apps/presentation/widgets/custom_input_widget_with_text.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _validatePasswords(BuildContext context) {
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password dan konfirmasi password tidak boleh kosong"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password dan konfirmasi password tidak sama"),
          backgroundColor: JejakRasaColor.error.color,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Lanjut ke aksi simpan / API call
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          'Ubah Password',
          style: Theme.of(
            context,
          ).textTheme.titleSmall!.copyWith(color: Colors.white),
        ),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CustomInputWidgetWithText(
                  label: "Password",
                  hintText: "Masukkan password",
                  obscureText: true,
                  showTogglePassword: true,
                  controller: _passwordController,
                ),

                const SizedBox(height: 12),

                CustomInputWidgetWithText(
                  label: "Konfirmasi Password",
                  hintText: "Masukkan konfirmasi password",
                  obscureText: true,
                  showTogglePassword: true,
                  controller: _confirmPasswordController,
                ),

                const SizedBox(height: 50),

                CustomButton(
                  text: "Simpan",
                  color: JejakRasaColor.secondary.color,
                  onPressed: () {
                    _validatePasswords(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
