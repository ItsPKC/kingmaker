import 'package:flutter/material.dart';

class MySetting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 0, 0, 1),
        leading: Icon(
          Icons.settings,
          size: 32,
        ),
        title: Text(
          'my Settings',
          style: TextStyle(
            fontSize: 28,
            fontFamily: 'Signika',
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: Text('Setting'),
    );
  }
}
