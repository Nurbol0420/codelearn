import 'package:codelearn/view/home/widgets/shimmer_category_card.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_color.dart';

class ShimmerCategorySection extends StatelessWidget {
  const ShimmerCategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) => ShimmerCategoryCard(),
          ),
        ),
      ],
    );
  }
}
