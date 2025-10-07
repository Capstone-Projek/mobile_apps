import 'package:flutter/material.dart';
import 'package:mobile_apps/core/service/api/api_service.dart';
import 'package:mobile_apps/core/service/workManager/workmanager_service.dart';
import 'package:mobile_apps/core/utils/validator.dart';
import 'package:mobile_apps/data/models/auth/login/user_login_request.dart';
import 'package:mobile_apps/presentation/static/auth/login_state/login_result_state.dart';
import 'package:mobile_apps/presentation/static/main/navigation_route.dart';
import 'package:mobile_apps/presentation/styles/color/jejak_rasa_color.dart';
import 'package:mobile_apps/presentation/styles/theme/jejak_rasa_theme.dart';
import 'package:mobile_apps/presentation/viewmodels/auth/login/login_provider.dart';
import 'package:mobile_apps/presentation/viewmodels/auth/user/shared_preferences_provider.dart';
import 'package:mobile_apps/presentation/widgets/button_join_widget.dart';
import 'package:mobile_apps/presentation/widgets/button_navigate_widget.dart';
import 'package:mobile_apps/presentation/widgets/input_widget.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginProvider(context.read<ApiService>()),
      child: const _BodyLoginScreen(),
    );
  }
}

class _BodyLoginScreen extends StatefulWidget {
  const _BodyLoginScreen();

  @override
  State<_BodyLoginScreen> createState() => __BodyLoginScreenState();
}

class __BodyLoginScreenState extends State<_BodyLoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoginProvider>();
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
                        "Mari memulai",
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Perjalanan kita akan sangat panjang",
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
                                validator: notEmptyValidator,
                                decoration: customInputDecoration(
                                  context,
                                  "email",
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
                                    context.read<LoginProvider>().loginUser(
                                      UserLoginRequest(
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text
                                            .trim(),
                                      ),
                                    );
                                  }
                                },
                                title: "M A S U K",
                              ),
                            ),
                            SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Tidak punya akun?",
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
                                      NavigationRoute.registerRoute.path,
                                    );
                                  },
                                  child: Text(
                                    " Daftar",
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

          Consumer<LoginProvider>(
            builder: (context, value, child) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (value.resultState is LoginResultErrorState) {
                  final message =
                      (value.resultState as LoginResultErrorState).error;
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Login gagal"),
                      content: Text(message),
                      actions: [
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: JejakRasaColor.secondary.color,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Kembali",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                  provider.resetState();
                } else if (value.resultState is LoginResultLoadedState) {
                  final data = (value.resultState as LoginResultLoadedState);
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Login Berhasil"),
                      content: Text(
                        "Selamat datang kembali ${data.dataUser.name}",
                      ),
                      actions: [
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: JejakRasaColor.secondary.color,
                            ),
                            onPressed: () async {
                              final sharedPreferencesProvider = context
                                  .read<SharedPreferencesProvider>();

                              await sharedPreferencesProvider.setShowEmail(
                                data.dataUser.email,
                              );
                              await sharedPreferencesProvider.setShowUsername(
                                data.dataUser.name,
                              );

                              await sharedPreferencesProvider.setAccessToken(
                                data.accessToken,
                              );
                              await sharedPreferencesProvider.setRefreshToken(
                                data.refreshToken,
                              );

                              // Mulai background refresh token
                              // final workmanagerService = WorkmanagerService();
                              // await workmanagerService.init();
                              // await workmanagerService.runPeriodicTask();
                              if (context.mounted) {
                                context
                                    .read<WorkmanagerService>()
                                    .runPeriodicTask();

                                Navigator.pop(context);
                                Navigator.pushReplacementNamed(
                                  context,
                                  NavigationRoute.mainRoute.path,
                                );
                              }
                            },
                            child: Text(
                              "M A S U K",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                  provider.resetState();
                }
              });

              // Loading indicator
              if (value.resultState is LoginResultLoadingState) {
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
