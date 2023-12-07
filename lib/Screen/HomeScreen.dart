import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/Api/apis.dart';
import 'package:chat/Screen/Friends/friendscard.dart';
import 'package:chat/Screen/auth/Login_screen.dart';
import 'package:chat/Screen/myprofile.dart';
import 'package:chat/Widgets/UserCard.dart';
import 'package:chat/helper/dailogs.dart';
import 'package:chat/main.dart';
import 'package:chat/model/chatusermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.user});
  final ChatUser user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];
  final List<ChatUser> _searchlsit = [];
  bool _isSearching = false;
  String? _image;
  String displayText = '';
  @override
  void initState() {
    super.initState();
    Api.getSelfInfo();
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (Api.auth.currentUser != null) {
        if (message.toString().contains("pause")) {
          Api.updateActiveStatus(false);
        }
        if (message.toString().contains("resume")) {
          Api.updateActiveStatus(true);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
          onWillPop: () {
            if (_isSearching) {
              setState(() {
                _isSearching = !_isSearching;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: _isSearching
                  ? TextFormField(
                      onChanged: (val) {
                        _searchlsit.clear();
                        for (var i in list) {
                          if (i.name
                                  .toLowerCase()
                                  .contains(val.toLowerCase()) ||
                              i.email
                                  .toLowerCase()
                                  .contains(val.toLowerCase())) {
                            _searchlsit.add(i);
                          }
                          setState(() {
                            _searchlsit;
                          });
                        }
                      },
                      decoration: const InputDecoration(
                          hintText: "Name,Email..", border: InputBorder.none))
                  : Text(
                      "Gossip",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
                    ),
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        _isSearching = !_isSearching;
                      });
                    },
                    icon: Icon(
                      _isSearching
                          ? CupertinoIcons.clear_circled_solid
                          : Icons.search_outlined,
                      size: 30,
                    )),
              ],
            ),
            drawer: Drawer(
                child: SingleChildScrollView(
                    child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    SizedBox(height: mq.height * .07),
                    Stack(
                      children: [
                        _image != null
                            ? ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * .3),
                                child: Image.file(
                                  File(_image!),
                                  width: mq.height * 0.15,
                                  height: mq.height * 0.15,
                                  fit: BoxFit.cover,

                                  // placeholder: (context, url) => CircularProgressIndicator(),
                                ),
                              )
                            : ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * .3),
                                child: CachedNetworkImage(
                                  width: mq.height * 0.15,
                                  height: mq.height * 0.15,
                                  fit: BoxFit.cover,
                                  imageUrl: widget.user.image,
                                  // placeholder: (context, url) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const CircleAvatar(
                                          child: Icon(CupertinoIcons.person)),
                                ),
                              ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Column(
                      children: [
                        Text(
                          widget.user.name,
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        Text(
                          widget.user.email,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black87),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: mq.height * .02,
                    ),

                    /// Header of the Drawer

                    /// Header Menu items
                    Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.home_outlined),
                          title: Text('Home'),
                          onTap: () {
                            /// Close Navigation drawer before
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen(
                                        user: Api.me,
                                      )),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.favorite_border),
                          title: Text('Favourites'),
                          onTap: () {
                            /// Close Navigation drawer before
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen(
                                        user: Api.me,
                                      )),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.workspaces),
                          title: Text('Workflow'),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: Icon(Icons.update),
                          title: Text('Updates'),
                          onTap: () {},
                        ),
                        const Divider(
                          color: Colors.black45,
                        ),
                        ListTile(
                          leading: Icon(Icons.account_tree_outlined),
                          title: Text('Plugins'),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: Icon(Icons.logout_rounded),
                          title: Text('Logout'),
                          onTap: () async {
                            Dialogs.showProgressBar(context);
                            await Api.updateActiveStatus(false);
                            await Api.auth.signOut().then((value) async {
                              await GoogleSignIn().signOut().then((value) {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Api.auth = FirebaseAuth.instance;
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => LoginScreen()));
                              });
                            });
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ))),
            floatingActionButton: FloatingActionButton(
              autofocus: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              backgroundColor: const Color.fromARGB(255, 33, 93, 243),
              onPressed: () async {
                _addChatUserDialog();
              },
              child: const Icon(
                Icons.group_add_rounded,
                color: Colors.white,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: StreamBuilder(
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    //if data is loading
                    case ConnectionState.waiting:
                    case ConnectionState.none:

                    //if some or all data is loaded then show it
                    case ConnectionState.active:
                    case ConnectionState.done:
                      return StreamBuilder(
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            //if data is loading
                            case ConnectionState.waiting:
                            case ConnectionState.none:
                              return const Center(
                                  child: CircularProgressIndicator());

                            //if some or all data is loaded then show it
                            case ConnectionState.active:
                            case ConnectionState.done:
                              final data = snapshot.data?.docs;
                              list = data
                                      ?.map((e) => ChatUser.fromJson(e.data()))
                                      .toList() ??
                                  [];

                              if (list.isNotEmpty) {
                                return ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: _isSearching
                                        ? _searchlsit.length
                                        : list.length,
                                    itemBuilder: (context, index) {
                                      return ChatUserCard(
                                        user: _isSearching
                                            ? _searchlsit[index]
                                            : list[index],
                                      );
                                      // return Text('Name;${list[index]}');
                                    });
                              } else {
                                return Center(
                                    child: Text(
                                  "No Connections Founnd",
                                  style: TextStyle(fontSize: 20),
                                ));
                              }
                          }
                        },
                        stream: Api.getAllUsers(
                            snapshot.data?.docs.map((e) => e.id).toList() ??
                                []),
                      );
                  }
                },
                stream: Api.getMyUsersId(),
              ),
            ),
          ),
        ));
  }

  // for adding new chat user
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
