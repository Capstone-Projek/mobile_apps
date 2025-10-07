import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mobile_apps/data/models/main/home/carousel_item_model.dart';
import 'package:mobile_apps/data/models/main/home/food_list_response_models.dart';
import 'package:mobile_apps/data/models/main/home/recomendation_food_model.dart';
import 'package:mobile_apps/presentation/styles/color/jejak_rasa_color.dart';
import 'package:mobile_apps/presentation/styles/theme/jejak_rasa_theme.dart';
import 'package:mobile_apps/presentation/viewmodels/main/beranda/home_provider.dart';
import 'package:mobile_apps/presentation/widgets/button_filter_widget.dart';
import 'package:mobile_apps/presentation/widgets/recommendation_food_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BodyOfHomeScreen extends StatefulWidget {
  final List<FoodListResponseModel> foodList;
  final TextEditingController searchController;

  const BodyOfHomeScreen({
    super.key,
    required this.foodList,
    required this.searchController,
  });

  @override
  State<BodyOfHomeScreen> createState() => _BodyOfHomeScreenState();
}

class _BodyOfHomeScreenState extends State<BodyOfHomeScreen> {
  int activeIndex = 0;

  final List<CarouselItemModel> items = [
    CarouselItemModel(
      image: 'assets/images/welcome_screen_2_background.jpg',
      name: "Warung Bu Dharmi",
      address: "Jalan Ahmad Yani",
    ),
    CarouselItemModel(
      image: 'assets/images/welcome_screen_1_background.jpeg',
      name: "Warung Pak Budi",
      address: "Jalan Sudirman",
    ),
  ];
  final List<RecomendationFoodModel> recomendations = [
    RecomendationFoodModel(
      image: 'assets/images/welcome_screen_1_background.jpeg',
      tittle: "Siomay Bangka Balibul",
      description:
          "Warung siomay Bangka balibul enak pol saestu mboten ngapusi",
    ),
    RecomendationFoodModel(
      image: 'assets/images/welcome_screen_1_background.jpeg',
      tittle: "Siomay Bangka Balibul",
      description:
          "Warung siomay Bangka balibul enak pol saestu mboten ngapusi",
    ),
    RecomendationFoodModel(
      image: 'assets/images/welcome_screen_1_background.jpeg',
      tittle: "Siomay Bangka Balibul",
      description:
          "Warung siomay Bangka balibul enak pol saestu mboten ngapusi",
    ),
    RecomendationFoodModel(
      image: 'assets/images/welcome_screen_1_background.jpeg',
      tittle: "Siomay Bangka Balibul",
      description:
          "Warung siomay Bangka balibul enak pol saestu mboten ngapusi",
    ),
    RecomendationFoodModel(
      image: 'assets/images/welcome_screen_1_background.jpeg',
      tittle: "Siomay Bangka Balibul",
      description:
          "Warung siomay Bangka balibul enak pol saestu mboten ngapusi",
    ),
    RecomendationFoodModel(
      image: 'assets/images/welcome_screen_1_background.jpeg',
      tittle: "Siomay Bangka Balibul",
      description:
          "Warung siomay Bangka balibul enak pol saestu mboten ngapusi",
    ),
  ];

  Widget buildImage(CarouselItemModel item) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(item.image, fit: BoxFit.cover),
        Container(color: Colors.black.withOpacity(0.3)),
        Positioned(
          left: JejakRasaTheme.defaultPadding,
          bottom: 36,
          child: InkWell(
            onTap: () {},
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: JejakRasaColor.primary.color,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.address,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: JejakRasaColor.primary.color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildIndicator() => Center(
    child: AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: items.length,
      effect: SlideEffect(
        dotWidth: 15,
        dotHeight: 15,
        activeDotColor: Theme.of(context).colorScheme.secondary,
        dotColor: Theme.of(context).colorScheme.onSecondary,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 230,
                child: CarouselSlider.builder(
                  itemCount: items.length,
                  options: CarouselOptions(
                    height: 230,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 4),
                    viewportFraction: 1,
                    enableInfiniteScroll: true,
                    enlargeCenterPage: false,
                    onPageChanged: (index, reason) =>
                        setState(() => activeIndex = index),
                  ),
                  itemBuilder: (context, index, realIndex) {
                    return buildImage(items[index]);
                  },
                ),
              ),
              Container(
                width: double.infinity,
                height: 30,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              SizedBox(height: 53),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: JejakRasaTheme.defaultPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ButtonFilterWidget(
                      width: MediaQuery.of(context).size.width / 4 - 24,
                      icon: "assets/icons/makan_berat_filter_icon.png",
                      title: "Makan\nBerat",
                      onTap: () {},
                    ),
                    ButtonFilterWidget(
                      width: MediaQuery.of(context).size.width / 4 - 24,
                      icon: "assets/icons/makanan_ringan_filter_icon.png",
                      title: "Makan\nRingan",
                      onTap: () {},
                    ),
                    ButtonFilterWidget(
                      width: MediaQuery.of(context).size.width / 4 - 24,
                      icon: "assets/icons/minuman_filter_icon.png",
                      title: "Minuman",
                      onTap: () {},
                    ),
                    ButtonFilterWidget(
                      width: MediaQuery.of(context).size.width / 4 - 24,
                      icon: "assets/icons/snack_filter_icon.png",
                      title: "Snack",
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                  horizontal: JejakRasaTheme.defaultPadding,
                ),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 230,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 3 / 4.2,
                ),
                itemCount: widget.foodList.length,
                itemBuilder: (context, index) {
                  final item = widget.foodList[index];
                  return RecommendationFoodWidget(
                    recomendationFoodModel: item,
                    onTap: () {
                      Navigator.pushNamed(context, '/food-detail');
                    },
                  );
                },
              ),
              SizedBox(height: 40),
            ],
          ),
          Positioned(
            left: JejakRasaTheme.defaultPadding,
            right: JejakRasaTheme.defaultPadding,
            top: 200,
            child: buildIndicator(),
          ),
          Positioned(
            left: JejakRasaTheme.defaultPadding,
            right: JejakRasaTheme.defaultPadding,
            top: 236,
            child: SizedBox(
              height: 50,
              child: TextField(
                controller: widget.searchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.onSecondary,
                  hintText: "Cari makanan pilihan mu",
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: JejakRasaColor.primary.color,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 25,
                    color: Colors.white,
                  ),

                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: JejakRasaColor.tersier.color,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: JejakRasaColor.tersier.color,
                      width: 2,
                    ),
                  ),
                ),
                onSubmitted: (value) {
                  // if (value.isNotEmpty) {
                  //   context.read<RestaurantListProvider>().searchRestaurantList(
                  //     value,
                  //   );
                  // } else {
                  //   context
                  //       .read<RestaurantListProvider>()
                  //       .fetchRestaurantList();
                  // }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
