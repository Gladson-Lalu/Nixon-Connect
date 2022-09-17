import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../Common/validator.dart';
import '../../Models/room_model.dart';
import '../../Services/room_service.dart';

part 'join_room_state.dart';

class JoinRoomCubit extends Cubit<JoinRoomState> {
  JoinRoomCubit() : super(const JoinRoomInitial());

  //join a room
  Future<void> joinRoom(
      {required String roomId,
      required String roomPassword,
      required String userToken}) async {
    {
      emit(const JoinRoomLoading());
      final _roomService = RoomService();
      try {
        final response = await _roomService.joinRoom(
            roomId: roomId,
            roomPassword: roomPassword,
            userToken: userToken);
        if (response.statusCode == 200) {
          print(response.body);
          final roomModel = RoomModel.fromJson(
              json.decode(response.body)['room']);
          emit(JoinRoomSuccess(roomModel));
        } else {
          emit(const JoinRoomError());
          showToast(json.decode(response.body)['error']);
        }
      } catch (error) {
        emit(const JoinRoomError());
        showToast(error.toString());
      }
    }
  }
}
