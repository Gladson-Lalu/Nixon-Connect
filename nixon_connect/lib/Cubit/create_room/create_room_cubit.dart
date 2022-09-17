import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:location/location.dart';
import 'package:meta/meta.dart';
import '../../Models/room_model.dart';
import '../../Services/room_service.dart';

import '../../Common/validator.dart';
import '../../Services/location_service.dart';

part 'create_room_state.dart';

class CreateRoomCubit extends Cubit<CreateRoomState> {
  List<RoomModel> rooms = [];
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
      final _roomService = RoomService();
      try {
        if (validateRoomName(roomName) &&
            validateRoomPassword(roomType, roomPassword) &&
            validateRoomPerimeter(roomPerimeter) &&
            validateRoomType(roomType)) {
          emit(const CreateRoomLoading());
          late LocationData locationData;
          if (LocationService.instance.locationData !=
              null) {
            locationData =
                LocationService.instance.locationData!;
          } else {
            locationData = await LocationService.instance
                .getLocation();
          }
          final response = await _roomService.createRoom(
              roomName: roomName,
              roomDescription: roomDescription,
              roomPassword: roomPassword,
              roomPerimeter: roomPerimeter,
              roomType: roomType!,
              userToken: userToken,
              locationData: locationData);
          if (response.statusCode == 200) {
            final roomModel = RoomModel.fromJson(
                json.decode(response.body)['room']);
            rooms.add(roomModel);
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
