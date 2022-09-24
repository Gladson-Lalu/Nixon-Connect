import 'dart:collection';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import '../../Common/validator.dart';
import '../../Services/channel_service.dart';
import '../../Services/location_service.dart';
import '../../Services/socket_service.dart';

import '../../Models/room_model.dart';

part 'channels_state.dart';

class ChannelsCubit extends Cubit<ChannelsState> {
  final Stream channelStream =
      SocketService.instance.channelStream;
  final ChannelsService _channelsService =
      ChannelsService();
  ChannelsCubit() : super(const ChannelsInitial());
  final rejectedRooms = HashSet();
  final List<RoomModel> roomModels = [];
  void _updateRooms(data) {
    roomModels.clear();
    final rooms = data['rooms'];
    for (final room in rooms) {
      if (rejectedRooms.contains(room['_id'])) {
        continue;
      }
      roomModels.add(RoomModel.fromJson(room));
    }
    roomModels
        .sort((a, b) => b.createdAt.compareTo(a.createdAt));
    emit(ChannelsLoaded(List.from(roomModels)));
  }

  void initChannels() {
    channelStream.listen((data) => _updateRooms(data));
  }

  void dispose() {
    channelStream.drain();
  }

  void rejectRoom(RoomModel roomModel) {
    rejectedRooms.add(roomModel.roomId);
    roomModels.remove(roomModel);
    emit(ChannelsLoaded(List.from(roomModels)));
  }

  Future<void> fetchChannels(String token) async {
    late LocationData locationData;
    if (LocationService.instance.locationData != null) {
      locationData = LocationService.instance.locationData!;
    } else {
      locationData =
          await LocationService.instance.getLocation();
    }
    final Response response =
        await _channelsService.refreshChannels(
            token: token,
            latitude: locationData.latitude.toString(),
            longitude: locationData.longitude.toString());
    if (response.statusCode == 200) {
      _updateRooms(jsonDecode(response.body));
    } else {
      showToast('Error fetching channels');
    }
  }
}
