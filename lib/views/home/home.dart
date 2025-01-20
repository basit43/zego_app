import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zego_project/views/auth/login.dart';
import 'package:zego_project/views/chat_list.dart';
import 'package:zego_project/views/home/homepage.dart';
import 'package:zego_project/views/live.dart';
import 'package:zego_project/views/search/search.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchPage(),
                        ));
                  },
                  child: Icon(Icons.search)))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                  (route) => false,
                );
              },
              title: Text('Sign Out'),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          onTap: (i) {
            setState(() {
              index = i;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
            BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: 'Live')
          ]),
      body: SafeArea(
          child: IndexedStack(
        index: index,
        children: [
          Home(),
          ChatList(),
          LivePage(),
        ],
      )),
    );
  }
}
