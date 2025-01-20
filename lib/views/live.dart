import 'package:flutter/material.dart';

class LivePage extends StatefulWidget {
  const LivePage({super.key});

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Page'),
      ),
      body: Column(
        children: [Text('This is my Live Page')],
      ),
    );
  }
}
