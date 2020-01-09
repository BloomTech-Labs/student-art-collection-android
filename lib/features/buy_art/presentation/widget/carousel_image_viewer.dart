import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/util/functions.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';

const double carouselCardCornerRadius = 10;


class CarouselImageViewer extends StatefulWidget {
  final Artwork artwork;
  final height;

  const CarouselImageViewer({Key key, @required this.artwork, @required this.height})
      : super(key: key);

  @override
  _CarouselImageViewerState createState() =>
      _CarouselImageViewerState(imageList: imageListToUrlList(artwork.images), height: height);
}

class _CarouselImageViewerState extends State<CarouselImageViewer> {
  final List<String> imageList;
  var height;
  int _current = 0;

  _CarouselImageViewerState({@required this.imageList, @required this.height});

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CarouselSlider(
            height: height,
            initialPage: 0,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            onPageChanged: (index) {
              setState(() {
                _current = index;
              });
            },
            items: imageList.map((imageUrl) {
              return Builder(
                builder: (BuildContext context) {
                  return Stack(children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(carouselCardCornerRadius),
                          color: Colors.white10,
                        border: Border.all(color: Colors.grey)
                      ),
                    ),
                    Container(child: Center(
                      child: CircularProgressIndicator(),
                    ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(carouselCardCornerRadius),
                        image: DecorationImage(
                            image: NetworkImage(imageUrl), fit: BoxFit.cover),
                      ),
                    ),
                  ]);
                },
              );
            }).toList(),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: map<Widget>(imageList, (index, imageUrl) {
              return Container(
                width: 10.0,
                height: 10.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index ? Colors.red.shade900 : primaryColor,
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}
