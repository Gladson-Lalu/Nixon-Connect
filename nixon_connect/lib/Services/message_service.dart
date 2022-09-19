import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nixon_connect/Common/validator.dart';
import 'package:nixon_connect/Services/socket_service.dart';
import 'package:nixon_connect/Models/room_message.dart';

import '../Cubit/auth/auth_cubit.dart';
import '../Handlers/local_database_handler.dart';
import 'file_service.dart';

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
      room.lastMessage = message.messageType == 'text'
          ? message.message
          : message.messageType;
      room.lastUpdatedAt = message.createdAt;
    }
  }

  //send-message
  void sendMessage(
      {required String message,
      String messageType = 'text',
      required String senderName,
      required String roomId,
      List<String> mentions = const []}) {
    SocketService.instance.sendMessage(
      message: message,
      roomId: roomId,
      mentions: mentions,
      messageType: messageType,
      senderName: senderName,
    );
  }

  void sendFileMessage(
      {required File file,
      required String senderName,
      required String roomId,
      required ValueChanged onProgress,
      required BuildContext context,
      required String messageType,
      List<String> mentions = const []}) async {
    final String fileName = file.path.split('/').last;
    final String extension = fileName.split('.').last;
    if (extension == 'jpg' ||
        extension == 'jpeg' ||
        extension == 'mp4' ||
        extension == 'pdf' ||
        extension == 'mkv' ||
        extension == 'png') {
      final url = await FileService.instance.uploadFile(
        filePath: file.path,
      );
      print(url);
      sendMessage(
        messageType: messageType,
        senderName:
            BlocProvider.of<AuthCubit>(context).user!.name,
        message: url,
        roomId: roomId,
      );
    } else {
      showToast("File type not supported");
    }
  }
}
