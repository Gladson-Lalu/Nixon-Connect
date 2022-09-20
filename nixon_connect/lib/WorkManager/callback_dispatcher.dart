import 'dart:convert';

import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:workmanager/workmanager.dart';
import 'package:socket_io_client/socket_io_client.dart'
    // ignore: library_prefixes
    as IO;

//send location to server via socket
void sendLocation(String token) async {
  const String socketURI = "http://20.235.83.206:14650/";
  Socket _socket = IO.io(socketURI, <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });
  _socket.onConnect((_) async {
    final Location location = Location();
    final LocationData locationData =
        await location.getLocation();
    _socket.emit('send-location', {
      'token': token,
      'location': {
        'latitude': locationData.latitude,
        'longitude': locationData.longitude,
      }
    });
    _socket.disconnect();
  });
  _socket.connect();
}

Future<LocationData> getLocation() async {
  Location location = Location();
  return await location.getLocation();
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    SharedPreferences prefs =
        await SharedPreferences.getInstance();
    String? userString = prefs.getString('current-user');
    switch (task) {
      case "fetch_location":
        if (userString != null) {
          String token = jsonDecode(userString)['token'];
          sendLocation(token);
        }
        break;
    }
    return Future.value(true);
  });
}
