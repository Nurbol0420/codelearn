import 'package:codelearn/bloc/course/course_bloc.dart';
import 'package:codelearn/bloc/course/course_event.dart';
import 'package:codelearn/bloc/course/course_state.dart';
import 'package:codelearn/routes/app_routes.dart';
import 'package:codelearn/view/course/course_detail/widgets/action_buttons.dart';
import 'package:codelearn/view/course/course_detail/widgets/course_detail_app_bar.dart';
import 'package:codelearn/view/course/course_detail/widgets/course_info_card.dart';
import 'package:codelearn/view/course/course_detail/widgets/lesson_list.dart';
import 'package:codelearn/view/course/course_detail/widgets/reviews_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:codelearn/l10n/app_localizations.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_color.dart';

class CourseDetailScreen extends StatefulWidget {
  final String courseId;
  const CourseDetailScreen({super.key, required this.courseId});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> with RouteAware {
  bool _isUnlocked = false;
  final RouteObserver<PageRoute> _routeObserver = Get.find<RouteObserver<PageRoute>>();

  @override
  void initState() { super.initState(); _loadCourseDetail(); }

  void _loadCourseDetail() { context.read<CourseBloc>().add(LoadCourseDetail(widget.courseId)); }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() { _routeObserver.unsubscribe(this); super.dispose(); }

  @override
  void didPopNext() { _loadCourseDetail(); }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final lastLesson = Get.parameters['lastLesson'] ?? '';

    return BlocBuilder<CourseBloc, CourseState>(
      builder: (context, state) {
        if (state is CourseLoading || (state is CoursesLoaded && state.selectedCourse == null)) {
          return Scaffold(
            body: Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
                const SizedBox(height: 16),
                Text(l10n.loadingCourse, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
              ],
            )),
          );
        }

        if (state is CourseError) {
          return Scaffold(
            body: Center(child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(l10n.oops, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(state.message, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _loadCourseDetail,
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.tryAgain),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12)),
                  ),
                ],
              ),
            )),
          );
        }

        if (state is CoursesLoaded && state.selectedCourse != null) {
          final course = state.selectedCourse!;
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                CourseDetailAppBar(imageUrl: course.imageUrl),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(color: theme.cardColor, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2))]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (course.isPremium && !_isUnlocked)
                              Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.amber.shade400, Colors.orange.shade400]), borderRadius: BorderRadius.circular(20)),
                                child: Row(mainAxisSize: MainAxisSize.min, children: [
                                  const Icon(Icons.workspace_premium, size: 16, color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text(l10n.premiumCourse, style: theme.textTheme.labelSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                                ]),
                              ),
                            Text(course.title, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, height: 1.3)),
                            const SizedBox(height: 12),
                            Row(children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(color: Colors.amber.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                                child: Row(mainAxisSize: MainAxisSize.min, children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 18),
                                  const SizedBox(width: 4),
                                  Text(course.rating.toStringAsFixed(1), style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                                ]),
                              ),
                              const SizedBox(width: 8),
                              Text('(${course.reviewCount} ${l10n.reviews2})', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1)),
                                child: Text('\$${course.price}', style: theme.textTheme.titleLarge?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                              ),
                            ]),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Icon(Icons.description_outlined, size: 20, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text(l10n.aboutCourse, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          ]),
                          const SizedBox(height: 12),
                          Text(course.description, style: theme.textTheme.bodyLarge?.copyWith(height: 1.6, color: Colors.grey[700])),
                        ]),
                      ),
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: CourseInfoCard(course: course)),
                      const SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(children: [
                          Icon(Icons.play_circle_outline, size: 24, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text(l10n.courseContent, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                        ]),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: LessonList(courseId: widget.courseId, isUnlocked: _isUnlocked, onLessonComplete: () => setState(() {})),
                      ),
                      const SizedBox(height: 32),
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: ReviewsSection(courseId: widget.courseId)),
                      const SizedBox(height: 20),
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: ActionButtons(course: course, isUnlocked: _isUnlocked)),
                      SizedBox(height: course.isPremium && !_isUnlocked ? 100 : 24),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: course.isPremium && !_isUnlocked
                ? Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: theme.scaffoldBackgroundColor, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, -4))]),
                    child: SafeArea(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)]),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 4))],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Get.toNamed(AppRoutes.payment, arguments: {'courseId': widget.courseId, 'courseName': course.title, 'price': course.price}),
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                                const SizedBox(width: 12),
                                Text('${l10n.buyNow} \$${course.price}', style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                              ]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : null,
          );
        }

        return Scaffold(
          body: Center(child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.warning_amber_rounded, size: 64, color: Colors.orange[300]),
              const SizedBox(height: 16),
              Text(l10n.somethingWentWrong, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(l10n.tryAgainLater, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
            ]),
          )),
        );
      },
    );
  }
}
