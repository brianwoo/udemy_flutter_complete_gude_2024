import 'package:flutter/material.dart';
import 'package:s08_multi_screen/data/dummy_data.dart';
import 'package:s08_multi_screen/models/category.dart';
import 'package:s08_multi_screen/models/meal.dart';
import 'package:s08_multi_screen/screens/meals.dart';
import 'package:s08_multi_screen/widgets/category_grid_item.dart';

class CategoriesScreen extends StatelessWidget {
  final void Function(Meal meal) onToggleMealFavoriteStatus;
  final List<Meal> availableMeals;

  const CategoriesScreen({
    super.key,
    required this.onToggleMealFavoriteStatus,
    required this.availableMeals,
  });

  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MealsScreen(
          title: category.title,
          meals: filteredMeals,
          onToggleMealFavoriteStatus: onToggleMealFavoriteStatus,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
    );
  }
}
