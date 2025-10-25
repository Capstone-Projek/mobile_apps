import 'package:flutter/material.dart';
import 'package:mobile_apps/presentation/views/food_detail/comment_section.dart';
import 'package:mobile_apps/presentation/views/food_detail/info_section.dart';
import 'package:mobile_apps/presentation/views/food_detail/ingredient_item.dart';
import 'package:mobile_apps/presentation/views/food_detail/step_item.dart';
import 'package:readmore/readmore.dart';
import 'package:mobile_apps/presentation/static/food_place/food_place_list_by_food_id_result_state.dart';
import 'package:mobile_apps/presentation/static/review/create_review_result_state.dart';
import 'package:mobile_apps/presentation/viewmodels/food_place/food_place_list_by_food_id_provider.dart';
import 'package:mobile_apps/presentation/viewmodels/review/create_review_provider.dart';
import 'package:mobile_apps/presentation/viewmodels/review/review_by_food_provider.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:mobile_apps/presentation/viewmodels/auth/user/shared_preferences_provider.dart';
import 'package:mobile_apps/presentation/viewmodels/food/food_detail_provider.dart';
import 'package:mobile_apps/presentation/static/food/food_detail_result_state.dart';
import 'place_card.dart';

class FoodDetailScreen extends StatefulWidget {
  const FoodDetailScreen({super.key});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  bool isBahan = true;
  int activeIndex = 0;
  String? videoUrl;
  int _tabIndex = 0;

  YoutubePlayerController? _ytController;

  List<Map<String, String>> media = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final idFood = ModalRoute.of(context)!.settings.arguments as int;
    final sharedProvider = context.read<SharedPreferencesProvider>();
    final foodDetailProvider = context.read<FoodDetailProvider>();
    final reviewProvider = context.read<ReviewProvider>();
    final foodPlaceByFoodId = context.read<FoodPlaceListByFoodIdProvider>();

    sharedProvider.getAccessToken();
    final token = sharedProvider.accessToken;

    if (!mounted || token == null) return;

    await foodDetailProvider.fetchFoodById(idFood);

    final foodDetailState = foodDetailProvider.resultState;

    if (foodDetailState is FoodDetailLoadedState) {
      final foodDetail = foodDetailState.data;

      final List<Map<String, String>> tempMedia = [];

      if (foodDetail.vidioUrl.isNotEmpty) {
        tempMedia.add({"type": "video", "url": foodDetail.vidioUrl});
      }

      if (foodDetail.images.isNotEmpty) {
        for (var img in foodDetail.images) {
          if (img.imageUrl.isNotEmpty) {
            tempMedia.add({"type": "image", "url": img.imageUrl});
          }
        }
      }

      setState(() {
        media = tempMedia;
      });

      if (tempMedia.isNotEmpty && tempMedia.first["type"] == "video") {
        final videoId = YoutubePlayerController.convertUrlToId(
          tempMedia.first["url"]!,
        );
        if (videoId != null) {
          _ytController = YoutubePlayerController.fromVideoId(
            videoId: videoId,
            autoPlay: false,
            params: const YoutubePlayerParams(showFullscreenButton: true),
          );
        }
      }
    }

