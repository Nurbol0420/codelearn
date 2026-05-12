import 'package:codelearn/bloc/course/course_bloc.dart';
import 'package:codelearn/bloc/course/course_event.dart';
import 'package:codelearn/bloc/filtered_course/filtered_course_bloc.dart';
import 'package:codelearn/bloc/filtered_course/filtered_course_state.dart';
import 'package:codelearn/core/theme/app_color.dart';
import 'package:codelearn/view/course/course_list/widgets/course_filter_dialog.dart';
import 'package:codelearn/view/course/course_list/widgets/empty_state_widget.dart';
import 'package:codelearn/view/course/course_list/widgets/course_card.dart';
import 'package:codelearn/view/teacher/my_courses/widgets/shimmer_course_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:codelearn/l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../../bloc/course/course_state.dart';
import '../../../bloc/filtered_course/filtered_course_event.dart';
import '../../../models/course.dart';

class CourseListScreen extends StatefulWidget {
  final String? categoryId;
  final String? categoryName;
  final bool showBackButton;

  const CourseListScreen({super.key, this.categoryId, this.categoryName, this.showBackButton = false});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  String? _currentLevel;

  @override
  void initState() {
    super.initState();
    if (widget.categoryId != null) {
      context.read<FilteredCourseBloc>().add(FilterCoursesByCategory(widget.categoryId!));
    } else {
      context.read<CourseBloc>().add(LoadCourses());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: widget.categoryId != null ? _buildFilteredCourseList(theme) : _buildAllCourseList(theme),
    );
  }

  Widget _buildAllCourseList(ThemeData theme) {
    return BlocBuilder<CourseBloc, CourseState>(
      builder: (context, state) {
        return _buildCourseListView(
          theme: theme,
          isLoading: state is CourseLoading,
          error: state is CourseError ? state.message : null,
          courses: state is CoursesLoaded ? state.courses : null,
        );
      },
    );
  }

  Widget _buildFilteredCourseList(ThemeData theme) {
    return BlocBuilder<FilteredCourseBloc, FilteredCourseState>(
      builder: (context, state) {
        return _buildCourseListView(
          theme: theme,
          isLoading: state is FilteredCourseLoading,
          error: state is FilteredCourseError ? (state as FilteredCourseError).message : null,
          courses: state is FilteredCoursesLoaded ? state.courses : null,
        );
      },
    );
  }

  Widget _buildCourseListView({required ThemeData theme, required bool isLoading, String? error, List<Course>? courses}) {
    final l10n = AppLocalizations.of(context)!;
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          expandedHeight: 200, pinned: true,
          backgroundColor: AppColors.primary,
          automaticallyImplyLeading: widget.categoryId != null || widget.showBackButton,
          leading: (widget.categoryId != null || widget.showBackButton)
              ? IconButton(
                  onPressed: () {
                    Get.back();
                    if (widget.categoryId != null) context.read<FilteredCourseBloc>().add(ClearFilteredCourses());
                  },
                  icon: const Icon(Icons.arrow_back, color: AppColors.accent),
                )
              : null,
          actions: [
            IconButton(onPressed: () => _showFilterDialog(context), icon: const Icon(Icons.filter_list, color: AppColors.accent)),
          ],
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.all(6),
            title: Text(_buildScreenTitle(l10n), style: theme.textTheme.titleLarge?.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold)),
            background: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryLight], begin: Alignment.topLeft, end: Alignment.bottomRight))),
          ),
        ),
        if (isLoading)
          SliverPadding(padding: const EdgeInsets.all(16), sliver: SliverList(delegate: SliverChildBuilderDelegate((context, index) => const ShimmerCourseCard(), childCount: 5)))
        else if (error != null)
          SliverFillRemaining(child: Center(child: Text(error, style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.error))))
        else if (courses == null || courses.isEmpty)
          SliverFillRemaining(child: EmptyStateWidget(onActionPressed: () => Get.back()))
        else
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final course = courses[index];
                return CourseCard(courseId: course.id, title: course.title, subtitle: course.description, imageUrl: course.imageUrl, rating: course.rating, duration: '${course.lessons.length * 30} mins', isPremium: course.isPremium);
              }, childCount: courses.length),
            ),
          ),
      ],
    );
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => CourseFilterDialog(onLevelSelected: _handleLevelFilter, initialLevel: _currentLevel),
    );
  }

  void _handleLevelFilter(String level) {
    final l10n = AppLocalizations.of(context)!;
    setState(() { _currentLevel = level == l10n.allLevels ? null : level; });
    if (widget.categoryId != null) {
      if (level == l10n.allLevels) {
        context.read<FilteredCourseBloc>().add(ClearFilteredCourses());
      } else {
        context.read<FilteredCourseBloc>().add(FilterCourseByLevel(level));
      }
    } else {
      context.read<CourseBloc>().add(LoadCourses());
    }
  }

  List<Course> _filterCoursesByLevel(List<Course> courses) {
    final l10n = AppLocalizations.of(context)!;
    if (_currentLevel == null || _currentLevel == l10n.allLevels) return courses;
    return courses.where((course) => course.level == _currentLevel).toList();
  }

  String _buildScreenTitle(AppLocalizations l10n) {
    final List<String> titleParts = [];
    if (widget.categoryName != null) titleParts.add(widget.categoryName!);
    if (_currentLevel != null && _currentLevel != l10n.allLevels) titleParts.add(_currentLevel!);
    if (titleParts.isEmpty) return l10n.allCourses;
    return titleParts.join(' - ');
  }
}
