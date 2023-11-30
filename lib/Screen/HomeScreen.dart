import 'dart:math';

import 'package:chat/Api/apis.dart';
import 'package:chat/Screen/ProfileScreen.dart';
import 'package:chat/Screen/tst.dart';
import 'package:chat/Widgets/UserCard.dart';
import 'package:chat/helper/dailogs.dart';
import 'package:chat/main.dart';
import 'package:chat/model/chatusermodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];
  final List<ChatUser> _searchlsit = [];
  bool _isSearching = false;

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
              leading: const Icon(
                CupertinoIcons.chat_bubble_text,
              ),
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
                      decoration: InputDecoration(
                          hintText: "Name,Email..", border: InputBorder.none))
                  : Text(
                      "Gossip Fest",
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 30),
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
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileScreen(
                                    user: Api.me,
                                  )));
                    },
                    icon: const Icon(
                      Icons.edit,
                    ))
              ],
            ),
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
              padding: const EdgeInsets.only(top: 12),
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
