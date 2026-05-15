import 'package:codelearn/bloc/course/course_bloc.dart';
import 'package:codelearn/bloc/course/course_event.dart';
import 'package:codelearn/core/theme/app_color.dart';
import 'package:codelearn/models/review.dart';
import 'package:codelearn/repositories/review_repository.dart';
import 'package:codelearn/view/course/course_detail/widgets/review_dialog.dart';
import 'package:codelearn/view/course/course_detail/widgets/shimmer_review_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:codelearn/l10n/app_localizations.dart';

class ReviewsSection extends StatefulWidget {
  final String courseId;
  const ReviewsSection({super.key, required this.courseId});

  @override
  State<ReviewsSection> createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends State<ReviewsSection> {
  final ReviewRepository _reviewRepository = ReviewRepository();
  List<Review> _reviews = [];
  bool _isLoading = true;
  final _auth = FirebaseAuth.instance;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    final l10n = AppLocalizations.of(context)!;
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final reviews = await _reviewRepository.getCourseReviews(widget.courseId);

      if (!mounted) return;
      setState(() {
        _reviews = reviews;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = l10n.failedToLoadReviews;
      });
    }
  }

  Future<void> _showReviewDialog([Review? existingReview]) async {
    final result = await Get.dialog<Map<String, dynamic>>(
      ReviewDialog(
        courseId: widget.courseId,
        key: UniqueKey(),
        existingReview: existingReview,
      ),
      barrierDismissible: false,
    );
    if (result != null) {
      await _handleReviewAction(result);
    }
  }

  Future<void> _handleReviewAction(Map<String, dynamic> result) async {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      Get.snackbar(
        l10n.error,
        l10n.pleaseSignInToReview,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      final action = result['action'] as String;

      //check if user has already reviewed
      final existingReview = _reviews.firstWhereOrNull(
        (review) => review.userId == currentUser.uid,
      );
      switch (action) {
        case 'add':
          if (existingReview != null) {
            Get.snackbar(
              'Error',
              'You have already reviewed this course',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
            setState(() => _isLoading = false);
            return;
          }
          final rating = (result['rating'] as num).toDouble();
          final comment = result['review'] as String;
          final newReview = Review(
            id: '',
            courseId: widget.courseId,
            userId: currentUser.uid,
            userName: currentUser.displayName ?? 'Anonymous',
            rating: rating,
            comment: comment,
            createdAt: DateTime.now(),
          );
          await _reviewRepository.addReview(newReview);
          break;

        case 'update':
          if (existingReview != null) {
            final rating = (result['rating'] as num).toDouble();
            final comment = result['review'] as String;
            final updatedReview = Review(
              id: existingReview.id,
              courseId: widget.courseId,
              userId: currentUser.uid,
              userName: currentUser.displayName ?? 'Anonymous',
              rating: rating,
              comment: comment,
              createdAt: DateTime.now(),
            );
            await _reviewRepository.updateReview(updatedReview);
          }
          break;

        case 'delete':
          if (existingReview != null) {
            await _reviewRepository.deleteReview(existingReview.id);
          }
          break;
      }
      await _loadReviews();
      //refresh course details to update rating and review count
      context.read<CourseBloc>().add(RefreshCoursesDetail(widget.courseId));

      Get.snackbar(
        'Success',
        _getSuccessMessage(action),
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
      );
    } catch (e) {
      setState(() => _isLoading = false);
      Get.snackbar(
        l10n.error,
        l10n.failedToSubmitReview,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String _getSuccessMessage(String action) {
    final l10n = AppLocalizations.of(context)!;
    switch (action) {
      case 'add':
        return l10n.reviewSubmitted;
      case 'update':
        return l10n.reviewUpdated;
      case 'delete':
        return l10n.reviewDeleted;
      default:
        return l10n.actionCompleted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final currentUser = _auth.currentUser;
    final userReview = currentUser != null
        ? _reviews.firstWhereOrNull(
            (review) => review.userId == currentUser.uid,
          )
        : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reviews',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: _isLoading
                  ? null
                  : () => _showReviewDialog(userReview),
              label: Text(
                userReview != null ? 'Edit Review' : 'Write a Review',
              ),
              icon: const Icon(Icons.rate_review),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_isLoading)
          Column(
            children: List.generate(
              3,
              (index) => const ShimmerReviewTile(),
          ),
          )
        else if (_error != null)
          Center(
            child: Column(
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(_error!, style: theme.textTheme.bodyLarge),
                TextButton(onPressed: _loadReviews, child: const Text('Retry')),
              ],
            ),
          )
        else if (_reviews.isEmpty)
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.reviews_outlined,
                  size: 48,
                  color: AppColors.secondary.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.noReviewsYet,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.beFirstToMessage,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.secondary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _reviews.length,
            itemBuilder: (context, index) {
              final review = _reviews[index];
              return _buildReviewTile(
                context,
                review: review,
                isCurrentUserReview: currentUser?.uid == review.userId,
              );
            },
          ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Widget _buildReviewTile(
    BuildContext context, {
    required Review review,
    required bool isCurrentUserReview,
  }) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Text(
                  review.userName[0],
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < review.rating
                                ? Icons.star
                                : Icons.star_border,
                            color: AppColors.primary,
                            size: 16,
                          );
                        }),
                        const SizedBox(width: 8),
                        Text(
                          _formatDate(review.createdAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isCurrentUserReview)
                IconButton(
                  onPressed: () => _showReviewDialog(review),
                  icon: const Icon(Icons.more_vert),
                ),
            ],
          ),
          Text(review.comment, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
