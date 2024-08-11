import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void noopFunc(double lat, double lng) {
  print("...NOOP...");
}

class MapWidget extends StatelessWidget {
  final double latitude;
  final double longitude;
  final bool isInteractive;
  final bool isMarkerChangable;
  final void Function(double latitude, double longitude) setLocation;

  const MapWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    this.isInteractive = true,
    this.isMarkerChangable = false,
    this.setLocation = noopFunc,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(latitude, longitude),
        initialZoom: 14.5,
        interactionOptions: InteractionOptions(
          flags: isInteractive ? InteractiveFlag.all : ~InteractiveFlag.all,
        ),
        onTap: (tapPosition, point) {
          if (!isMarkerChangable) {
            return;
          }
          print('onTap, set Marker');
          setLocation(point.latitude, point.longitude);
          // setState(() {
          //   widget.latitude = point.latitude;
          //   widget.longitude = point.longitude;
          //   widget.setLocation(point.latitude, point.longitude);
          // });
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(latitude, longitude),
              width: 80,
              height: 80,
              child: Icon(
                Icons.place,
                color: Colors.red.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
