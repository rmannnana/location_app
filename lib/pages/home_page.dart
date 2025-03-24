import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as gl;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mp;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  mp.MapboxMap? mapboxMapController;

  StreamSubscription? userPositionStream;

  Future<void> initStat() async {
    super.initState();
    _setupPositionTracking();
  }

  @override
  void dispose() {
    userPositionStream?.cancel();
    super.dispose();
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
        body: mp.MapWidget(
          onMapCreated: _onMapCreated,
          styleUri: mp.MapboxStyles.SATELLITE_STREETS,
        )
    );
  }

  void _onMapCreated(
      mp.MapboxMap controller,
      ) async {
    setState(() {
      mapboxMapController = controller;
    });
    mapboxMapController?.location.updateSettings(
      mp.LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
      ),
    );
  }

  Future<void> _setupPositionTracking() async {
    bool serviceEnabled;
    gl.LocationPermission permission;

    serviceEnabled = await gl.Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error(
        'Vous avez désactiver la localisation sur votre appareil.',
      );
    }

    permission = await gl.Geolocator.checkPermission();

    if (permission == gl.LocationPermission.denied) {
      permission = await gl.Geolocator.requestPermission();
      if (permission == gl.LocationPermission.denied) {
        return Future.error('Autorisez l\'accès à votre localisation.');
      }
    }

    if (permission == gl.LocationPermission.deniedForever) {
      return Future.error(
        'Impossible de lancer l\'application si elle n\'a pas accès à votre loalisation',
      );
    }

    gl.LocationSettings locationSettings = gl.LocationSettings(
      accuracy: gl.LocationAccuracy.high,
      distanceFilter: 5,
    );

    userPositionStream?.cancel();
    userPositionStream =
        gl.Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen(
          (
          gl.Position? position,
          ) {
            if (position != null && mapboxMapController != null) {
              mapboxMapController?.setCamera(
                mp.CameraOptions(
                  zoom: 15,
                center: mp.Point(
                coordinates: mp.Position(position.longitude, position.latitude),
                ),
                ),
              );
            }
          },
    );
  }
}
