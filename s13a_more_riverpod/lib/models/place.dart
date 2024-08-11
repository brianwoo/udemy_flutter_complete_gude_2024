import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Place {
  final String id;
  final String title;

  Place({
    required this.title,
    String? id,
  }) : id = id ?? uuid.v4();
}
