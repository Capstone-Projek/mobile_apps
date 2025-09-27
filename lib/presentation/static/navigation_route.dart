enum NavigationRoute {
  splashRoute("/"),
  welcomeRoute("/welcome"),
  loginRoute("/login"),
  registerRoute("/register"),
  mainRoute("/main"),
  changePasswordRoute("/changePassword"),
  editProfileRoute("/editProfile");

  const NavigationRoute(this.path);
  final String path;
}
