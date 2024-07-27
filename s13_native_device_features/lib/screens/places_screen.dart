import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:s13_native_device_features/providers/places_provider.dart';
import 'package:s13_native_device_features/screens/new_place_screen.dart';
import 'package:s13_native_device_features/screens/place_details_screen.dart';

class PlacesScreen extends ConsumerWidget {
  const PlacesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final places = ref.watch(placesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const NewPlaceScreen(),
              ));
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: SafeArea(
        child: places.isNotEmpty
            ? ListView.builder(
                itemCount: places.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    key: ValueKey(places[index].id),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            PlaceDetailsScreen(place: places[index]),
                      ));
                    },
                    title: Text(places[index].title),
                  );
                },
              )
            : Center(
                child: Text(
                  'No Places added yet',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
      ),
    );
  }
}
