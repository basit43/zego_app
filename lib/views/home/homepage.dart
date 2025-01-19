import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _postText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1.0)),
            child: Column(
              children: [
                TextFormField(
                  controller: _postText,
                  decoration: InputDecoration(
                    labelText: 'Whats on your mind!!',
                  ),
                ),
                SizedBox(
                  height: 6.0,
                ),
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          var data = {
                            'time': DateTime.now(),
                            'content': _postText.text.trim(),
                            'type': 'text',
                            'uid': FirebaseAuth.instance.currentUser!.uid
                          };
                          FirebaseFirestore.instance.collection('posts').add(data);
                          _postText.text = '';
                          setState(() {});
                        },
                        child: Text('Post'))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
