import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nixon_connect/Services/file_service.dart';
import '../../../../Cubit/auth/auth_cubit.dart';
import '../../../../Models/room_message.dart';
import '../../../../Models/room_model.dart';
import '../../../../Handlers/local_database_handler.dart';

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
  final TextEditingController _messageController =
      TextEditingController();
  final ScrollController _scrollController =
      ScrollController();
  late List<RoomMessage> _messages;
  File? _file;
  bool isUploading = false;
  double uploadProgress = 0;

  @override
  Widget build(BuildContext context) {
    final String currentUserId =
        BlocProvider.of<AuthCubit>(context).user!.id;
    return Scaffold(
      appBar: buildAppBar(
          title: widget.roomModel.roomName,
          isLoading: isUploading,
          loadingProgress: uploadProgress),
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
                                : _messages[index]
                                            .messageId ==
                                        "-1"
                                    ? Colors.grey.shade100
                                    : Colors.blue[200]),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              if (isReceiver)
                                Text(
                                  _messages[index]
                                      .senderName,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight:
                                          FontWeight.w700,
                                      color:
                                          Colors.black87),
                                )
                              else
                                const Text(
                                  "You",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight:
                                          FontWeight.w700,
                                      color:
                                          Colors.black87),
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                              _messages[index]
                                          .messageType ==
                                      'image'
                                  ? CachedNetworkImage(
                                      imageUrl:
                                          _messages[index]
                                              .message,
                                    )
                                  : _messages[index]
                                              .messageType !=
                                          "text"
                                      ? GestureDetector(
                                          onTap: () {
                                            FileService.instance.downloadAndOpenFile(
                                                url: _messages[
                                                        index]
                                                    .message,
                                                fileName: _messages[
                                                        index]
                                                    .id
                                                    .toString());
                                          },
                                          child: SizedBox(
                                            height: 100,
                                            width: 100,
                                            child: Center(
                                              child: Column(
                                                children: const [
                                                  Icon(
                                                    Icons
                                                        .attachment,
                                                    size:
                                                        50,
                                                  ),
                                                  Text(
                                                      "Download File"),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : Text(
                                          _messages[index]
                                              .message,
                                          style:
                                              const TextStyle(
                                                  fontSize:
                                                      15),
                                        ),
                            ],
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
                    onTap: () {
                      showBottomSheet(
                          backgroundColor:
                              Colors.blueGrey[100],
                          shape:
                              const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          enableDrag: true,
                          context: context,
                          builder: (context) =>
                              bottomSheet(context));
                    },
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
                      //find first message mentions with @
                      final List<String> mentions =
                          _messageController.text
                              .split(" ");
                      final List<String> mentionedUsers =
                          [];
                      for (final String mention
                          in mentions) {
                        if (mention.startsWith("@")) {
                          mentionedUsers.add(mention
                              .substring(1)
                              .toLowerCase());
                        }
                      }

                      if (_messageController
                          .text.isNotEmpty) {
                        LocalDatabase.instance.addMessage(
                            RoomMessage(
                                messageType: 'text',
                                senderName: BlocProvider.of<
                                        AuthCubit>(context)
                                    .user!
                                    .name,
                                message:
                                    _messageController.text,
                                sender: currentUserId,
                                room:
                                    widget.roomModel.roomId,
                                createdAt: DateTime.now(),
                                messageId: '-1'));

                        MessageService.instance.sendMessage(
                            senderName:
                                BlocProvider.of<AuthCubit>(
                                        context)
                                    .user!
                                    .name,
                            mentions: mentionedUsers,
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

  void takePhoto(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(
      source: source,
    );
    if (pickedFile != null) {
      _file = File(pickedFile.path);
      if (_file != null) {
        setState(() {
          isUploading = true;
        });
        MessageService.instance.sendFileMessage(
            file: _file!,
            senderName: BlocProvider.of<AuthCubit>(context)
                .user!
                .name,
            roomId: widget.roomModel.roomId,
            messageType: 'image',
            onProgress: ((value) => setState(() {
                  uploadProgress = value;
                })),
            context: context);
        setState(() {
          isUploading = false;
        });
      }
    }
  }

  bottomSheet(BuildContext context) {
    FilePickerResult? result;
    return SizedBox(
        height: 280,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 30),
          child: GridView.count(
            childAspectRatio: 1.2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            crossAxisCount: 3,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () => {
                        takePhoto(ImageSource.camera),
                        Navigator.pop(context),
                      },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0),
                    child: Column(
                      children: const [
                        Icon(Icons.image),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Camera"),
                      ],
                    ),
                  )),
              ElevatedButton(
                  onPressed: () => {
                        takePhoto(ImageSource.gallery),
                      },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0),
                    child: Column(
                      children: const [
                        Icon(Icons.image),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Gallery"),
                      ],
                    ),
                  )),
              ElevatedButton(
                  onPressed: () async {
                    result = await FilePicker.platform
                        .pickFiles();
                    if (result != null) {
                      _file =
                          File(result!.files.single.path!);
                      MessageService.instance
                          .sendFileMessage(
                              file: _file!,
                              senderName: BlocProvider.of<
                                      AuthCubit>(context)
                                  .user!
                                  .name,
                              roomId:
                                  widget.roomModel.roomId,
                              messageType: 'file',
                              onProgress: ((value) =>
                                  setState(() {
                                    uploadProgress = value;
                                  })),
                              context: context);
                      setState(() {
                        isUploading = false;
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0),
                    child: Column(
                      children: const [
                        Icon(Icons.file_present_rounded),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Document"),
                      ],
                    ),
                  )),
              ElevatedButton(
                  onPressed: () => {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0),
                    child: Column(
                      children: const [
                        Icon(Icons.image),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Video"),
                      ],
                    ),
                  )),
              ElevatedButton(
                  onPressed: () => {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0),
                    child: Column(
                      children: const [
                        Icon(Icons.image),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Poll"),
                      ],
                    ),
                  )),
            ],
          ),
        ));
  }
}
