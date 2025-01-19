import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _controller = TextEditingController();
  String? username;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Page'),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _controller,
              decoration: InputDecoration(border: OutlineInputBorder()),
              onChanged: (value) {
                username = value;
                setState(() {});
              },
            ),
          ),
          if (username != null)
            if (username!.length > 2)
              FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance.collection('users').where('username', isEqualTo: username).get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data?.docs.isEmpty ?? false) {
                        return Text('No Data available');
                      }
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data?.docs.length ?? 0,
                          itemBuilder: (context, index) {
                            print('building..');
                            DocumentSnapshot doc = snapshot.data!.docs[index];
                            return ListTile(
                                title: Text(doc['username']),
                                trailing: FutureBuilder(
                                    future:
                                        doc.reference.collection('followers').doc(FirebaseAuth.instance.currentUser!.uid).get(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        if (snapshot.data?.exists ?? false) {
                                          return ElevatedButton(
                                            onPressed: () async {
                                              await doc.reference
                                                  .collection('followers')
                                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                                  .delete();
                                              setState(() {});
                                            },
                                            child: const Text('Unfollow'),
                                          );
                                        } else {
                                          return ElevatedButton(
                                            onPressed: () async {
                                              await doc.reference
                                                  .collection('followers')
                                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                                  .set({
                                                'time': DateTime.now(),
                                              });
                                              setState(() {});
                                            },
                                            child: const Text('Follow'),
                                          );
                                        }
                                      }
                                      // Handle error or unexpected state
                                      return const Text('Error loading data!!');
                                    }));
                          },
                        ),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  })
        ],
      )),
    );
  }
}
