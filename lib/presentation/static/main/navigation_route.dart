enum NavigationRoute {
  splashRoute("/"),
  welcomeRoute("/welcome"),
  loginRoute("/login"),
  registerRoute("/register"),
  mainRoute("/main"),
  changePasswordRoute("/changePassword"),
  adminFoodList("/adminFoodList"),
  createAdminFoodList("/createAdminFoodList"),
  editAdminFoodList("/editAdminFoodList"),
  editProfileRoute("/editProfile"),
  foodDetailRoute("/food-detail"),
  foodPlaceDetailRoute("/food-place-detail"),
  foodPlaceScreenRoute("/food-place"),
  mapFoodPlaceRoute("/map-food-place"),
  editFoodPlaceRoute("/edit-food-place"),
  createFoodPlace("/create-food-place");


  const NavigationRoute(this.path);
  final String path;
}
