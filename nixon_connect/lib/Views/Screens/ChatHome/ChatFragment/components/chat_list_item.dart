import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nixon_connect/Models/room_model.dart';

import '../../../IndividualChat/conversations_screen.dart';

class ChatListItem extends StatelessWidget {
  final RoomModel room;

  const ChatListItem({Key? key, required this.room})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String time = '';
    final difference =
        DateTime.now().difference(room.lastUpdatedAt);
    if (difference.inDays > 0) {
      time = '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      time = '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      time = '${difference.inMinutes}m ago';
    } else {
      time = 'Now';
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) {
          return ConversationScreen(roomModel: room);
        }));
      },
      child: Container(
        padding: const EdgeInsets.only(
            left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider(
                            room.roomAvatar),
                    maxRadius: 30,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            room.roomName,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            room.lastMessage,
                            style: TextStyle(
                                fontSize: 13,
                                color:
                                    Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              time,
              style: TextStyle(
                fontSize: 12,
                fontWeight: time == 'Now'
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
