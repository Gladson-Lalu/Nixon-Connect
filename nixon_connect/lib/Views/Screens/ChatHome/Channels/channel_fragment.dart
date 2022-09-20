import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Common/functions.dart';
import '../../../../Cubit/auth/auth_cubit.dart';
import '../../../../Cubit/channels/channels_cubit.dart';
import '../../IndividualChat/conversations_screen.dart';

import '../../../../Cubit/join_room/join_room_cubit.dart';
import '../../../../Models/room_model.dart';

part './widgets/channel_bottom_sheet.dart';

class ChannelPage extends StatelessWidget {
  const ChannelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<ChannelsCubit>(context)
              .fetchChannels(
                  BlocProvider.of<AuthCubit>(context)
                      .user!
                      .token);
        },
        child: Column(
          children: [
            Expanded(
                child: BlocListener<JoinRoomCubit,
                    JoinRoomState>(
              listener: (context, state) {
                if (state is JoinRoomSuccess) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return ConversationScreen(
                        roomModel: state.roomModel);
                  }));
                }
              },
              child:
                  BlocBuilder<ChannelsCubit, ChannelsState>(
                      builder: (context, state) {
                if (state is ChannelsLoaded &&
                    state.rooms.isNotEmpty) {
                  return ListView.builder(
                    itemCount: state.rooms.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: (() => {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.only(
                                              topLeft: Radius
                                                  .circular(
                                                      20),
                                              topRight: Radius
                                                  .circular(
                                                      20))),
                                  context: context,
                                  builder: (context) =>
                                      channelBottomSheet(
                                          room: state
                                              .rooms[index],
                                          ctx: context))
                            }),
                        child: ListTile(
                          title: Text(
                            state.rooms[index].roomName,
                            style: const TextStyle(
                                fontWeight:
                                    FontWeight.bold),
                          ),
                          leading: CircleAvatar(
                            child: CachedNetworkImage(
                              imageUrl: state
                                  .rooms[index].roomAvatar,
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            ),
                          ),
                          trailing: Text(getTimeDifference(
                              state
                                  .rooms[index].createdAt)),
                          subtitle: Text(
                              state.rooms[index].roomType),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                      child: ListView(children: [
                    SizedBox(
                      height: MediaQuery.of(context)
                              .size
                              .height /
                          1.2,
                      child: const Center(
                        child: Text(
                          'No Invitation Channels',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ]));
                }
              }),
            )),
          ],
        ),
      ),
    );
  }
}
