import 'package:codelearn/view/home/widgets/shimmer_recommended_course_card.dart';
import 'package:flutter/material.dart';

class ShimmerRecommendedSection extends StatelessWidget {
  const ShimmerRecommendedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recommended Course',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const TextButton(onPressed: null, child: Text('See all')),
            ],
          ),
        ),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) => const Padding(
              padding: EdgeInsets.only(right: 16),
              child: ShimmerRecommendedCourseCard(),
            ),
          ),
        )
      ],
    );
  }
}
