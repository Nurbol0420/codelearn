import 'package:codelearn/repositories/category_repository.dart';
import 'package:codelearn/view/home/widgets/category_section.dart';
import 'package:codelearn/view/home/widgets/home_app_bar.dart';
import 'package:codelearn/view/home/widgets/in_progress_section.dart';
import 'package:codelearn/view/home/widgets/recommended_section.dart';
import 'package:codelearn/view/home/widgets/search_bar_widget.dart';
import 'package:codelearn/models/category.dart';
import 'package:codelearn/view/home/widgets/shimmer_category_section.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CategoryRepository _categoryRepository = CategoryRepository();
  List<Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _categoryRepository.getCategories();
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const HomeAppBar(),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SearchBarWidget(),
              const SizedBox(height: 32),
              _isLoading
                  ? const ShimmerCategorySection()
                  : CategorySection(categories: _categories),
              const SizedBox(height: 32),
              const InProgressSection(),
              RecommendedSection(),
            ]),
          ),
        ),
      ],
    );
  }
}
