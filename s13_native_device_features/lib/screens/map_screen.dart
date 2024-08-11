import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:s13_native_device_features/models/place.dart';
import 'package:s13_native_device_features/services/address_service.dart';
import 'package:s13_native_device_features/widgets/map_widget.dart';

class MapScreen extends StatefulWidget {
  PlaceLocation location;
  final bool isSelecting;

  MapScreen({
    super.key,
    this.location = const PlaceLocation(
      latitude: 37.422,
      longitude: -122.084,
      address: '',
    ),
    this.isSelecting = true,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  void _setLocation(double latitude, double longitude) {
    setState(() {
      widget.location = PlaceLocation(
        latitude: latitude,
        longitude: longitude,
        address: '',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isSelecting ? 'Pick your Location' : 'Your Location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () async {
                if (context.mounted) {
                  Navigator.of(context).pop(LatLng(
                    widget.location.latitude,
                    widget.location.longitude,
                  ));
                }
              },
            ),
        ],
      ),
      body: MapWidget(
        latitude: widget.location.latitude,
        longitude: widget.location.longitude,
        isInteractive: true,
        isMarkerChangable: widget.isSelecting,
        setLocation: _setLocation,
      ),
    );
  }
}
