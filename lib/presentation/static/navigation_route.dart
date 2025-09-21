enum NavigationRoute {
  splashRoute("/"),
  welcomeRoute("/welcome"),
  loginRoute("/login"),
  mainRoute("/main");

  const NavigationRoute(this.path);
  final String path;
}
