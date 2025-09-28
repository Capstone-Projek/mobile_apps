import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class FoodDetailScreen extends StatefulWidget {
  const FoodDetailScreen({super.key});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  bool isBahan = true;
  int activeIndex = 0;

  YoutubePlayerController? _ytController;

  final List<Map<String, String>> media = [
    {"type": "video", "url": "https://www.youtube.com/watch?v=dQw4w9WgXcQ"},
    {"type": "image", "url": "images/makanan.jpg"},
    {"type": "image", "url": "images/makanan.jpg"},
    {"type": "image", "url": "images/makanan.jpg"},
  ];

  @override
  void initState() {
    super.initState();
    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS)) {
      final videoId = YoutubePlayerController.convertUrlToId(media[0]["url"]!)!;
      _ytController = YoutubePlayerController.fromVideoId(
        videoId: videoId,
        autoPlay: false,
        params: const YoutubePlayerParams(showFullscreenButton: true),
      );
    }
  }

  @override
  void dispose() {
    _ytController?.close();
    super.dispose();
  }

  Widget _buildMainMedia(Size size) {
    final item = media[activeIndex];
    if (item["type"] == "video") {
      final videoId = YoutubePlayerController.convertUrlToId(item["url"]!)!;
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
      return Image.asset(
        item["url"]!,
        width: size.width,
        height: size.height * 0.3,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stack) => Container(
          width: size.width,
          height: size.height * 0.3,
          color: Colors.grey[300],
          child: const Icon(Icons.image, size: 48, color: Colors.grey),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: size.width,
                    height: size.height * 0.3,
                    child: _buildMainMedia(size),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF26599A).withAlpha(150),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ),
                ],
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

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            activeIndex = index;
                            if (item["type"] == "video" &&
                                _ytController != null) {
                              _ytController!.loadVideoById(
                                videoId: YoutubePlayerController.convertUrlToId(
                                  item["url"]!,
                                )!,
                              );
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
                            image: item["type"] == "image"
                                ? DecorationImage(
                                    image: AssetImage(item["url"]!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            color: Colors.black12,
                          ),
                          child: item["type"] == "video"
                              ? const Center(
                                  child: Icon(
                                    Icons.play_circle_fill,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                )
                              : null,
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
                    const Expanded(
                      child: Text(
                        "Wingko babat",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    const Icon(Icons.bookmark_border),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Oleh Joko ndo kondo",
                  style: TextStyle(color: Colors.grey[600], fontSize: 11),
                ),
              ),
              const SizedBox(height: 12),
              DefaultTabController(
                length: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TabBar(
                      dividerColor: Colors.transparent,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                      labelColor: Color(0xFF26599A),
                      indicatorColor: Color(0xFF26599A),
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: "Deskripsi"),
                        Tab(text: "Sejarah"),
                        Tab(text: "Makna budaya"),
                      ],
                    ),
                    SizedBox(
                      height: 120,
                      child: TabBarView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text("Konten Deskripsi"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text("Konten Sejarah"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text("Konten Makna budaya"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
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
                            color: isBahan ? Colors.white : Colors.black54,
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
                            color: !isBahan ? Colors.white : Colors.black54,
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
                    children: [
                      _buildIngredientItem("Bawang merah", "1"),
                      _buildIngredientItem("Bawang putih", "2"),
                      _buildIngredientItem("Bawang putih", "2"),
                    ],
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _buildStepItem("1", "Rebus air putih"),
                      _buildStepItem("2", "Buang air nya"),
                      _buildStepItem("3", "Selesai jadi deh"),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Komentar",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: const [
                    CommentCard(
                      name: "Joko",
                      comment: "Wah resep nya berhasil mantap",
                    ),
                    SizedBox(width: 8),
                    CommentCard(
                      name: "Nina",
                      comment: "Wah resep nya berhasil mantap",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Rekomendasi Tempat",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [PlaceCard(), SizedBox(height: 8), PlaceCard()],
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/food-place');
                    // ganti '/all-places' sesuai route kamu
                  },
                  child: const Text(
                    "Lihat lainnya",
                    style: TextStyle(
                      color: Colors.blue, // biar kelihatan bisa diklik
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildIngredientItem(String name, String qty) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Expanded(child: Text(name)),
          Text(qty, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  static Widget _buildStepItem(String number, String step) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              number,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(step)),
        ],
      ),
    );
  }
}

class CommentCard extends StatelessWidget {
  final String name;
  final String comment;
  const CommentCard({super.key, required this.name, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(child: Icon(Icons.person)),
                const SizedBox(width: 8),
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 6),
            Text(comment, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class PlaceCard extends StatelessWidget {
  const PlaceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF26599A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.image, size: 50, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/food-place-detail');
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Toko Haji Makmur",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          "Jl. pekunden rayano",
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.sell, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          "Harga terjangkau",
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
