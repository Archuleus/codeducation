import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermoji.dart';

class AvatarCustomizer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customize Avatar"),
      ),
      body: FluttermojiCustomizer(),
    );
  }
}
