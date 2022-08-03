import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../Models/room_model.dart';
import '../../Services/create_room.dart';

import '../../Common/validator.dart';

part 'create_room_state.dart';

class CreateRoomCubit extends Cubit<CreateRoomState> {
  final _roomService = RoomService();
  CreateRoomCubit() : super(const CreateRoomInitial());

  //create a room
  Future<void> createRoom(
      {required String roomName,
      required String roomDescription,
      required String roomPassword,
      required String roomPerimeter,
      required String? roomType,
      required String userToken}) async {
    {
      try {
        if (validateRoomName(roomName) &&
            validateRoomPassword(roomType, roomPassword) &&
            validateRoomPerimeter(roomPerimeter) &&
            validateRoomType(roomType)) {
          emit(const CreateRoomLoading());
          final response = await _roomService.createRoom(
            roomName: roomName,
            roomDescription: roomDescription,
            roomPassword: roomPassword,
            roomPerimeter: roomPerimeter,
            roomType: roomType!,
            userToken: userToken,
          );
          if (response.statusCode == 200) {
            final roomModel = RoomModel.fromJson(
                json.decode(response.body));
            emit(CreateRoomSuccess(roomModel));
          } else {
            emit(const CreateRoomError());
            showToast(json.decode(response.body)['error']);
          }
        }
      } catch (error) {
        emit(const CreateRoomError());
      }
    }
  }
}
