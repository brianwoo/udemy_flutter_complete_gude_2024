import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:s13_native_device_features/models/place.dart';
import 'package:s13_native_device_features/screens/map_screen.dart';
import 'package:s13_native_device_features/services/address_service.dart';
import 'package:s13_native_device_features/widgets/map_widget.dart';

class LocationInput extends StatefulWidget {
  void Function(PlaceLocation placeLocation) onPickLocation;

  LocationInput({super.key, required this.onPickLocation});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  void _savePlace(double latitude, double longitude) async {
    final address = await getAddressFromLatLng(latitude, longitude);

    setState(() {
      _pickedLocation = PlaceLocation(
          latitude: latitude, longitude: longitude, address: address);
      _isGettingLocation = false;
      widget.onPickLocation(_pickedLocation!);
    });

    print('Lat: $latitude Lng: $longitude, Addr: $address');
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        _isGettingLocation = false;
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        _isGettingLocation = false;
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();
    if (locationData.latitude == null || locationData.longitude == null) {
      return;
    }

    _savePlace(locationData.latitude!, locationData.longitude!);
  }

  void _selectOnMap() async {
    final result = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (context) {
          return MapScreen(
            isSelecting: true,
          );
        },
      ),
    );

    if (result == null) {
      return;
    }

    setState(() {
      _isGettingLocation = true;
    });

    _savePlace(result.latitude, result.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No location chosen',
      textAlign: TextAlign.center,
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
    );

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    } else if (_pickedLocation != null) {
      previewContent = MapWidget(
        latitude: _pickedLocation!.latitude,
        longitude: _pickedLocation!.longitude,
        isInteractive: false,
        isMarkerChangable: false,
      );
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(
            width: 1,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          )),
          alignment: Alignment.center,
          height: 170,
          width: double.infinity,
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              onPressed: _getCurrentLocation,
              label: const Text('Get Current Location'),
            ),
            TextButton.icon(
              icon: const Icon(Icons.map),
              onPressed: _selectOnMap,
              label: const Text('Select on Map'),
            )
          ],
        )
      ],
    );
  }
}
