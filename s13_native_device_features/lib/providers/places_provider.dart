import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:s13_native_device_features/models/place.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute('CREATE TABLE user_places('
          'id TEXT PRIMARY KEY, '
          'title TEXT, '
          'image TEXT, '
          'lat REAL, '
          'lng REAL, '
          'address TEXT)');
    },
    version: 1,
  );

  return db;
}

class PlacesNotifier extends AsyncNotifier<List<Place>> {
  void addPlace(Place newPlace) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(newPlace.image.path);
    final copiedImage = await newPlace.image.copy('${appDir.path}/$fileName');

    final newPlaceCopied = Place(
      image: copiedImage,
      title: newPlace.title,
      placeLocation: newPlace.placeLocation,
    );

    final db = await _getDatabase();

    db.insert('user_places', {
      'id': newPlaceCopied.id,
      'title': newPlaceCopied.title,
      'image': newPlaceCopied.image.path,
      'lat': newPlaceCopied.placeLocation.latitude,
      'lng': newPlaceCopied.placeLocation.longitude,
      'address': newPlaceCopied.placeLocation.address,
    });

    final previousState = await future;
    state = AsyncData([...previousState, newPlaceCopied]);
  }

  @override
  Future<List<Place>> build() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');

    final places = data
        .map(
          (row) => Place(
            id: row['id'].toString(),
            title: row['title'].toString(),
            image: File(row['image'].toString()),
            placeLocation: PlaceLocation(
              latitude: row['lat'] as double,
              longitude: row['lng'] as double,
              address: row['address'].toString(),
            ),
          ),
        )
        .toList();

    return places;
  }
}

final placesProvider =
    AsyncNotifierProvider<PlacesNotifier, List<Place>>(() => PlacesNotifier());
