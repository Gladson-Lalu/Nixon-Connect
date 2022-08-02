class RoomModel {
  final String roomName;
  final String roomType;
  final String roomDescription;
  final String roomPerimeter;
  final String? roomPassword;
  final String roomHost;
  final String roomId;
  final List<dynamic> roomMessages;

  RoomModel(
      {required this.roomName,
      required this.roomType,
      required this.roomDescription,
      required this.roomPerimeter,
      this.roomPassword,
      required this.roomHost,
      required this.roomId,
      required this.roomMessages});
  //fromJson
  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      roomName: json['roomName'] as String,
      roomType: json['roomType'] as String,
      roomDescription: json['roomDescription'] as String,
      roomPerimeter: json['roomPerimeter'] as String,
      roomHost: json['roomHost'] as String,
      roomId: json['roomId'] as String,
      roomPassword: json['roomPassword'],
      roomMessages: json['roomMessages'] as List<dynamic>,
    );
  }
}
