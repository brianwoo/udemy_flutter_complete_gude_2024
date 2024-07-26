import 'package:flutter/material.dart';

enum Categories {
  vegetables,
  fruit,
  meat,
  dairy,
  carbs,
  sweets,
  spices,
  convenience,
  hygiene,
  other,
}

Categories fromCategoriesString(String cateoriesStr) {
  return Categories.values.byName(cateoriesStr.toLowerCase());
}

class Category {
  final String title;
  final Color color;

  const Category(this.title, this.color);
}
