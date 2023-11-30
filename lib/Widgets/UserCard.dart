import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/Api/apis.dart';
import 'package:chat/Screen/chat_screen.dart';
import 'package:chat/helper/MyDataUtil.dart';
import 'package:chat/main.dart';
import 'package:chat/model/chatusermodel.dart';
import 'package:chat/model/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({super.key, required this.user});
  final ChatUser user;

  @override
  State<ChatUserCard> createState() => _UserCardState();
}

class _UserCardState extends State<ChatUserCard> {
  Message? _message;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 7),
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
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => Message.fromJson(e.data())).toList() ?? [];

            if (list.isNotEmpty) _message = list[0];

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
                subtitle: Text(
                  _message != null
                      ? _message!.type == Type.image
                          ? 'Sent a image'
                          : _message!.msg
                      : widget.user.about,
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                trailing: _message == null
                    ? null
                    : _message!.read.isEmpty && _message!.fromid != Api.user.uid
                        ? Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(7.5)),
                          )
                        : Text(
                            MyDateUtil.getLastMessageTime(
                                context: context, time: _message!.sent),
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400),
                          ));
          },
          stream: Api.getLastMessage(widget.user),
        ),
      ),
    );
  }
}
