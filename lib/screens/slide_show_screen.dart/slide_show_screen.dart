import 'package:flutter/material.dart';

class SlideShowScreen extends StatefulWidget {
  static const routeName = '/SlideShowScreen';
  static const title = 'Slide Show';
  const SlideShowScreen({super.key});

  @override
  State<SlideShowScreen> createState() => _SlideShowScreenState();
}

class _SlideShowScreenState extends State<SlideShowScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Slide Show"),
    );
  }
}