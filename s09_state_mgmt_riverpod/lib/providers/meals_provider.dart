import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:s08_multi_screen/data/dummy_data.dart';
import 'package:s08_multi_screen/models/meal.dart';

final mealsProvider = Provider<List<Meal>>((ref) {
  return dummyMeals;
});
