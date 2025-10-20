import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mobile_apps/data/models/main/home/food_list_response_models.dart';
import 'package:mobile_apps/data/models/main/home/resto_list_response_models.dart';
import 'package:mobile_apps/presentation/static/main/beranda/search_food_result_state.dart';
import 'package:mobile_apps/presentation/styles/color/jejak_rasa_color.dart';
import 'package:mobile_apps/presentation/styles/theme/jejak_rasa_theme.dart';
import 'package:mobile_apps/presentation/viewmodels/auth/user/shared_preferences_provider.dart';
import 'package:mobile_apps/presentation/viewmodels/main/beranda/home_provider.dart';
import 'package:mobile_apps/presentation/widgets/button_filter_widget.dart';
import 'package:mobile_apps/presentation/widgets/recommendation_food_widget.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BodyOfHomeScreen extends StatefulWidget {
  final List<FoodListResponseModel> foodList;
  final TextEditingController searchController;
  final List<RestoListResponseModels> restoList;

  const BodyOfHomeScreen({
    super.key,
    required this.foodList,
    required this.searchController,
    required this.restoList,
  });

  @override
  State<BodyOfHomeScreen> createState() => _BodyOfHomeScreenState();
}

class _BodyOfHomeScreenState extends State<BodyOfHomeScreen> {
  Widget buildImage(RestoListResponseModels item) {
    final hasImage = item.images != null && item.images!.isNotEmpty;
    final imageUrl = hasImage ? item.images!.first.imageUrl : null;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (imageUrl != null && imageUrl.isNotEmpty)
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                  size: 64,
                ),
              );
            },
          )
        else
          const Center(child: Icon(Icons.image, color: Colors.grey, size: 64)),
        Container(color: Colors.black.withValues(alpha: 0.3)),
        Positioned(
          left: JejakRasaTheme.defaultPadding,
          right: JejakRasaTheme.defaultPadding,
          bottom: 46,
          child: InkWell(
            onTap: () {},
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.food!.foodName ?? "-",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: JejakRasaColor.primary.color,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          item.address ?? "-",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: JejakRasaColor.primary.color),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
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

  Widget buildIndicator(BuildContext context) => Consumer<HomeProvider>(
    builder: (context, value, child) {
      return Center(
        child: AnimatedSmoothIndicator(
          activeIndex: value.carouselActiveIndex,
          count: (widget.restoList.length > 10 ? 10 : widget.restoList.length),
          effect: SlideEffect(
            dotWidth: 15,
            dotHeight: 15,
            activeDotColor: Theme.of(context).colorScheme.secondary,
            dotColor: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    final sharedProvider = context.read<SharedPreferencesProvider>();
    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 230,
                child: Builder(
                  builder: (context) {
                    final limitedList = widget.restoList.take(10).toList();

                    return CarouselSlider.builder(
                      itemCount: limitedList.length,
                      options: CarouselOptions(
                        height: 230,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 4),
                        viewportFraction: 1,
                        enableInfiniteScroll: true,
                        enlargeCenterPage: false,
                        onPageChanged: (index, reason) => context
                            .read<HomeProvider>()
                            .setCarouselIndex(index),
                      ),
                      itemBuilder: (context, index, realIndex) {
                        return buildImage(limitedList[index]);
                      },
                    );
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
              Consumer<HomeProvider>(
                builder: (context, value, child) {
                  return switch (value.searchState) {
                    SearchFoodNoneState() => GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(
                        horizontal: JejakRasaTheme.defaultPadding,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
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
                    SearchFoodErrorState(error: var message) => Center(
                      child: Text(message),
                    ),
                    SearchFoodLoadingState() => Center(
                      child: CircularProgressIndicator(),
                    ),
                    SearchFoodLoadedState(data: var searchFood) =>
                      GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(
                          horizontal: JejakRasaTheme.defaultPadding,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 230,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              childAspectRatio: 3 / 4.2,
                            ),
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          final item = searchFood;
                          return RecommendationFoodWidget(
                            recomendationFoodModel: item,
                            onTap: () {
                              Navigator.pushNamed(context, '/food-detail');
                            },
                          );
                        },
                      ),
                  };
                },
              ),
              SizedBox(height: 40),
            ],
          ),
          Positioned(
            left: JejakRasaTheme.defaultPadding,
            right: JejakRasaTheme.defaultPadding,
            top: 200,
            child: buildIndicator(context),
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
                  if (value.isNotEmpty) {
                    context.read<HomeProvider>().searchFood(
                      sharedProvider.accessToken!,
                      value.trim(),
                    );
                  } else {
                    context.read<HomeProvider>().resetSearch();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
