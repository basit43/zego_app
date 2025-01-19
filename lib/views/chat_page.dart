import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final DocumentSnapshot doc;
  const ChatPage({super.key, required this.doc});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: widget.doc.reference.collection('messages').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data?.docs.isEmpty ?? true) {
                    return Text('No Messages yet !!');
                  }
                  return ListView.builder(
                    itemCount: snapshot.data?.docs.length ?? 0,
                    itemBuilder: (context, index) {
                      DocumentSnapshot msg = snapshot.data!.docs[index];
                      return Text('lll');
                    },
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: _messageController,
                  decoration: InputDecoration(label: Text('Your Message')),
                )),
                ElevatedButton(
                    onPressed: () {
                      widget.doc.reference.collection('messages').add({
                        'time': DateTime.now(),
                        'uid': FirebaseAuth.instance.currentUser!.uid,
                        'message': _messageController.text.trim(),
                      });
                    },
                    child: Text('Send'))
              ],
            ),
          )
        ],
      ),
    );
  }
}
