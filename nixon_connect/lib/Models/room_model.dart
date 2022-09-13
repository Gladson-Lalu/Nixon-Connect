import 'package:nixon_connect/Models/room_message.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class RoomModel {
  int id;
  String roomName;
  String roomType;
  String roomDescription;
  String roomPerimeter;
  String roomAvatar;
  List<String> roomRoles;
  String? roomPassword;
  String roomHost;
  @Index()
  String roomId;
  DateTime lastUpdatedAt;
  List<String> roomMembers;
  String lastMessage;

  RoomModel(
      {this.id = 0,
      required this.roomName,
      required this.roomType,
      required this.roomDescription,
      required this.roomPerimeter,
      this.roomPassword,
      required this.roomHost,
      required this.roomAvatar,
      required this.roomRoles,
      required this.roomMembers,
      required this.roomId,
      required this.lastUpdatedAt,
      required this.lastMessage});
  factory RoomModel.fromJson(Map<String, dynamic> json) =>
      RoomModel(
        roomName: json["roomName"] ?? '',
        roomType: json["roomType"] ?? '',
        roomDescription: json["roomDescription"] ?? '',
        roomPerimeter: json["roomPerimeter"] ?? '',
        roomPassword: json["roomPassword"] ?? '',
        roomHost: json["roomHost"] ?? '',
        roomAvatar: json["roomAvatarUrl"] ?? '',
        roomMembers: json["roomMembers"] != null
            ? List<String>.from(json["roomMembers"])
            : [],
        roomRoles: json["roomRoles"] != null
            ? List<String>.from(json["roomRoles"])
            : [],
        lastUpdatedAt: json["updatedAt"] == null
            ? DateTime.now()
            : DateTime.parse(json["updatedAt"]),
        roomId: json["_id"] ?? '',
        lastMessage: json["lastMessage"] ?? '',
      );

  //to json
  Map<String, dynamic> toJson() => {
        "roomName": roomName,
        "roomType": roomType,
        "roomDescription": roomDescription,
        "roomPerimeter": roomPerimeter,
        "roomPassword": roomPassword,
        "roomHost": roomHost,
        "roomAvatarUrl": roomAvatar,
        "roomMembers": roomMembers,
        "roomRoles": roomRoles,
        "roomUpdatedAt": lastUpdatedAt.toIso8601String(),
        "_id": roomId,
      };
  //copyWith
  RoomModel copyWith({
    String? roomName,
    String? roomType,
    String? roomDescription,
    String? roomPerimeter,
    String? roomPassword,
    String? roomHost,
    String? roomAvatar,
    List<String>? roomRoles,
    DateTime? lastUpdatedAt,
    List<String>? roomMembers,
    String? roomId,
    String? lastMessage,
    int? id,
    DateTime? lastMessageAt,
    List<RoomMessage>? roomMessages,
  }) =>
      RoomModel(
          roomName: roomName ?? this.roomName,
          roomType: roomType ?? this.roomType,
          roomDescription:
              roomDescription ?? this.roomDescription,
          roomPerimeter:
              roomPerimeter ?? this.roomPerimeter,
          roomPassword: roomPassword ?? this.roomPassword,
          roomHost: roomHost ?? this.roomHost,
          roomAvatar: roomAvatar ?? this.roomAvatar,
          roomRoles: roomRoles ?? this.roomRoles,
          lastUpdatedAt:
              lastUpdatedAt ?? this.lastUpdatedAt,
          roomMembers: roomMembers ?? this.roomMembers,
          roomId: roomId ?? this.roomId,
          lastMessage: lastMessage ?? this.lastMessage,
          id: id ?? this.id);
}
