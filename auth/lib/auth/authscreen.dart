import 'package:flutter/material.dart';
import 'package:todoapp/auth/authform.dart';

class Authscreen extends StatefulWidget {
  @override
  _AuthscreenState createState() => _AuthscreenState();
}

class _AuthscreenState extends State<Authscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auththentication'),
      ),
      body: Authform(),
    );
  }
}
