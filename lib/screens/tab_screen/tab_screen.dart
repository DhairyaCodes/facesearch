import 'package:facesearch/screens/upload_screen/upload_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(600, 100, 0, 8000),
                items: [
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.logout),
                        Text("Logout"),
                      ],
                    ),
                    value: 1,
                  ),
                ],
                elevation: 8.0,
              ).then((value) async {
                if (value != null) {
                  if(value == 1){
                    await FirebaseAuth.instance.signOut();
                    // setState(() {
                      
                    // });
                  }
                }
              });
            },
          ),
        ],
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
