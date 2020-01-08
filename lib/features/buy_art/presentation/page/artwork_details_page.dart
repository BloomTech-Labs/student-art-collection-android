import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart' as aw;
import 'package:student_art_collection/core/util/functions.dart';

class ArtworkDetailsPage extends StatelessWidget {
  static const ID = "/artwork_details";

  final aw.Artwork artwork;

  const ArtworkDetailsPage({Key key, @required this.artwork}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildLoaded();
  }

  Widget buildError() {
    return Container(
      child: Text('Error'),
    );
  }

  Widget buildLoaded() {
    List<String> imageUrls = imageListToUrlList(artwork.images);
    return Container(child: CarouselImageViewer(imageList: imageUrls));
  }
}

class CarouselImageViewer extends StatefulWidget {
  final List<String> imageList;

  const CarouselImageViewer({Key key, @required this.imageList})
      : super(key: key);

  @override
  _CarouselImageViewerState createState() =>
      _CarouselImageViewerState(imageList: imageList);
}

class _CarouselImageViewerState extends State<CarouselImageViewer> {
  final List<String> imageList;
  int _current = 0;
  _CarouselImageViewerState({@required this.imageList});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CarouselSlider(
            height: 400.0,
            initialPage: 0,
            onPageChanged: (index) {
              setState(() {
                _current = index;
              });
            },
            items: imageList.map((imageUrl) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(color: Colors.green),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.fill,
                    ),
                  );
                },
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
