import 'package:flutter/material.dart';

class PreLoginScreen extends StatefulWidget {
  PreLoginScreen(this.children);
  final children;

  @override
  _PreLoginScreenState createState() => _PreLoginScreenState(children);
}

class _PreLoginScreenState extends State<PreLoginScreen> {
  _PreLoginScreenState(this.children);
  final children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to TOPtodo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}
