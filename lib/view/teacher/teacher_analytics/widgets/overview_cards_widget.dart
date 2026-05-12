import 'package:codelearn/services/dummy_data_service.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class OverviewCardsWidget extends StatelessWidget {
  final String instructorID;
  const OverviewCardsWidget({super.key, required this.instructorID});

  @override
  Widget build(BuildContext context) {
    final stats = DummyDataService.getTeacherStats(instructorID);

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard(
          'Total Students',
          '${stats.totalStudents}',
          Icons.people,
        ),
        _buildStatCard(
          'Active Courses',
          '${stats.activeCourses}',
          Icons.school,
        ),
        _buildStatCard(
          'Total Revenue',
          '\$${stats.totalRevenue.toStringAsFixed(2)}',
          Icons.attach_money,
        ),
        _buildStatCard(
          'Avg. Rating',
          stats.averageRating.toString(),
          Icons.star,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: AppColors.primary),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
