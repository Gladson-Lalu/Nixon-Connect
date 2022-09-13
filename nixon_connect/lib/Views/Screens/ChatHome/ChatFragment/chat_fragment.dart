import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nixon_connect/Models/room_model.dart';
import 'package:nixon_connect/Handlers/local_database_handler.dart';
import 'package:nixon_connect/Services/sync_service.dart';

import '../../../../Cubit/auth/auth_cubit.dart';
import 'components/home_appbar.dart';
import 'components/chat_list_item.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppBar(context: context),
      body: RefreshIndicator(
        onRefresh: () async {
          SyncServer().syncData(
              userToken: BlocProvider.of<AuthCubit>(context)
                  .user!
                  .token);
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 16, left: 16, right: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search...",
                    hintStyle: TextStyle(
                        color: Colors.grey.shade600),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.shade600,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.all(8),
                    enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Colors.grey.shade100)),
                  ),
                ),
              ),
              StreamBuilder(
                  stream: LocalDatabase.instance
                      .watchAllRooms(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Something went wrong"),
                      );
                    }
                    if (snapshot.connectionState ==
                        ConnectionState.none) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    List<RoomModel> rooms = LocalDatabase
                        .instance
                        .getAllRooms();
                    if (rooms.isEmpty) {
                      return const Center(
                        child: Text('No rooms Joined'),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: rooms.length,
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatListItem(
                              room: rooms[index]);
                        },
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
