enum NavigationRoute {
  splashRoute("/"),
  welcomeRoute("/welcome"),
  mainRoute("main");

  const NavigationRoute(this.path);
  final String path;
}
