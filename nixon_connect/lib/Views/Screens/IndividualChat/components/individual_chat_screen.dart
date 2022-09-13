import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nixon_connect/Cubit/auth/auth_cubit.dart';
import 'package:nixon_connect/Models/room_message.dart';
import 'package:nixon_connect/Models/room_model.dart';
import 'package:nixon_connect/Handlers/local_database_handler.dart';

import '../../../../Services/message_service.dart';
import 'app_bar.dart';

class ChatDetailPage extends StatefulWidget {
  final RoomModel roomModel;
  const ChatDetailPage({Key? key, required this.roomModel})
      : super(key: key);
  @override
  _ChatDetailPageState createState() =>
      _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  // List<ChatMessage> messages = [
  //   ChatMessage(
  //       messageContent: "Hello, how are you?",
  //       messageType: "receiver"),
  //   ChatMessage(
  //       messageContent: "👋", messageType: "receiver"),
  //   ChatMessage(
  //       messageContent:
  //           "Hey Gladson, I am doing fine dude. wbu?",
  //       messageType: "sender"),
  //   ChatMessage(
  //       messageContent: "😊", messageType: "receiver"),
  //   ChatMessage(
  //       messageContent: "I am fine, thanks",
  //       messageType: "sender"),
  // ];

  final TextEditingController _messageController =
      TextEditingController();
  final ScrollController _scrollController =
      ScrollController();
  late List<RoomMessage> _messages;

  @override
  Widget build(BuildContext context) {
    final String currentUserId =
        BlocProvider.of<AuthCubit>(context).user!.id;
    return Scaffold(
      appBar: buildAppBar(title: widget.roomModel.roomName),
      body: Stack(
        children: <Widget>[
          StreamBuilder<Object>(
              stream: LocalDatabase.instance
                  .watchRoomMessages(
                      widget.roomModel.roomId),
              builder: (context, snapshot) {
                _messages = LocalDatabase.instance
                    .getRoomMessages(
                        widget.roomModel.roomId);
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: _messages.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    bool isReceiver =
                        _messages[index].sender !=
                            currentUserId;
                    print(_messages[index].sender +
                        "and" +
                        currentUserId);
                    return Container(
                      padding: const EdgeInsets.only(
                          left: 14,
                          right: 14,
                          top: 10,
                          bottom: 10),
                      child: Align(
                        alignment: (isReceiver
                            ? Alignment.topLeft
                            : Alignment.topRight),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(20),
                            color: (isReceiver
                                ? Colors.grey.shade200
                                : _messages[index].id == -1
                                    ? Colors.grey.shade200
                                    : Colors.blue[200]),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            _messages[index].message,
                            style: const TextStyle(
                                fontSize: 15),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(
                  left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius:
                            BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(
                              color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      if (_messageController
                          .text.isNotEmpty) {
                        MessageService.instance.sendMessage(
                            message:
                                _messageController.text,
                            roomId:
                                widget.roomModel.roomId);
                        _messageController.clear();
                        _scrollController.animateTo(
                            _scrollController
                                .position.maxScrollExtent,
                            duration: const Duration(
                                milliseconds: 300),
                            curve: Curves.easeOut);
                      }
                    },
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
