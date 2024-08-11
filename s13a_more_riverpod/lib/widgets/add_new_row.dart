import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:s13a_more_riverpod/models/place.dart';
import 'package:s13a_more_riverpod/providers/places_provider.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class AddNewRow extends ConsumerWidget {
  const AddNewRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () =>
                ref.read(placesProvider.notifier).addPlaceAndUpdateLocalState(
                      Place(
                        title: uuid.v4(),
                      ),
                    ),
            child: const Text(
              'Add Data & Update Local State',
              softWrap: false,
            ),
          ),
          ElevatedButton(
            onPressed: () =>
                ref.read(placesProvider.notifier).addPlaceAndInvalidate(
                      Place(
                        title: uuid.v4(),
                      ),
                    ),
            child: const Text('Add Data & InvalidateSelf'),
          ),
        ],
      ),
    );
  }
}
