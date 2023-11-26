import 'package:chat/model/message.dart';
import 'package:flutter/cupertino.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});
  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Widget _blueMessage() {
    return Container();
  }

  Widget _greenMessage() {
    return Container();
  }
}
