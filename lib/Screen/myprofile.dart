import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:chat/Api/apis.dart';
import 'package:chat/Screen/ProfileScreen.dart';
import 'package:chat/Screen/auth/Login_screen.dart';
import 'package:chat/helper/dailogs.dart';
import 'package:chat/main.dart';
import 'package:chat/model/chatusermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key, required this.user});

  final ChatUser user;

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;
  String displayText = '';
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: Colors.black,
          ),
          title: const Text(
            "Me",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
              backgroundColor: Colors.redAccent,
              onPressed: () async {
                //for showing progress dialog
                Dialogs.showProgressBar(context);

                await Api.updateActiveStatus(false);

                //sign out from app
                await Api.auth.signOut().then((value) async {
                  await GoogleSignIn().signOut().then((value) {
                    //for hiding progress dialog
                    Navigator.pop(context);

                    //for moving to home screen
                    Navigator.pop(context);

                    Api.auth = FirebaseAuth.instance;

                    //replacing home screen with login screen
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => LoginScreen()));
                  });
                });
              },
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out')),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Stack(
                    children: [
                      _image != null
                          ? ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * .3),
                              child: Image.file(
                                File(_image!),
                                width: mq.height * .2,
                                height: mq.height * .2,
                                fit: BoxFit.cover,

                                // placeholder: (context, url) => CircularProgressIndicator(),
                              ),
                            )
                          : ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * .3),
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
                          onPressed: () {
                            _showButtomSheet();
                          },
                          shape: const CircleBorder(),
                          color: Colors.white,
                          child: const Icon(
                            Icons.edit_rounded,
                            color: Colors.purple,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.name,
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      Text(
                        widget.user.about,
                        style: const TextStyle(
                            fontSize: 18, color: Colors.black87),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Container(
                          width: 178,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 37, 88, 254),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton.icon(
                              onPressed: () {
                                _addChatUserDialog();
                              },
                              icon: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 24,
                              ),
                              label: Text(
                                'Add new Friends',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ))),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                          width: 178,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 218, 216, 216),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton.icon(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            ProfileScreen(user: Api.me)));
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.black,
                                size: 24,
                              ),
                              label: Text(
                                'Edit Profile',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ))),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 218, 216, 216),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  displayText = 'Button pressed!';
                                });
                              },
                              icon: Icon(Icons.more_vert))),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );

    // bottom sheet
  }

  void _showButtomSheet() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        context: context,
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            children: [
              const Text(
                'Pick your DP',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: mq.height * .02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          fixedSize: Size(mq.width * .2, mq.height * .10)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
// Pick an image.
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          log('Image path:${image.path} --MineTYTpe :${image.mimeType}');
                          setState(() {
                            _image = image.path;
                          });
                          Api.updateProfilePicture(File(_image!));
                        }
                        Navigator.pop(context);
                      },
                      child: Image.asset("images/add_image.png")),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          fixedSize: Size(mq.width * .2, mq.height * .10)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
// Pick an image.
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          log('Image path:${image.path}');
                          setState(() {
                            _image = image.path;
                          });
                          Api.updateProfilePicture(File(_image!));
                        }
                        Navigator.pop(context);
                      },
                      child: Image.asset("images/camera.png"))
                ],
              )
            ],
          );
        });
  }

  void _addChatUserDialog() {
    String email = '';
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),

              //title
              title: Row(
                children: const [
                  Icon(
                    Icons.person_add,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text(' Add User')
                ],
              ),

              //content
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => email = value,
                decoration: InputDecoration(
                    hintText: 'Email Id',
                    prefixIcon: const Icon(Icons.email, color: Colors.blue),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),

              //actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.blue, fontSize: 16))),

                //add button
                MaterialButton(
                    onPressed: () async {
                      //hide alert dialog
                      Navigator.pop(context);
                      if (email.isNotEmpty) {
                        await Api.addChatUser(email).then((value) {
                          if (!value) {
                            Dialogs.showSnackbar(
                                context, 'User does not Exists!');
                          }
                        });
                      }
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ));
  }
}
