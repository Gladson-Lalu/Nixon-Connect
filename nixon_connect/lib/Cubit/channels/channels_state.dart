part of 'channels_cubit.dart';

@immutable
abstract class ChannelsState {
  const ChannelsState();
}

class ChannelsInitial extends ChannelsState {
  const ChannelsInitial();
}

class ChannelsLoaded extends ChannelsState {
  final List<RoomModel> rooms;

  const ChannelsLoaded(this.rooms);

  @override
  bool operator ==(Object other) =>
      other is ChannelsLoaded &&
      rooms == other.rooms &&
      runtimeType == other.runtimeType &&
      listEquals(rooms, other.rooms);

  @override
  int get hashCode => rooms.hashCode;
}
