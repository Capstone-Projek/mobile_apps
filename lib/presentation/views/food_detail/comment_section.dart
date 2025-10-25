import 'package:flutter/material.dart';
import 'package:mobile_apps/presentation/static/review/review_result_state.dart';
import 'package:mobile_apps/presentation/views/food_detail/comment_card.dart';

class CommentSection extends StatelessWidget {
  final ReviewResultState reviewState;

  const CommentSection({super.key, required this.reviewState});

  @override
  Widget build(BuildContext context) {
    return _buildCommentsSection(reviewState);
  }

  Widget _buildCommentsSection(ReviewResultState reviewState) {
    if (reviewState is ReviewLoadingState) {
      return const Center(child: CircularProgressIndicator());
    } else if (reviewState is ReviewErrorState) {
      return const Center(
        child: Text(
          "Belum ada komentar.",
          style: TextStyle(color: Colors.grey),
        ),
      );
    } else if (reviewState is ReviewLoadedState) {
      final reviews = reviewState.data;

      if (reviews.isEmpty) {
        return const Center(
          child: Text(
            "Belum ada komentar.",
            style: TextStyle(color: Colors.grey),
          ),
        );
      }

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: reviews.map((review) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CommentCard(
                name: review.user.name,
                comment: review.reviewDesc,
              ),
            );
          }).toList(),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}