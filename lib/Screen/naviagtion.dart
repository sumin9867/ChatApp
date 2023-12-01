import 'package:chat/Api/apis.dart';
import 'package:chat/Screen/HomeScreen.dart';
import 'package:chat/Screen/myprofile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Color.fromARGB(255, 7, 181, 255),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Badge(
              child: Icon(Icons.messenger_sharp),
            ),
            label: 'Messages',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.person)),
            label: 'Profile',
          ),
        ],
      ),
      body: <Widget>[
        HomeScreen(),
        MyProfileScreen(user: Api.me),
      ][currentPageIndex],
    );
  }
}
