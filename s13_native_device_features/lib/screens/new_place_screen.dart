import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:s13_native_device_features/models/place.dart';
import 'package:s13_native_device_features/providers/places_provider.dart';

class NewPlaceScreen extends ConsumerWidget {
  const NewPlaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late String? placeTitle;

    void addNewPlace() {
      if (placeTitle == null || placeTitle!.isEmpty) {
        return;
      }
      ref.read(placesProvider.notifier).addPlace(Place(title: placeTitle!));
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Place'),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  decoration: const InputDecoration(label: Text('Title')),
                  onChanged: (value) {
                    placeTitle = value;
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: addNewPlace,
                  label: const Text('Add Place'),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
