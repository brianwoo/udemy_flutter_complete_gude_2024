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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: places.when(
            data: (listData) {
              return ListView.builder(
                itemCount: listData.length,
                itemBuilder: (context, index) {
                  final place = listData[index];
                  return ListTile(
                    key: ValueKey(place.id),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PlaceDetailsScreen(place: place),
                      ));
                    },
                    leading: CircleAvatar(
                      radius: 26,
                      backgroundImage: FileImage(place.image),
                    ),
                    title: Text(place.title),
                    subtitle: Text(place.placeLocation.address),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text(e.toString())),
          ),
        ),
      ),
    );
  }
}
