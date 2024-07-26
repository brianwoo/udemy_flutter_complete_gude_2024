import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:s11_forms/data/categories.dart';
import 'package:s11_forms/models/category.dart';
import 'package:s11_forms/models/grocery_item.dart';

import 'package:http/http.dart' as http;

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  late String _enteredName;
  late String _enteredQuantity = '1';
  late Categories _selectedCategory = Categories.vegetables;
  var _isSending = false;

  void _saveItem() async {
    final isValidated = _formKey.currentState!.validate();

    if (isValidated) {
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });

      print(_enteredName);
      print(int.tryParse(_enteredQuantity));
      print(_selectedCategory);

      final url = Uri.https(
        'flutter-prep-76a53-default-rtdb.firebaseio.com',
        'shopping-list.json',
      );
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'name': _enteredName,
            'quantity': int.parse(_enteredQuantity),
            'category': categories[_selectedCategory]!.title,
          },
        ),
      );

      print(response.body);
      print(response.statusCode);
      final itemId = jsonDecode(response.body)['name'];

      if (mounted) {
        Navigator.of(context).pop(
          GroceryItem(
              id: itemId,
              name: _enteredName,
              quantity: int.parse(_enteredQuantity),
              category: categories[_selectedCategory]!),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(label: Text('Name')),
                onSaved: (newValue) => _enteredName = newValue!,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 to 50 chars.';
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration:
                          const InputDecoration(label: Text('Quantity')),
                      initialValue: _enteredQuantity,
                      keyboardType: TextInputType.number,
                      onSaved: (newValue) => _enteredQuantity = newValue!,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'Must be a valid, positive number.';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items: categories.entries
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.key,
                              child: Row(
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    color: e.value.color,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(e.value.title),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => _selectedCategory = value!,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () =>
                        _isSending ? null : _formKey.currentState!.reset(),
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: _isSending ? null : _saveItem,
                    child: _isSending
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Add Item'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
