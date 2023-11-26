import 'dart:developer';
import 'package:chat/Api/apis.dart';
import 'package:chat/Screen/ProfileScreen.dart';
import 'package:chat/Widgets/UserCard.dart';
import 'package:chat/model/chatusermodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
              leading: const Icon(CupertinoIcons.home),
              centerTitle: true,
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
                      "We Chat",
                    ),
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        _isSearching = !_isSearching;
                      });
                    },
                    icon: Icon(_isSearching
                        ? CupertinoIcons.clear_circled_solid
                        : Icons.search)),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileScreen(
                                    user: Api.me,
                                  )));
                    },
                    icon: const Icon(Icons.more_vert))
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await Api.auth.signOut();
                await GoogleSignIn().signOut();

                ;
              },
              child: const Icon(Icons.add_comment_rounded),
            ),
            body: StreamBuilder(
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  //if data is loading
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(child: CircularProgressIndicator());

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
                          itemCount:
                              _isSearching ? _searchlsit.length : list.length,
                          itemBuilder: (context, index) {
                            return UserCard(
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
              stream: Api.getAllUser(),
            )),
      ),
    );
  }
}
