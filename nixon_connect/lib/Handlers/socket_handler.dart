//socket service with socket.io and singleton pattern

import 'package:flutter_dotenv/flutter_dotenv.dart';
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

  SocketService._init();
  IO.Socket? _socket;
  IO.Socket? get socket => _socket;

  String? token;
  static final socketURI = dotenv.env['SOCKET_URI'];

  void initSocket({required String token}) {
    this.token = token;
    _socket = IO.io(socketURI, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    //on connect
    _socket!.onConnect((_) {
      _socket!.emit('authenticate', {'token': token});
    });

    //on user-connected
    _socket!.on('user-connected', (data) {
      if (data['success'] == true) {
        showToast('User connected');
      } else {
        showToast('Network error');
      }
    });

    _socket!.on('message-received', (data) {
      MessageService.instance.onMessageReceived(data);
    });

    //on message-sent
    _socket!.on('message-sent', (data) {
      if (data['success'] == true) {
        showToast('Message sent');
      } else {
        showToast('Network error');
      }
    });
    print('socket initialized');
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
      required String roomId,
      required List<String> mentions}) {
    _socket!.emit('send-message', {
      'token': token,
      'message': message,
      'mentions': mentions,
      'roomId': roomId,
    });
  }
}
