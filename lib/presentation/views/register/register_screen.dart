import 'package:flutter/material.dart';
import 'package:mobile_apps/core/service/api/api_service.dart';
import 'package:mobile_apps/core/utils/validator.dart';
import 'package:mobile_apps/data/models/auth/register/user_register_request.dart';
import 'package:mobile_apps/presentation/static/main/navigation_route.dart';
import 'package:mobile_apps/presentation/static/auth/register_state/register_result_state.dart';
import 'package:mobile_apps/presentation/styles/color/jejak_rasa_color.dart';
import 'package:mobile_apps/presentation/styles/theme/jejak_rasa_theme.dart';
import 'package:mobile_apps/presentation/viewmodels/auth/register/register_provider.dart';
import 'package:mobile_apps/presentation/widgets/button_join_widget.dart';
import 'package:mobile_apps/presentation/widgets/input_widget.dart';
import 'package:mobile_apps/presentation/widgets/button_navigate_widget.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RegisterProvider(context.read<ApiService>()),
      child: const _BodyRegisterScreen(),
    );
  }
}

class _BodyRegisterScreen extends StatefulWidget {
  const _BodyRegisterScreen();

  @override
  State<_BodyRegisterScreen> createState() => _BodyRegisterScreenState();
}

class _BodyRegisterScreenState extends State<_BodyRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RegisterProvider>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 110),
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: JejakRasaTheme.defaultPadding,
                  vertical: 25,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        "Bergabunglah Sekarang",
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Mari memulai perjalanan bersama",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ButtonJoinWidget(
                            onTap: () {},
                            icon: "assets/icons/google_icon.png",
                          ),
                          SizedBox(width: 25),
                          ButtonJoinWidget(
                            onTap: () {},
                            icon: "assets/icons/facebook_icon.png",
                          ),
                          SizedBox(width: 25),
                          ButtonJoinWidget(
                            onTap: () {},
                            icon: "assets/icons/twitter_icon.png",
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            InputWidget(
                              inputField: TextFormField(
                                controller: _emailController,
                                cursorColor: Theme.of(
                                  context,
                                ).colorScheme.onPrimary,
                                validator: emailValidator,
                                decoration: customInputDecoration(
                                  context,
                                  "Email",
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            InputWidget(
                              inputField: TextFormField(
                                controller: _usernameController,
                                cursorColor: Theme.of(
                                  context,
                                ).colorScheme.onPrimary,
                                validator: notEmptyValidator,
                                decoration: customInputDecoration(
                                  context,
                                  "Username",
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            InputWidget(
                              inputField: TextFormField(
                                controller: _passwordController,
                                obscureText: !provider.isPasswordVisible,
                                cursorColor: Theme.of(
                                  context,
                                ).colorScheme.onPrimary,
                                validator: passConfirmValidator,
                                decoration: customInputDecoration(
                                  context,
                                  "Password",
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                    size: 30,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      provider.togglePasswordVisibility();
                                    },
                                    icon: provider.isPasswordVisible
                                        ? const Icon(Icons.visibility)
                                        : const Icon(Icons.visibility_off),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 50),
                            Center(
                              child: ButtonNavigateWidget(
                                width: MediaQuery.of(context).size.width * 0.6,
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    context
                                        .read<RegisterProvider>()
                                        .registerUser(
                                          UserRegisterRequest(
                                            name: _usernameController.text
                                                .trim(),
                                            email: _emailController.text.trim(),
                                            password: _passwordController.text
                                                .trim(),
                                          ),
                                        );
                                  }
                                },
                                title: "D A F T A R",
                              ),
                            ),
                            SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Sudah punya akun?",
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimary,
                                      ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      NavigationRoute.loginRoute.path,
                                    );
                                  },
                                  child: Text(
                                    " Masuk",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Consumer<RegisterProvider>(
            builder: (context, value, child) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (value.resultState is RegisterResultErrorState) {
                  final message =
                      (value.resultState as RegisterResultErrorState).error;

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.redAccent,
                              size: 60,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Register Gagal",
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              message,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: JejakRasaColor.primary.color,
                                  ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      JejakRasaColor.secondary.color,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Kembali",
                                  style: Theme.of(context).textTheme.labelLarge
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.1,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );

                  provider.resetState();
                } else if (value.resultState is RegisterResultLoadedState) {
                  final data =
                      (value.resultState as RegisterResultLoadedState).data;

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              color: Colors.greenAccent,
                              size: 60,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Register Berhasil",
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: JejakRasaColor.secondary.color,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Akun dengan email ${data.email} berhasil dibuat.",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: JejakRasaColor.primary.color,
                                  ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      JejakRasaColor.secondary.color,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushReplacementNamed(
                                    context,
                                    NavigationRoute.loginRoute.path,
                                  );
                                },
                                child: Text(
                                  "L O G I N",
                                  style: Theme.of(context).textTheme.labelLarge
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.1,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );

                  provider.resetState();
                }
              });

              // Loading indicator
              if (value.resultState is RegisterResultLoadingState) {
                return Container(
                  color: Colors.black26,
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              return const SizedBox.shrink(); // Jika tidak loading, tidak tampilkan apa-apa
            },
          ),
          
        ],
      ),
    );
  }
}
