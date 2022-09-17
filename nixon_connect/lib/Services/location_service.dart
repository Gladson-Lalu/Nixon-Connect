//get user location from the location service and periodically send it to the server
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:nixon_connect/Common/validator.dart';

import 'socket_service.dart';

class LocationService {
  static final LocationService _instance =
      LocationService._internal();

  StreamSubscription? _locationSubscription;
  Location location = Location()
    ..changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 1000 * 60 * 1,
    );
  LocationData? locationData;
  LocationService._internal();

  static LocationService get instance => _instance;

  //get location
  Future<LocationData> getLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    try {
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          showToast('Location service is disabled');
          return Future.error(
              'Location service is disabled');
        }
      }
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted =
            await location.requestPermission();
        if (_permissionGranted !=
            PermissionStatus.granted) {
          showToast('Location permission is denied');
          return Future.error(
              'Location permission is denied');
        }
      }

      locationData = await location.getLocation();
      return locationData!;
    } catch (e) {
      showToast('Location service is disabled');
      return Future.error(e);
    }
  }

  //start sending location
  Future<void> startSendingLocation() async {
    //get location
    try {
      _locationSubscription = location.onLocationChanged
          .listen((LocationData currentLocation) {
        // Use current location
        locationData = currentLocation;
        SocketService.instance
            .sendLocation(currentLocation);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void stopSendingLocation() {
    if (_locationSubscription != null) {
      _locationSubscription!.cancel();
    }
  }
}
