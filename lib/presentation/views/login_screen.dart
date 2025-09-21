import 'package:flutter/material.dart';
import 'package:mobile_apps/core/utils/validator.dart';
import 'package:mobile_apps/presentation/static/navigation_route.dart';
import 'package:mobile_apps/presentation/styles/theme/jejak_rasa_theme.dart';
import 'package:mobile_apps/presentation/widgets/button_join_widget.dart';
import 'package:mobile_apps/presentation/widgets/button_navigate_widget.dart';
import 'package:mobile_apps/presentation/widgets/input_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
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
              vertical: 35,
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
                  Text(
                    "Mari memulai",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                        icon: "assets/images/google_icon.png",
                      ),
                      SizedBox(width: 25),
                      ButtonJoinWidget(
                        onTap: () {},
                        icon: "assets/images/facebook_icon.png",
                      ),
                      SizedBox(width: 25),
                      ButtonJoinWidget(
                        onTap: () {},
                        icon: "assets/images/twitter_icon.png",
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
                                color: Theme.of(context).colorScheme.onPrimary,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        InputWidget(
                          inputField: TextFormField(
                            controller: _passwordController,
                            obscureText: _isVisible,
                            cursorColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            validator: passConfirmValidator,
                            decoration: customInputDecoration(
                              context,
                              "Password",
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Theme.of(context).colorScheme.onPrimary,
                                size: 30,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isVisible = !_isVisible;
                                  });
                                },
                                icon: _isVisible
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
                            height: MediaQuery.of(context).size.height * 0.07,
                            onTap: () {
                              if (_formKey.currentState!.validate()) {}
                            },
                            title: "M A S U K",
                          ),
                        ),
                        SizedBox(height: 40),
                        
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
