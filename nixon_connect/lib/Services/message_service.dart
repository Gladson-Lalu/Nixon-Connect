import 'package:nixon_connect/Services/socket_service.dart';
import 'package:nixon_connect/Models/room_message.dart';

import '../Handlers/local_database_handler.dart';

class MessageService {
  static MessageService? _instance;
  static MessageService get instance {
    _instance ??= MessageService._init();
    return _instance!;
  }

  MessageService._init();
  //on message-received
  void onMessageReceived(data) {
    final message = RoomMessage.fromJson(data);
    //add message to database
    LocalDatabase.instance.addMessage(message);
    //add message to room
    final room =
        LocalDatabase.instance.getRoom(message.room);
    if (room != null) {
      room.lastMessage = message.message;
      room.lastUpdatedAt = message.createdAt;
    }
  }

  //send-message
  void sendMessage(
      {required String message,
      required String roomId,
      List<String> mentions = const []}) {
    SocketService.instance.sendMessage(
      message: message,
      roomId: roomId,
      mentions: mentions,
    );
  }
}
