import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:s13a_more_riverpod/providers/places_provider.dart';

class AsyncValueDataList extends ConsumerWidget {
  const AsyncValueDataList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final places = ref.watch(placesProvider);

    return places.when(
      data: (data) => ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {},
            title: Text(
              data[index].title,
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
      ),
      error: (e, st) => Center(child: Text(e.toString())),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