    await reviewProvider.fetchReviewByFoodId(idFood);
    await foodPlaceByFoodId.fetchFoodPlaceListByFoodId(idFood);
  }

  @override
  void dispose() {
    _ytController?.close();
    super.dispose();
  }

  Widget _buildMainMedia(Size size) {
    if (media.isEmpty) {
      return Container(
        width: size.width,
        height: size.height * 0.3,
        color: Colors.grey[200],
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    final item = media[activeIndex];
    if (item["type"] == "video") {
      final videoId = YoutubePlayerController.convertUrlToId(item["url"] ?? "");
      
      if (videoId == null) {
        return Container(
          width: size.width,
          height: size.height * 0.3,
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, size: 48, color: Colors.grey),
        );
      }

      if (_ytController != null) {
        return YoutubePlayer(controller: _ytController!);
      } else {
        return Container(
          width: size.width,
          height: size.height * 0.3,
          color: Colors.black12,
          child: Stack(
            children: [
              Image.network(
                "https://img.youtube.com/vi/$videoId/hqdefault.jpg",
                width: size.width,
                height: size.height * 0.3,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: size.width,
                    height: size.height * 0.3,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stack) => Container(
                  width: size.width,
                  height: size.height * 0.3,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.broken_image,
                    size: 48,
                    color: Colors.grey,
                  ),
                ),
              ),
              const Center(
                child: Icon(
                  Icons.play_circle_fill,
                  color: Colors.red,
                  size: 64,
                ),
              ),
            ],
          ),
        );
      }
    } else {
      return Image.network(
        item["url"]!,
        width: size.width,
        height: size.height * 0.3,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: size.width,
            height: size.height * 0.3,
            color: Colors.grey[200],
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (context, error, stack) => Container(
          width: size.width,
          height: size.height * 0.3,
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, size: 48, color: Colors.grey),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final foodState = context.watch<FoodDetailProvider>().resultState;
    final reviewState = context.watch<ReviewProvider>().resultState;
    final foodPlaceState = context
        .watch<FoodPlaceListByFoodIdProvider>()
        .resultState;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (foodState is FoodDetailLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (foodState is FoodDetailErrorState) {
              return Center(
                child: Text(
                  foodState.error,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (foodState is FoodDetailLoadedState) {
              final food = foodState.data;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: const BoxDecoration(color: Color(0xFF26599A)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Detail Makanan",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.close, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: size.width,
                      height: size.height * 0.3,
                      child: _buildMainMedia(size),
                    ),
                    SizedBox(
                      height: 100,
                      child: Center(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          itemCount: media.length,
                          itemBuilder: (context, index) {
                            final item = media[index];
                            final bool isActive = index == activeIndex;
                            final String url = item["url"] ?? '';

                            Widget errorIconWidget = Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                  size: 40,
                                ),
                              ),
                            );

                            Widget loadingWidget = Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            );

                            Widget childWidget;

                            if (item["type"] == "image") {
                              childWidget = Image.network(
                                url,
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return loadingWidget;
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return errorIconWidget;
                                },
                              );
                            } else {
                              final videoId = YoutubePlayerController.convertUrlToId(url);

                              if (videoId == null) {
                                childWidget = errorIconWidget;
                              } else {
                                childWidget = Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Image.network(
                                        "https://img.youtube.com/vi/$videoId/hqdefault.jpg",
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, progress) {
                                          if (progress == null) return child;
                                          return loadingWidget;
                                        },
                                        errorBuilder: (context, error, stackTrace) {
                                          return errorIconWidget;
                                        },
                                      ),
                                    ),
                                    const Center(
                                      child: Icon(
                                        Icons.play_circle_fill,
                                        color: Colors.red,
                                        size: 40,
                                      ),
                                    ),
                                  ],
                                );
                              }
                            }

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  activeIndex = index;
                                  if (item["type"] == "video" &&
                                      _ytController != null) {
                                    final videoId = YoutubePlayerController.convertUrlToId(url);
                                    if (videoId != null) {
                                      _ytController!.loadVideoById(
                                        videoId: videoId,
                                      );
                                    }
                                  }
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 12),
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: isActive
                                      ? Border.all(
                                          color: const Color(0xFF26599A),
                                          width: 3,
                                        )
                                      : null,
                                  color: Colors.black12,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: childWidget,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              food.foodName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 16),
                    //   child: Text(
                    //     "Oleh Joko ndo kondo",
                    //     style: TextStyle(color: Colors.grey[600], fontSize: 11),
                    //   ),
                    // ),
                    const SizedBox(height: 12),
                    DefaultTabController(
                      length: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TabBar(
                            onTap: (index) {
                              setState(() {
                                _tabIndex = index;
                              });
                            },
                            dividerColor: Colors.transparent,
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            unselectedLabelStyle: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                            labelColor: const Color(0xFF26599A),
                            indicatorColor: const Color(0xFF26599A),
                            unselectedLabelColor: Colors.grey,
                            tabs: const [
                              Tab(text: "Deskripsi"),
                              Tab(text: "Sejarah"),
                            ],
                          ),
                          IndexedStack(
                            index: _tabIndex,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ReadMoreText(
                                  food.desc,
                                  trimLines: 3,
                                  colorClickableText: Colors.blue,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: 'baca selengkapnya',
                                  trimExpandedText: ' sembunyikan',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ReadMoreText(
                                  food.history,
                                  trimLines: 3,
                                  colorClickableText: Colors.blue,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: 'baca selengkapnya',
                                  trimExpandedText: ' sembunyikan',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
              
                    const SizedBox(height: 12),

                    InfoSection(
                      category: food.category,
                      timeCook: food.timeCook,
                      serving: food.serving,
                    ),

                    const SizedBox(height: 14),
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isBahan
                                    ? const Color(0xFF26599A)
                                    : Colors.grey[300],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () => setState(() => isBahan = true),
                              child: Text(
                                "Bahan",
                                style: TextStyle(
                                  color: isBahan
                                      ? Colors.white
                                      : Colors.black54,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: !isBahan
                                    ? const Color(0xFF26599A)
                                    : Colors.grey[300],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () => setState(() => isBahan = false),
                              child: Text(
                                "Langkah",
                                style: TextStyle(
                                  color: !isBahan
                                      ? Colors.white
                                      : Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (isBahan)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [IngredientItem(name: food.material, qty: null)],
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [StepItem(number: null, step: food.recipes)],
                        ),
                      ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Komentar",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF26599A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              _showAddCommentModal(context);
                            },
                            icon: const Icon(
                              Icons.add_comment,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Tambah",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    CommentSection(reviewState: reviewState),
                    
                    const SizedBox(height: 20),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Rekomendasi Tempat",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Builder(
                        builder: (context) {
                          if (foodPlaceState
                              is FoodPlaceListByFoodIdLoadingState) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (foodPlaceState
                              is FoodPlaceListByFoodIdErrorState) {
                            return const Center(
                              child: Text(
                                "Belum ada tempat rekomendasi.",
                                style: TextStyle(color: Colors.grey),
                              ),
                            );
                          } else if (foodPlaceState
                              is FoodPlaceListByFoodIdLoadedState) {
                            final foodPlaces = foodPlaceState.data;


                            if (foodPlaces.isEmpty) {
                              return const Center(
                                child: Text(
                                  "Belum ada tempat rekomendasi.",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              );
                            }


                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: foodPlaces.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final place = foodPlaces[index];
                                final imageUrl =
                                    (place.images != null &&
                                        place.images!.isNotEmpty)
                                    ? place.images!.first.imageUrl
                                    : null;

                                return PlaceCard(
                                  placeId: place.id ?? 0,
                                  shopName: place.shopName ?? '-',
                                  address: place.address ?? '-',
                                  priceRange: place.priceRange ?? '-',
                                  imageUrl: imageUrl,
                                );
                              },
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/food-place');
                        },
                        child: const Text(
                          "Lihat lainnya",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  void _showAddCommentModal(BuildContext context) {
    final TextEditingController commentController = TextEditingController();
    final idFood = ModalRoute.of(context)!.settings.arguments as int;

    final userProvider = context.read<SharedPreferencesProvider>();
    final userId = userProvider.showUserId ?? 0;

    final createReviewProvider = context.read<CreateReviewProvider>();
    final reviewProvider = context.read<ReviewProvider>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Tulis Komentar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black54),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  cursorColor: const Color(0xFF26599A),
                  controller: commentController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Tulis komentar kamu di sini...",
                    filled: true,
                    fillColor: Colors.grey[100],
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF26599A),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF26599A),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      final comment = commentController.text.trim();
                      if (comment.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text("Komentar tidak boleh kosong"),
                          ),
                        );
                        return;
                      }


                      final success = await createReviewProvider.createReview({
                        "id_food": idFood,
                        "review_desc": comment,
                        "id_user": userId.toString(),
                      });


                      if (!context.mounted) return;


                      if (!success) {
                        final state = createReviewProvider.state;
                        String errorMessage = "Gagal mengirim komentar.";
                        if (state is CreateReviewErrorState) {
                          errorMessage = state.error;
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(errorMessage),
                          ),
                        );
                        return;
                      }

                      await reviewProvider.fetchReviewByFoodId(idFood);


                      if (!context.mounted) return;

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text("Komentar berhasil dikirim"),
                        ),
                      );
                    },
                    child: const Text(
                      "Kirim",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
