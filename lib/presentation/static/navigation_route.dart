enum NavigationRoute {
  splashRoute("/"),
  welcomeRoute("/welcome"),
  loginRoute("/login"),
  registerRoute("/register"),
  mainRoute("/main");

  const NavigationRoute(this.path);
  final String path;
}
