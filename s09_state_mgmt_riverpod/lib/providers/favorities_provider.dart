import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:s08_multi_screen/models/meal.dart';

class FavoriteMealsNotifier extends Notifier<List<Meal>> {
  // NOTE: always create a new object (list in this case)
  bool toggleMealFavoriteStatus(Meal meal) {
    final isMealFavorite = state.contains(meal);

    if (isMealFavorite) {
      state = state.where((m) => m.id != meal.id).toList();
      return false;
    } else {
      state = [...state, meal];
      return true;
    }
  }

  @override
  List<Meal> build() {
    return [];
  }
}

final favoriteMealsProvider =
    NotifierProvider<FavoriteMealsNotifier, List<Meal>>(
        () => FavoriteMealsNotifier());
