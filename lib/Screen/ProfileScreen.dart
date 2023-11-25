import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/Api/apis.dart';
import 'package:chat/Screen/auth/Login_screen.dart';
import 'package:chat/helper/dailogs.dart';
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
          Dialogs.showProgressBar(context);
          await Api.auth.signOut().then((value) async {
            await GoogleSignIn().signOut().then((value) {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => LoginScreen()));
            });
          });
        },
        icon: const Icon(Icons.logout),
        backgroundColor: Colors.orange,
        label: const Text("Logout"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    ClipRRect(
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
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: MaterialButton(
                        onPressed: () {},
                        shape: CircleBorder(),
                        color: Colors.white,
                        child: Icon(
                          Icons.edit_rounded,
                          color: Colors.purple,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                widget.user.email,
                style: const TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: mq.height * .05,
              ),
              TextFormField(
                  initialValue: widget.user.name,
                  decoration: InputDecoration(
                    hintText: "Enter your name",
                    label: const Text("Name"),
                    prefixIcon: const Icon(Icons.person),
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
                    label: const Text("About"),
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  )),
              SizedBox(
                height: mq.height * .02,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    minimumSize: Size(mq.width * 0.6, mq.height * 0.055)),
                onPressed: () {},
                icon: const Icon(Icons.update),
                label: const Text("Update"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
