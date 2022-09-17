part of 'join_room_cubit.dart';

@immutable
abstract class JoinRoomState {
  const JoinRoomState();
}

class JoinRoomInitial extends JoinRoomState {
  const JoinRoomInitial();
}

class JoinRoomLoading extends JoinRoomState {
  const JoinRoomLoading();
}

class JoinRoomSuccess extends JoinRoomState {
  final RoomModel roomModel;
  const JoinRoomSuccess(this.roomModel);
}

class JoinRoomError extends JoinRoomState {
  const JoinRoomError();
}
