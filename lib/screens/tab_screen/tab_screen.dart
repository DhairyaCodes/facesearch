import 'package:facesearch/global/colors.dart';
import 'package:facesearch/screens/tab_screen/photo_gallery.dart';
import 'package:facesearch/screens/upload_screen/upload_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  bool _animationController = false;
  ValueNotifier<bool> _animationControllerNotifier = ValueNotifier<bool>(false); // ValueNotifier to track _animationController state

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomSheet: GestureDetector(
        onTap: () {
          setState(() {
            _animationController = !_animationController;
            // _scrollController.jumpTo(0);
            _scrollController.animateTo(0, duration: Duration(seconds: 1), curve: Curves.easeOut);
          });
        },
        child: SingleChildScrollView(
          child: AnimatedContainer(
            height: _animationController == false
                ? 72
                : MediaQuery.of(context).size.height / 2,
            width: width,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: _animationController == false ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 6,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: kgrey),
                      borderRadius: BorderRadius.circular(8),
                      color: kgrey,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: 48, // Set maximum width
                      maxHeight: 6, // Set maximum height
                    ),
                  ),
                  
                  ValueListenableBuilder<bool>(
                    valueListenable: _animationControllerNotifier,
                    builder: (context, value, child) {
                      return GalleryGrid(animationControllerValue: _animationController);
                    },
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
      //   height: 60,
      //   width: width,
      //   transform: ,
      //   duration: Duration(seconds: 4),
      //   child: Column(
      //     children: [
      //       Text("All Photos"),
      //     ],
      //   ),
      // ),
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
                  if (value == 1) {
                    await FirebaseAuth.instance.signOut();
                    await GoogleSignIn().signOut();
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
          _animationController = false;
          _scrollController.animateTo(0, duration: Duration(seconds: 1), curve: Curves.easeOut);
        }),
      ),
    );
  }
}
