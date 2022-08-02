part of 'create_room_cubit.dart';

@immutable
abstract class CreateRoomState {
  const CreateRoomState();
}

class CreateRoomInitial extends CreateRoomState {
  const CreateRoomInitial();
}

class CreateRoomLoading extends CreateRoomState {
  const CreateRoomLoading();
}

class CreateRoomSuccess extends CreateRoomState {
  final RoomModel roomModel;

  const CreateRoomSuccess(this.roomModel);

  @override
  String toString() =>
      'CreateRoomSuccess { roomModel: $roomModel }';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateRoomSuccess &&
          runtimeType == other.runtimeType &&
          roomModel == other.roomModel;

  @override
  int get hashCode => roomModel.hashCode;
}

class CreateRoomError extends CreateRoomState {
  const CreateRoomError();
}
