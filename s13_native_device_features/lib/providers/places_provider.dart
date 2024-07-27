import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:s13_native_device_features/models/place.dart';

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super(const []);

  void addPlace(Place newPlace) {
    state = [...state, newPlace];
  }
}

final placesProvider = StateNotifierProvider<PlacesNotifier, List<Place>>(
  (ref) {
    return PlacesNotifier();
  },
);
