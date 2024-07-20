import 'package:flutter/material.dart';
import 'package:s08_multi_screen/data/dummy_data.dart';
import 'package:s08_multi_screen/models/category.dart';
import 'package:s08_multi_screen/models/meal.dart';
import 'package:s08_multi_screen/screens/meals.dart';
import 'package:s08_multi_screen/widgets/category_grid_item.dart';

class CategoriesScreen extends StatefulWidget {
  final List<Meal> availableMeals;

  const CategoriesScreen({
    super.key,
    required this.availableMeals,
  });

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      // animation goes from the value set by lowerBound to upperBound
      lowerBound: 0,
      upperBound: 1,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = widget.availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MealsScreen(
          title: category.title,
          meals: filteredMeals,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: GridView(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: availableCategories
            .map((category) => CategoryGridItem(
                  category: category,
                  onSelectCategory: () => _selectCategory(context, category),
                ))
            .toList(),
      ),
      builder: (context, child) => SlideTransition(
        position: Tween(
          // offset: x,y (goes between 0 - 1)
          // 0.3 means 30%, and in the y axis (30% down)
          begin: const Offset(0, 0.3),
          end: const Offset(0, 0),
        ).animate(
          // Curves provides different type of animation options
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInQuart,
          ),
        ),
        child: child,
      ),
    );
  }
}
