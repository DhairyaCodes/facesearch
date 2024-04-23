import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facesearch/global/colors.dart';
import 'package:facesearch/reusable/dialog_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart' as Img;

import '../../reusable/custom_snackbar.dart';

class ImagePicker extends StatefulWidget {
  @override
  State<ImagePicker> createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker> {
  File? _pickImageFile;

  Future<void> _uploadImage(File img) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('images')
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child("${DateTime.now().millisecondsSinceEpoch.toString()}.jpg");

      await ref.putFile(img).whenComplete(() => null);
      final url = await ref.getDownloadURL();
      FirebaseFirestore.instance
          .collection("images")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("userImages")
          .doc()
          .set(
        {
          "url": url,
        },
      );
      showCustomSnackBar(context, "Uploaded Successfully!");
      setState(() {
        _pickImageFile = null;
      });
    } catch (e) {
      print(e);
      showCustomSnackBar(context, "An error occured. Please try again.");
    }
  }

  void _pickImage(int width) async {
    final imageFile = await Img.ImagePicker().pickImage(
      source: Img.ImageSource.gallery,
      preferredCameraDevice: Img.CameraDevice.rear,
      // maxWidth: width * 0.8,
      imageQuality: 100,
    );
    setState(() {
      _pickImageFile = File(imageFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _pickImage((width).round()),
            child: Container(
              width: width - 96,
              height: width - 96,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: kgreen.withOpacity(0.4),
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                  borderRadius: BorderRadius.circular(
                    8,
                  ),
                  color: kgreen.withOpacity(0.04)),
              child: _pickImageFile == null
                  ? Center(child: Text('Tap to select an Image'))
                  : Image(
                      image: FileImage(_pickImageFile!),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          SizedBox(
            height: 32,
          ),
          ElevatedButton(
            style: ButtonStyle(
                fixedSize: MaterialStatePropertyAll(Size(width, 48))),
            onPressed: () => _pickImageFile != null
                ? _uploadImage(_pickImageFile as File)
                : showCustomSnackBar(
                    context, "Please select an Image first."),
            child: Text(
              "Upload Image",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
