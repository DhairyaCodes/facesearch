import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facesearch/global/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SlideShowScreen extends StatefulWidget {
  static const routeName = '/SlideShowScreen';
  static const title = 'Slide Show';
  const SlideShowScreen({super.key});

  @override
  State<SlideShowScreen> createState() => _SlideShowScreenState();
}

class _SlideShowScreenState extends State<SlideShowScreen> {
  Future<String> fetchUrl() async {
    final doc = await FirebaseFirestore.instance
        .collection("images")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("userImages")
        .doc("BEDIkBxYyxpFi5nyS7ko")
        .get();
    final collection = FirebaseFirestore.instance
        .collection("images")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("userImages");
    final querySnapshot = await collection.get();
    final documents = querySnapshot.docs;
    if (documents.isNotEmpty) {
      final randomDoc = documents[Random().nextInt(documents.length)];
      if (randomDoc.exists) {
        Map<String, dynamic> data = randomDoc.data() as Map<String, dynamic>;
        return data["url"];
      }
    } else {
      return "No Images Uploaded";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              width: width - 32,
              height: width * 4 / 3,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                border: Border.all(color: kgreen.withOpacity(0.4), strokeAlign: BorderSide.strokeAlignOutside, width: 4),
                borderRadius: BorderRadius.circular(
                  8,
                ),
              ),
              child: StreamBuilder<String>(
                stream: Stream.periodic(Duration(seconds: 2))
                    .asyncMap((_) => fetchUrl()),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == "No Images Uploaded") {
                      return Center(child: Text("No Images Uploaded"));
                    } else if (snapshot.data == "") {
                      return Center(child: Text("Something Went Wrong"));
                    }
                    return Image.network(snapshot.data as String,
                        fit: BoxFit.cover);
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error as String);
                  } else {
                    return Text("Something Went Wrong");
                  }
                },
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Your Slide Show!",
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
