import 'package:objectbox/objectbox.dart';

@Entity()
class RoomMessage {
  int id;
  @Index()
  String messageId;
  String message;
  String senderName;
  String messageType;
  List<String> mentions;
  String sender;
  String room;
  DateTime createdAt;

  RoomMessage({
    this.id = 0,
    required this.messageId,
    required this.message,
    required this.senderName,
    required this.messageType,
    required this.sender,
    required this.room,
    required this.createdAt,
    this.mentions = const [],
  });

  factory RoomMessage.fromJson(Map<String, dynamic> json) =>
      RoomMessage(
        messageId: json["_id"],
        message: json["messageContent"] ?? '',
        sender: json["messageSender"] ?? '',
        senderName: json["senderName"] ?? '',
        messageType: json["messageType"] ?? '',
        room: json["messageRoomId"] ?? '',
        mentions: json["messageMentions"] != null
            ? List<String>.from(json["messageMentions"])
            : [],
        createdAt: json["messageCreatedAt"] == null
            ? DateTime.now()
            : DateTime.parse(
                json["messageCreatedAt"],
              ),
      );

  Map<String, dynamic> toJson() => {
        "id": messageId,
        "message": message,
        "sender": sender,
        "room": room,
        "createdAt": createdAt.toIso8601String(),
      };
}
