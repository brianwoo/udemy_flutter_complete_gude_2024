import 'package:flutter/material.dart';
import 'package:s08_multi_screen/data/dummy_data.dart';
import 'package:s08_multi_screen/models/category.dart';
import 'package:s08_multi_screen/models/meal.dart';
import 'package:s08_multi_screen/screens/categories.dart';
import 'package:s08_multi_screen/screens/filters.dart';
import 'package:s08_multi_screen/screens/meals.dart';
import 'package:s08_multi_screen/widgets/main_drawer.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favoriteMeals = [];
  Map<Filter, bool> _selectedFilters = kInitialFilters;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _showInfoMessage(String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
    ));
  }

  void _toggleMealFavoriteStatus(Meal meal) {
    final isExisting = _favoriteMeals.contains(meal);
    if (isExisting) {
      setState(() {
        _favoriteMeals.remove(meal);
        _showInfoMessage('Meal is no longer a favorite');
      });
    } else {
      setState(() {
        _favoriteMeals.add(meal);
        _showInfoMessage('Meal has been marked as a favorite');
      });
    }
  }

  void _setScreen(String identifier) {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(builder: (context) {
          return FiltersScreen(currentFilters: _selectedFilters);
        }),
      ).then((value) {
        setState(() {
          _selectedFilters = value ?? kInitialFilters;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_selectedFilters);
    final availableMeals = dummyMeals.where((m) {
      return m.isGlutenFree == _selectedFilters[Filter.glutenFree] &&
          m.isLactoseFree == _selectedFilters[Filter.lactoseFree] &&
          m.isVegetarian == _selectedFilters[Filter.vegetarian] &&
          m.isVegan == _selectedFilters[Filter.vegan];
    }).toList();

    Widget activePage = CategoriesScreen(
      onToggleMealFavoriteStatus: _toggleMealFavoriteStatus,
      availableMeals: availableMeals,
    );
    String activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favoriteMeals,
        onToggleMealFavoriteStatus: _toggleMealFavoriteStatus,
      );
      activePageTitle = 'Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: SafeArea(child: activePage),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
