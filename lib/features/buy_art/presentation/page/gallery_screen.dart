import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:student_art_collection/core/util/page_constants.dart';
import 'package:student_art_collection/core/util/util_fuctions.dart';

List<NetworkImage> images = List();
List<int> imageHeights = List();
int numOfRows = 2;
const int numberOfImages = 20;

NetworkImage generateImage() {
  var image = NetworkImage("https://picsum.photos/"
      "${randomInRange(heightMin, heightMax)}/"
      "${randomInRange(widthMin, widthMax)}");

  if (image != null) {
    return image;
  } else
    return NetworkImage(
        'https://upload.wikimedia.org/wikipedia/commons/6/66/RiP2013_Paramore_Hayley_Williams_0003.jpg');
}


void populateImages() {
  for (int i = 0; i < numberOfImages; i++) {
    imageHeights.add(randomInRange(minImageHeight, maxImageHeight));
    images.add(generateImage());
  }
}


class GalleryScreen extends StatefulWidget {

  static const ID = '/';

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    populateImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Art Collection'),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 5.0, right: 5.0),
          color: backgroundColor,
          child: StaggeredGridView.countBuilder(
            scrollDirection: Axis.vertical,
            crossAxisCount: staggerCount,
            itemCount: images.length,
            itemBuilder: (BuildContext context, int index) =>
                Stack(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        //  Navigator.pushNamed(context, '/details');
                      },
                      child: Container(
                        padding: EdgeInsets.all(2.0),
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(cardCornerRadius),
                              image: DecorationImage(
                                image: images[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              cardCornerRadius / 2),
                          color: Colors.black.withOpacity(.35),
                          backgroundBlendMode: BlendMode.multiply
                      ),
                      margin: EdgeInsets.only(left: 15, top: 15),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('\$20',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),),
                      ),
                    )
                  ],
                ),
            staggeredTileBuilder: (int index) {
              StaggeredTile staggeredTile = StaggeredTile.count(
                  staggerCount ~/ numOfRows, imageHeights[index]);
              return staggeredTile;
            },
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          ),
        ),
      ),
    );
  }}