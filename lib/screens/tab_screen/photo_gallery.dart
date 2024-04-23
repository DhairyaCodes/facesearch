import 'package:facesearch/global/colors.dart';
import 'package:facesearch/reusable/custom_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class GalleryGrid extends StatefulWidget {
  bool
      animationControllerValue; // Pass _animationController value as a parameter
  GalleryGrid({required this.animationControllerValue});

  @override
  _GalleryGridState createState() => _GalleryGridState();
}

class _GalleryGridState extends State<GalleryGrid> {
  List<String>? _imageUrls;
  List<String> _selectedImages = [];

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  Future<void> _fetchImages() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('images')
        .doc(uid)
        .collection('userImages')
        .get();
    setState(() {
      _imageUrls =
          querySnapshot.docs.map((doc) => doc['url'] as String).toList();
    });
  }

  Future<void> _deleteSelectedImages() async {
    for (final imageUrl in _selectedImages) {
      // Delete image from Firebase Storage
      await FirebaseStorage.instance.refFromURL(imageUrl).delete();

      // Delete image URL from Firestore
      final imageRef = await FirebaseFirestore.instance
          .collection('images')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('userImages')
          .where('url', isEqualTo: imageUrl)
          .get();
      for (final doc in imageRef.docs) {
        await doc.reference.delete();
      }
    }

    showCustomSnackBar(context, "Deleted Successfully!");

    setState(() {
      _selectedImages.clear();
      _imageUrls = null;
      _fetchImages();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (widget.animationControllerValue == true) {
      setState(() {
        _selectedImages.clear();
        _imageUrls = null;
        _fetchImages();
        widget.animationControllerValue = false;
      });
    }
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "All Photos",
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.left,
              ),
              _selectedImages.length > 0
                  ? IconButton(
                      onPressed: _deleteSelectedImages,
                      icon: Icon(Icons.delete),
                    )
                  : Container(),
            ],
          ),
        ),
        _imageUrls == null
            ? Center(child: CircularProgressIndicator())
            : StaggeredGridView.countBuilder(
                physics: NeverScrollableScrollPhysics(
                    parent: NeverScrollableScrollPhysics()),
                crossAxisCount: 2,
                shrinkWrap: true,
                itemCount: _imageUrls!.length,
                itemBuilder: (BuildContext context, int index) =>
                    GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_selectedImages.contains(_imageUrls![index])) {
                        _selectedImages.remove(_imageUrls![index]);
                      } else {
                        _selectedImages.add(_imageUrls![index]);
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedImages.contains(_imageUrls![index])
                            ? kgreen.withOpacity(1)
                            : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(_imageUrls![index]),
                        fit: BoxFit.cover,
                        colorFilter:
                            _selectedImages.contains(_imageUrls![index])
                                ? ColorFilter.mode(
                                    kblack.withOpacity(0.5), BlendMode.overlay)
                                : null,
                      ),
                      // color: kgreen,
                    ),
                    height: (width - 32) / 2,
                    // width: 64,
                  ),
                ),
                staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
              )
      ],
    );
  }
}
