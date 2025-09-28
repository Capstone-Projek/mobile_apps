enum NavigationRoute {
  splashRoute("/"),
  welcomeRoute("/welcome"),
  loginRoute("/login"),
  registerRoute("/register"),
  mainRoute("/main"),
  changePasswordRoute("/changePassword"),
  editProfileRoute("/editProfile"),
  foodDetailRoute("/food-detail"),
  foodPlaceDetailRoute("/food-place-detail"),
  foodPlaceScreenRoute("/food-place");

  const NavigationRoute(this.path);
  final String path;
}
