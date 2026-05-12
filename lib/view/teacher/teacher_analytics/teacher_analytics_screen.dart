import 'package:codelearn/view/teacher/teacher_analytics/widgets/enrollment_chart_widget.dart';
import 'package:codelearn/view/teacher/teacher_analytics/widgets/overview_cards_widget.dart';
import 'package:codelearn/view/teacher/teacher_analytics/widgets/revenue_stats_widget.dart';
import 'package:codelearn/view/teacher/teacher_analytics/widgets/student_engagement_widget.dart';
import 'package:codelearn/view/teacher/teacher_analytics/widgets/teacher_analytics_app_bar.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_color.dart';

class TeacherAnalyticsScreen extends StatelessWidget {
  const TeacherAnalyticsScreen({super.key});

  final String instructorID = 'inst_1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const TeacherAnalyticsAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OverviewCardsWidget(instructorID: instructorID),
                  const SizedBox(height: 24),
                  EnrollmentChartWidget(instructorID: instructorID),
                  const SizedBox(height: 24),
                  const RevenueStatsWidget(),
                  const SizedBox(height: 24),
                  StudentEngagementWidget(instructorID: instructorID),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
