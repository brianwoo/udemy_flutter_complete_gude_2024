import 'package:flutter/material.dart';
import 'package:s11_forms/models/grocery_item.dart';
import 'package:s11_forms/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];

  void _addItem() {
    Navigator.of(context)
        .push<GroceryItem>(
            MaterialPageRoute(builder: (context) => const NewItem()))
        .then(
      (value) {
        if (value != null) {
          print('returned: $value');
          setState(() {
            _groceryItems.add(value);
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: _groceryItems.isNotEmpty
          ? ListView.builder(
              itemCount: _groceryItems.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(_groceryItems[index].id),
                  onDismissed: (direction) {
                    setState(() {
                      _groceryItems.removeAt(index);
                    });
                  },
                  child: ListTile(
                    leading: Container(
                      height: 16,
                      width: 16,
                      color: _groceryItems[index].category.color,
                    ),
                    title: Text(_groceryItems[index].name),
                    trailing: Text(_groceryItems[index].quantity.toString()),
                  ),
                );
              },
            )
          : const Center(child: Text('Your Grocery List is Empty')),
    );
  }
}
