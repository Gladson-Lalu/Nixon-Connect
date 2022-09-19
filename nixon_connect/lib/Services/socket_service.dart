//socket service with socket.io and singleton pattern

import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:location_platform_interface/location_platform_interface.dart';
import 'package:nixon_connect/Services/location_service.dart';
import 'package:nixon_connect/Services/message_service.dart';
import 'package:socket_io_client/socket_io_client.dart'
    // ignore: library_prefixes
    as IO;

import '../Common/validator.dart';

class SocketService {
  static SocketService? _instance;
  static SocketService get instance {
    _instance ??= SocketService._init();
    return _instance!;
  }

  final LocationService _locationService =
      LocationService.instance;
  SocketService._init();
  IO.Socket? _socket;
  IO.Socket? get socket => _socket;

  String? token;
  static final socketURI = dotenv.env['SOCKET_URI'];

  final StreamController _channelStreamController =
      StreamController.broadcast();
  Stream get channelStream =>
      _channelStreamController.stream;
  void initSocket({required String token}) {
    this.token = token;
    _socket = IO.io(socketURI, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    //on connect
    _socket!.onConnect((_) {
      _socket!.emit('authenticate', {'token': token});
      _locationService.startSendingLocation();
    });

    _socket!.onDisconnect((_) {
      _locationService.stopSendingLocation();
    });

    //on error
    _socket!.on('error', (data) {
      showToast(data['message']);
    });

    _socket!.on('message-received', (data) {
      MessageService.instance.onMessageReceived(data);
    });

    //on message-sent
    _socket!.on('message-sent', (data) {
      if (data['success'] == true) {
        showToast('Message delivered');
      } else {
        showToast('Network error');
      }
    });
    //on room invite
    _socket!.on('room-invite', (data) {
      _channelStreamController.add(data);
    });

    _socket!.connect();
  }

  //connect to socket
  void connect() {
    _socket!.connect();
  }

  //disconnect from socket
  void disconnect() {
    _socket!.disconnect();
  }

  //send message
  void sendMessage(
      {required String message,
      required String messageType,
      required String senderName,
      required String roomId,
      required List<String> mentions}) {
    _socket!.emit('send-message', {
      'token': token,
      'message': message,
      'mentions': mentions,
      'roomId': roomId,
      'messageType': messageType,
      'senderName': senderName,
    });
  }

  void sendLocation(LocationData locationData) {
    _socket!.emit('send-location', {
      'token': token,
      'location': {
        'latitude': locationData.latitude,
        'longitude': locationData.longitude,
      }
    });
  }

  //join room
  void joinRoom(String roomId) {
    _socket!.emit(
        'join-room', {'token': token, 'roomId': roomId});
  }
}
