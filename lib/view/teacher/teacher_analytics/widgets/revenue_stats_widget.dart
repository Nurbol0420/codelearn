import 'package:codelearn/models/course.dart';
import 'package:codelearn/repositories/course_repository.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_color.dart';

class RevenueStatsWidget extends StatelessWidget {
  final String instructorID;
  RevenueStatsWidget({super.key, required this.instructorID});

  final CourseRepository _courseRepository = CourseRepository();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Revenue Statistics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: .2,
            ),
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<Course>>(
            future: _courseRepository.getInstructorCourses(instructorID),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final courses = snapshot.data ?? [];
              final totalRevenue = courses.fold<double>(
                0,
                (sum, course) => sum + (course.price * course.enrollmentCount),
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildRevenueMetric(
                        'Total Revenue',
                        '\$${totalRevenue.toStringAsFixed(0)}',
                      ),
                      _buildRevenueMetric('Courses', courses.length.toString()),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Revenue by Course',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (courses.isEmpty)
                    const SizedBox(
                      height: 120,
                      child: Center(child: Text('No revenue data yet')),
                    )
                  else
                    SizedBox(height: 200, child: _buildRevenueChart(courses)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart(List<Course> courses) {
    final chartCourses = courses.take(4).toList();
    final revenues = chartCourses
        .map((course) => course.price * course.enrollmentCount)
        .toList();
    final maxRevenue = revenues.reduce((a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (maxRevenue * 1.2).clamp(1, double.infinity).toDouble(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.withValues(alpha: 0.25),
            strokeWidth: 1,
            dashArray: const [6, 4],
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx >= 0 && idx < chartCourses.length) {
                  final title = chartCourses[idx].title;
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      title.length > 8 ? '${title.substring(0, 8)}...' : title,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 44,
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: const TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        barGroups: List.generate(chartCourses.length, (index) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: revenues[index],
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.95),
                    AppColors.primary.withValues(alpha: 0.65),
                  ],
                ),
                width: 20,
              ),
            ],
          );
        }),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipRoundedRadius: 8,
            tooltipPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            tooltipBgColor: Colors.black.withValues(alpha: 0.75),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final value = rod.toY.toInt();
              final course = chartCourses[group.x.toInt()].title;
              return BarTooltipItem(
                '$course\n$value USD',
                const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              );
            },
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Widget _buildRevenueMetric(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
