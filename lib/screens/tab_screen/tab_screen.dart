import 'package:facesearch/screens/upload_screen/upload_screen.dart';
import 'package:flutter/material.dart';

import '../slide_show_screen.dart/slide_show_screen.dart';

class TabScreen extends StatefulWidget {
  static const routeName = '/TabScreen';
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final _pages = [SlideShowScreen(), UploadScreen()];
  int _selectedIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIdx == 0 ? "Face Search" : "Upload Images"),
      ),
      body: SafeArea(
        child: _pages[_selectedIdx],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.slideshow,
            ),
            label: "Slide Show",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.upload,
            ),
            label: "Upload",
          ),
        ],
        currentIndex: _selectedIdx,
        onTap: (value) => setState(() {
          _selectedIdx = value;
        }),
      ),
    );
  }
}
