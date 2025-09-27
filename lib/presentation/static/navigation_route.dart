enum NavigationRoute {
  splashRoute("/"),
  welcomeRoute("/welcome"),
  loginRoute("/login"),
  registerRoute("/register"),
  mainRoute("/main"),
  changePasswordRoute("/changePassword");

  const NavigationRoute(this.path);
  final String path;
}
