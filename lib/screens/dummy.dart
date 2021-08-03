import 'package:flutter/material.dart';

class Dummy extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Page'),
      ),
      body: Center(
        child: Text(
          'Notification Opened',
          style: TextStyle(fontSize: 25.0),
        ),
      ),
    );
  }
}
