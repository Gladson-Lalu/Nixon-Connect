part of '../channel_fragment.dart';

channelBottomSheet(
    {required RoomModel room, required BuildContext ctx}) {
  final TextEditingController _textEditingController =
      TextEditingController();
  final ButtonStyle _buttonStyle = ButtonStyle(
      minimumSize:
          MaterialStateProperty.all(const Size(100, 40)),
      backgroundColor:
          MaterialStateProperty.all(Colors.white),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20))));
  return Container(
    decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20))),
    child: Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 5, vertical: 20),
          child: ListTile(
            title: Text(
              room.roomName,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
            subtitle: Text(room.roomType),
            leading: CircleAvatar(
              child: CachedNetworkImage(
                imageUrl: room.roomAvatar,
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),
            ),
          ),
        ),
        //Description`
        ListTile(
          title: const Text(
            'Description',
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          subtitle: Text(room.roomDescription),
        ),

        const Divider(thickness: 1, color: Colors.black26),
        SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                onPressed: () {
                  if (room.roomType != "public") {
                    showDialog(
                        context: ctx,
                        builder: ((context) => AlertDialog(
                              title: const Text(
                                  'Enter Room Password'),
                              content: TextField(
                                controller:
                                    _textEditingController,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child:
                                      const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    BlocProvider.of<
                                                JoinRoomCubit>(
                                            context)
                                        .joinRoom(
                                            roomId:
                                                room.roomId,
                                            roomPassword:
                                                _textEditingController
                                                    .text,
                                            userToken: BlocProvider.of<
                                                        AuthCubit>(
                                                    context)
                                                .user!
                                                .token);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Join'),
                                ),
                              ],
                            )));
                  } else {
                    BlocProvider.of<JoinRoomCubit>(ctx)
                        .joinRoom(
                            roomId: room.roomId,
                            roomPassword:
                                _textEditingController.text,
                            userToken:
                                BlocProvider.of<AuthCubit>(
                                        ctx)
                                    .user!
                                    .token);
                  }
                },
                style: _buttonStyle,
                child: Text(
                  'JOIN',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700),
                ),
              ),
              const VerticalDivider(
                thickness: 1,
                color: Colors.black26,
              ),
              OutlinedButton(
                style: _buttonStyle,
                onPressed: () {
                  BlocProvider.of<ChannelsCubit>(ctx)
                      .rejectRoom(room);
                  Navigator.pop(ctx);
                },
                child: Text('REJECT',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade700)),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
