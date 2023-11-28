import 'package:chat/Api/apis.dart';
import 'package:chat/helper/MyDataUtil.dart';
import 'package:chat/main.dart';
import 'package:chat/model/message.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});
  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return Api.user.uid == widget.message.fromid
        ? _greenMessage()
        : _blueMessage();
  }

  Widget _blueMessage() {
    if (widget.message.read.isEmpty) {
      Api.updateMessageReadStatus(widget.message);
    }
    return Flexible(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            margin: EdgeInsets.symmetric(
                vertical: mq.height * .01, horizontal: mq.width * .05),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 117, 179, 230),
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: Row(
              children: [
                Text(
                  widget.message.msg,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: mq.width * .01, left: mq.width * .03),
                  child: Text(
                    MyDateUtil.getFormattedTime(
                      context: context,
                      time: widget.message.sent,
                    ),
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                Icon(
                  Icons.done_all_rounded,
                  size: 15,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _greenMessage() {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            margin: EdgeInsets.symmetric(
                vertical: mq.height * .01, horizontal: mq.width * .05),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 245, 246, 247),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30))),
            child: Row(
              children: [
                Text(
                  widget.message.msg,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: mq.width * .01, left: mq.width * .03),
                  child: Text(
                    MyDateUtil.getFormattedTime(
                      context: context,
                      time: widget.message.sent,
                    ),
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                if (widget.message.read.isNotEmpty)
                  Icon(
                    Icons.done_all_rounded,
                    size: 15,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
