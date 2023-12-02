import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/Api/apis.dart';
import 'package:chat/Screen/chat_screen.dart';
import 'package:chat/helper/MyDataUtil.dart';
import 'package:chat/main.dart';
import 'package:chat/model/chatusermodel.dart';
import 'package:chat/model/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FriendCard extends StatefulWidget {
  const FriendCard({super.key, required this.user});
  final ChatUser user;

  @override
  State<FriendCard> createState() => _UserCardState();
}

class _UserCardState extends State<FriendCard> {
  Message? _message;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .02, vertical: 7),
      elevation: 0,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ChatScreen(
                        user: widget.user,
                      )));
        },
        child: StreamBuilder(
          stream: Api.getUserInfo(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * .3),
                child: CachedNetworkImage(
                  width: mq.height * .055,
                  height: mq.height * .055,
                  imageUrl: widget.user.image,
                  errorWidget: (context, url, error) =>
                      const CircleAvatar(child: Icon(CupertinoIcons.person)),
                ),
              ),
              title: Text(
                widget.user.name,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
              trailing: Text(
                  list.isNotEmpty
                      ? list[0].isOnline
                          ? 'Online'
                          : MyDateUtil.getLastActiveTime(
                              context: context, lastActive: list[0].lastActive)
                      : MyDateUtil.getLastActiveTime(
                          context: context, lastActive: widget.user.lastActive),
                  style: const TextStyle(fontSize: 13, color: Colors.black54)),
            );
          },
        ),
      ),
    );
  }
}
