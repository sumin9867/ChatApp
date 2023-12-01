import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/main.dart';
import 'package:chat/model/chatusermodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({super.key, required this.user});

  final ChatUser user;

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreen();
}

class _ViewProfileScreen extends State<ViewProfileScreen> {
  String? _image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.user.name,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(mq.height * .3),
                          child: Image.file(
                            File(_image!),
                            width: mq.height * .2,
                            height: mq.height * .2,
                            fit: BoxFit.cover,

                            // placeholder: (context, url) => CircularProgressIndicator(),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(mq.height * .3),
                          child: CachedNetworkImage(
                            width: mq.height * .2,
                            height: mq.height * .2,
                            fit: BoxFit.cover,
                            imageUrl: widget.user.image,
                            // placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const CircleAvatar(
                                    child: Icon(CupertinoIcons.person)),
                          ),
                        ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  widget.user.email,
                  style: const TextStyle(fontSize: 20, color: Colors.black87),
                ),
                Row(
                  children: [
                    Text('About'),
                    Text(
                      widget.user.about,
                      style:
                          const TextStyle(fontSize: 20, color: Colors.black87),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
