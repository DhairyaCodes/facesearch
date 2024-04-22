import 'package:facesearch/global/colors.dart';
import 'package:facesearch/screens/slide_show_screen.dart/slide_show_screen.dart';
import 'package:facesearch/screens/upload_screen/upload_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'global/private.dart';
import 'screens/auth_page/auth_page.dart';
import 'screens/tab_screen/tab_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: apiKey, // paste your api key here
      appId: appId, //paste your app id here
      messagingSenderId: messagingSenderId, //paste your messagingSenderId here
      projectId: projectId, //paste your project id here
      storageBucket: storage_bucket,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        AuthPage.routeName: (context) => AuthPage(),
        TabScreen.routeName: (context) => TabScreen(),
        SlideShowScreen.routeName: (context) => SlideShowScreen(),
        UploadScreen.routeName: (context) => UploadScreen(),
      },
      title: 'Face Search',
      // darkTheme: ThemeData(useMaterial3: true),
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        colorScheme: ColorScheme.dark(primary: kgreen, outline: kgreen.withOpacity(0.4)),
        snackBarTheme: SnackBarThemeData(
          // actionBackgroundColor: kgreen.withOpacity(0.7),
          backgroundColor: kgreen.withOpacity(0.5),
          contentTextStyle: TextStyle(color: kwhite)
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<auth.User?>(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            // print(snapshot.error);
            return const Scaffold(
              body: Center(
                child: Text(
                  "Something went Wrong. Please try again later",
                  style: TextStyle(color: kgrey, fontSize: 24),
                ),
              ),
            );
          } else if (snapshot.hasData) {
            return TabScreen();
          } else {
            return AuthPage();
          }
        },
        stream: auth.FirebaseAuth.instance.authStateChanges(),
      ),
    );
  }
}
