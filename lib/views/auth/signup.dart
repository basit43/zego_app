import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:zego_project/views/auth/login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _SignupState extends State<Signup> {
  //ensure username is unique before registration
  String? username;
  String? email;
  String? password;
  Future<bool> checkUserName(String username) async {
    print('checking username');
    try {
      final firestore = FirebaseFirestore.instance;
      final usernamesRef = firestore.collection('usernames');
      final docRef = usernamesRef.doc(username);
      final snapshot = await docRef.get();
      if (snapshot.exists) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      print('Error in checking username: $e');
    }
    return false;
  }

  Future<void> createUserDocument(String username) async {
    try {
      final firestore = FirebaseFirestore.instance;
      // Reference to the 'usernames' collection and document
      final usernamesRef = firestore.collection('usernames');
      final docRef = usernamesRef.doc(username);

      // Check if the document exists
      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        // Create the document with desired fields
        await docRef.set({
          'username': username,
          'created_at': DateTime.now(),
        });
        print('Document created successfully!');
      } else {
        print('Document already exists.');
      }
    } catch (e) {
      print('Error creating document: $e');
    }
  }

  Future<void> storeUserName(String? username) async {
    print('storing username');
    final firestore = FirebaseFirestore.instance;
    final usernamesRef = firestore.collection('usernames');
    final docRef = usernamesRef.doc(username);
    bool isPresent = await checkUserName(username!);
    if (!isPresent) {
      print('creating firestore && user');
      try {
        await createUserDocument(username);
      } catch (e) {
        print('The error is coming on $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(12.0),
          children: [
            TextFormField(
              decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Username'),
              validator: ValidationBuilder().maxLength(10).build(),
              onChanged: (value) {
                username = value;
              },
            ),
            SizedBox(
              height: 12,
            ),
            TextFormField(
              decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Email'),
              validator: ValidationBuilder().email().maxLength(50).build(),
              onChanged: (value) {
                email = value;
              },
            ),
            SizedBox(
              height: 12,
            ),
            TextFormField(
              decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Password'),
              validator: ValidationBuilder().maxLength(15).minLength(6).build(),
              onChanged: (value) {
                password = value;
              },
            ),
            SizedBox(
              height: 12,
            ),
            SizedBox(
                height: 40,
                child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        print('$email');
                        try {
                          // await storeUserName(username!);
                          UserCredential credential =
                              await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email!, password: password!);
                          if (credential.user != null) {
                            var data = {
                              'username': username,
                              'email': email,
                              'created_at': DateTime.now(),
                            };
                            //add it to database
                            await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set(data);
                          }
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => Login()),
                            (route) => false,
                          );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            print('The password provided is too week');
                          } else if (e.code == 'email-already-in-use') {
                            print('Email is already in use');
                          }
                        } catch (e) {
                          print('Error: $e');
                        }
                      }
                    },
                    child: Text('SignUp'))),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account?'),
                SizedBox(
                  width: 12,
                ),
                InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => Login(),
                      ));
                    },
                    child: Text('Login'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
