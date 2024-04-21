import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as Image;

class ImagePicker extends StatefulWidget {
  @override
  State<ImagePicker> createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker> {
  File? _pickImageFile;

  Future<void> _uploadImage(File img) async {
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
  }

  void _pickImage() async {
    final imageFile = await Image.ImagePicker().pickImage(
      source: Image.ImageSource.camera,
      preferredCameraDevice: Image.CameraDevice.rear,
      maxWidth: 150,
      imageQuality: 60,
    );
    setState(() {
      _pickImageFile = File(imageFile!.path);
    });
    _pickImageFile != null ? _uploadImage(_pickImageFile as File) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.lightBlue,
            backgroundImage: _pickImageFile != null
                ? FileImage(_pickImageFile as File)
                : null,
          ),
          TextButton.icon(
            onPressed: _pickImage,
            icon: Icon(Icons.image),
            label: Text(
              "Add Image",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
