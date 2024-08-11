import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:s13a_more_riverpod/models/place.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute('CREATE TABLE user_places('
          'id TEXT PRIMARY KEY, '
          'title TEXT '
          ')');
    },
    version: 1,
  );

  return db;
}

class PlacesNotifier extends AsyncNotifier<List<Place>> {
  ///
  /// 2 Options to update the state and trigger a automatic reload in the UI:
  ///

  ///
  /// Option 1: Update local state manually
  /// This method will NOT trigger the notifier.build() again
  ///
  /// Use case: the remote API (DB or REST API) returns a newly inserted obj.
  ///
  void addPlaceAndUpdateLocalState(Place newPlace) async {
    final db = await _getDatabase();

    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
    });

    // We can then manually update the local cache. For this, we'll need to
    // obtain the previous state.
    // Caution: The previous state may still be loading or in error state.
    // A graceful way of handling this would be to read `this.future` instead
    // of `this.state`, which would enable awaiting the loading state, and
    // throw an error if the state is in error state.
    final previousState = await future;
    state = AsyncData([...previousState, newPlace]);
  }

  ///
  /// Option 2: Use ref.invalidateSelf()
  /// This method WILL trigger the notifier.build() again
  ///
  /// Use case: the remote API (DB or REST API) DOES NOT return a newly
  /// inserted obj. Notifier.build() will be called to pull data.
  ///
  void addPlaceAndInvalidate(Place newPlace) async {
    final db = await _getDatabase();

    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
    });

    // Once the post request is done, we can mark the local cache as dirty.
    // This will cause "build" on our notifier to asynchronously be called again,
    // and will notify listeners when doing so.
    ref.invalidateSelf();
  }

  ///
  /// build() - this is called when:
  /// 1. Initially to provide a initial value
  /// 2. After ref.invalidateSelf() is called
  @override
  Future<List<Place>> build() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');

    final places = data
        .map(
          (row) => Place(
            id: row['id'].toString(),
            title: row['title'].toString(),
          ),
        )
        .toList();
    return places;
  }
}

final placesProvider = AsyncNotifierProvider<PlacesNotifier, List<Place>>(() {
  return PlacesNotifier();
});
