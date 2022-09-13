//service to handle database operation
//get objectBox store in singleton pattern

import 'dart:async';
import 'dart:io';

import 'package:nixon_connect/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';

import '../Models/room_message.dart';
import '../Models/room_model.dart';

class LocalDatabase {
  static final LocalDatabase instance =
      LocalDatabase._internal();
  late final Store _store;

  factory LocalDatabase() {
    return instance;
  }

  Future<void> init() async {
    final appDocumentDir =
        await getApplicationDocumentsDirectory();
    final dir =
        Directory('${appDocumentDir.path}/objectbox');
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    _store =
        Store(getObjectBoxModel(), directory: dir.path);
  }

  LocalDatabase._internal();

  Store get store => _store;

  //watch all rooms
  Stream watchAllRooms() {
    return _store.box<RoomModel>().query().watch();
  }

  List<RoomModel> getAllRooms() {
    return _store.box<RoomModel>().getAll()
      ..sort((a, b) =>
          b.lastUpdatedAt.compareTo(a.lastUpdatedAt));
  }

  //watch messages of a room
  Stream<Object> watchRoomMessages(String roomId) {
    return _store
        .box<RoomMessage>()
        .query(RoomMessage_.room.equals(roomId))
        .watch();
  }

  //get room
  RoomModel? getRoom(String roomId) {
    return _store
        .box<RoomModel>()
        .query(RoomModel_.roomId.equals(roomId))
        .build()
        .findFirst();
  }

  //get messages of a room
  List<RoomMessage> getRoomMessages(String roomId) {
    return _store
        .box<RoomMessage>()
        .query(RoomMessage_.room.equals(roomId))
        .build()
        .find()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  //add a room to database
  void addRoom(RoomModel room) {
    //check if room already exists
    final roomBox = Box<RoomModel>(_store);
    final roomExists = roomBox
        .query(RoomModel_.roomId.equals(room.roomId))
        .build()
        .findFirst();
    if (roomExists == null) {
      roomBox.put(room);
    } else {
      roomBox.put(room.copyWith(id: roomExists.id));
    }
  }

  //add rooms to database
  void addRooms(List<dynamic> rooms) {
    final _roomBox = Box<RoomModel>(_store);
    for (var room in rooms) {
      final roomExists = _roomBox
          .query(RoomModel_.roomId.equals(room['_id']))
          .build()
          .findFirst();
      if (roomExists == null) {
        _roomBox.put(RoomModel.fromJson(room));
      } else {
        RoomModel roomModel = RoomModel.fromJson(room);
        _roomBox.put(roomModel.copyWith(id: roomExists.id));
      }
    }
  }

  //add a message to database
  void addMessage(RoomMessage message) {
    //check if message already exists
    final _roomBox = Box<RoomModel>(_store);
    final _messageBox = Box<RoomMessage>(_store);
    final messageExists = _messageBox
        .query(RoomMessage_.messageId
            .equals(message.messageId))
        .build()
        .findFirst();
    if (messageExists == null) {
      final room = _roomBox
          .query(RoomModel_.roomId.equals(message.room))
          .build()
          .findFirst();
      if (room != null) {
        room.lastMessage = message.message;
        room.lastUpdatedAt = message.createdAt;
        _roomBox.put(room);
        _messageBox.put(message);
      }
    }
  }

  //add messages to database
  void addMessages(List<dynamic> messages) {
    final _roomBox = Box<RoomModel>(_store);
    final _messageBox = Box<RoomMessage>(_store);
    for (var message in messages) {
      final messageExists = _messageBox
          .query(
              RoomMessage_.messageId.equals(message['_id']))
          .build()
          .findFirst();
      if (messageExists == null) {
        final room = _roomBox
            .query(
                RoomModel_.roomId.equals(message['room']))
            .build()
            .findFirst();
        if (room != null) {
          room.lastMessage = message['message'];
          if (room.lastUpdatedAt
              .isBefore(message['createdAt'])) {
            room.lastUpdatedAt = message['createdAt'];
          }
          _roomBox.put(room);
          _messageBox.put(RoomMessage.fromJson(message));
        }
      }
    }
  }
}
