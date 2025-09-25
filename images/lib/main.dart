import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Working with Images'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // First image from the internet
                Image.network(
                  'https://nuv.ac.in/wp-content/uploads/new-logo.png',
                  width: 400,
                  height: 200,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 20),

                // Second image from the internet
                Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/1/17/Google-flutter-logo.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 20),

                // Large text
                Text(
                  'Welcome to NUV',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 50.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
