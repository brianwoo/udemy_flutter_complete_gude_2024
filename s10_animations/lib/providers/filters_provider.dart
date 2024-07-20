import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:s08_multi_screen/models/meal.dart';
import 'package:s08_multi_screen/providers/meals_provider.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier()
      : super({
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegetarian: false,
          Filter.vegan: false,
        });

  void setFilter(Filter filter, bool isActive) {
    state = {
      ...state,
      filter: isActive,
    };
  }

  void setFilters(Map<Filter, bool> filters) {
    state = filters;
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>((ref) {
  return FiltersNotifier();
});

final filteredMealProvider = Provider<List<Meal>>((ref) {
  final filters = ref.watch(filtersProvider);

  return ref.watch(mealsProvider).where((m) {
    return m.isGlutenFree == filters[Filter.glutenFree] &&
        m.isLactoseFree == filters[Filter.lactoseFree] &&
        m.isVegetarian == filters[Filter.vegetarian] &&
        m.isVegan == filters[Filter.vegan];
  }).toList();
});
