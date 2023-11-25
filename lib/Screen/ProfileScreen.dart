import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/Api/apis.dart';
import 'package:chat/main.dart';
import 'package:chat/model/chatusermodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.user});

  final ChatUser user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "We Chat",
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Api.auth.signOut();
          await GoogleSignIn().signOut();
        },
        icon: Icon(Icons.logout),
        backgroundColor: Colors.orange,
        label: Text("Logout"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .3),
                  child: CachedNetworkImage(
                    width: mq.height * .2,
                    height: mq.height * .2,
                    fit: BoxFit.cover,
                    imageUrl: widget.user.image,
                    // placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        CircleAvatar(child: Icon(CupertinoIcons.person)),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                widget.user.email,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: mq.height * .05,
              ),
              TextFormField(
                  initialValue: widget.user.name,
                  decoration: InputDecoration(
                    hintText: "Enter your name",
                    label: Text("Name"),
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  )),
              SizedBox(
                height: mq.height * .02,
              ),
              TextFormField(
                  initialValue: widget.user.about,
                  decoration: InputDecoration(
                    hintText: "How are you Feeling",
                    label: Text("About"),
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  )),
              SizedBox(
                height: mq.height * .02,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    minimumSize: Size(mq.width * 0.6, mq.height * 0.055)),
                onPressed: () {},
                icon: Icon(Icons.update),
                label: Text("Update"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
