import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:s11_forms/data/categories.dart';
import 'package:s11_forms/models/category.dart';
import 'package:s11_forms/models/grocery_item.dart';
import 'package:s11_forms/widgets/new_item.dart';

import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  // final List<GroceryItem> _groceryItems = [];

  Future<List<GroceryItem>> _loadItems() async {
    final url = Uri.https(
      'flutter-prep-76a53-default-rtdb.firebaseio.com',
      'shopping-list.json',
    );

    final response = await http.get(url);

    if (response.statusCode >= 400) {
      throw Exception('Failed to fetch grocery items. Please try again later.');
    }

    // Firebase seems to return a 'null' when there is no items in db.
    if (response.body == 'null') {
      return [];
    }

    Map<String, dynamic> listData = jsonDecode(response.body);

    final List<GroceryItem> loadedItems = [];
    for (final entry in listData.entries) {
      final entryValue = entry.value as Map<String, dynamic>;
      final groceryItem = GroceryItem(
        id: entry.key,
        name: entryValue['name'],
        quantity: entryValue['quantity'],
        category: categories[fromCategoriesString(entryValue['category'])]!,
      );
      loadedItems.add(groceryItem);
    }

    return loadedItems;
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
        MaterialPageRoute(builder: (context) => const NewItem()));

    if (newItem == null) {
      return;
    }

    setState(() {});
  }

  void _deleteItem(GroceryItem item) async {
    final url = Uri.https(
      'flutter-prep-76a53-default-rtdb.firebaseio.com',
      'shopping-list/${item.id}.json',
    );

    await http.delete(url);

    setState(() {});
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
      body: FutureBuilder(
        // _loadItems() returns a Future or an Exception
        future: _loadItems(),
        builder: (context, snapshot) {
          // Still waiting for response...
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // snapshot.error will return the error from the Exception
            return Center(child: Text(snapshot.error.toString()));
          }

          if (snapshot.data!.isEmpty) {
            return const Center(child: Text('Your Grocery List is Empty'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final itemList = snapshot.data!;

              return Dismissible(
                key: Key(itemList[index].id),
                onDismissed: (direction) => _deleteItem(itemList[index]),
                child: ListTile(
                  leading: Container(
                    height: 16,
                    width: 16,
                    color: itemList[index].category.color,
                  ),
                  title: Text(itemList[index].name),
                  trailing: Text(itemList[index].quantity.toString()),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
