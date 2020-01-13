import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart' as aw;
import 'package:student_art_collection/core/presentation/widget/build_loading.dart';
import 'package:student_art_collection/core/util/functions.dart';
import 'package:student_art_collection/core/util/text_constants.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';

import '../../../app_localization.dart';

const double carouselCardCornerRadius = 10;

class CarouselImageViewer extends StatefulWidget {
  final aw.Artwork artwork;
  final height;
  final bool isEditable;
  final List<String> imageList;

  const CarouselImageViewer(
      {Key key,
      @required this.artwork,
      @required this.height,
      this.isEditable,
      this.imageList})
      : super(key: key);

  @override
  _CarouselImageViewerState createState() => _CarouselImageViewerState(
      imageList:
          artwork != null ? imageListToUrlList(artwork.images) : imageList,
      height: height,
      isEditable: isEditable,
      artistName: artwork != null ? artwork.artistName : "");
}

class _CarouselImageViewerState extends State<CarouselImageViewer> {
  final List imageList;
  var height;
  bool isEditable = false;
  final String artistName;
  int _current = 0;

  _CarouselImageViewerState(
      {this.artistName,
      @required this.imageList,
      @required this.height,
      @required this.isEditable});

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
            items: imageList.map((imageType) {
              int index = imageList.indexOf(imageType);
              return Builder(
                builder: (BuildContext context) {
                  return Stack(
                    children: <Widget>[
                      imageBorderWidget(context: context),
                      BuildLoading(),
                      imageType is String
                          ? imageUrlWidget(
                              context: context, imageUrl: imageType)
                          : imageFileWidget(
                              context: context, imageFile: imageType),
                      !isEditable
                          ? artistNameWidget()
                          : closeButton(onPressed: () {
                              setState(() {
                                imageList.removeAt(index);
                              });
                            })
                    ],
                  );
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
                  color: _current == index ? accentColor : primaryColor,
                ),
              );
            }),
          )
        ],
      ),
    );
  }

  Widget imageBorderWidget({@required BuildContext context}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(right: 16.0, left: 16, top: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(carouselCardCornerRadius),
          color: Colors.white10,
          border: Border.all(color: Colors.grey)),
    );
  }

  Widget imageFileWidget(
      {@required BuildContext context, @required var imageFile}) {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(right: 16.0, left: 16, top: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(carouselCardCornerRadius),
          image: DecorationImage(
            image: FileImage(imageFile),
            fit: BoxFit.fill,
          ),
        ));
  }

  Widget imageUrlWidget(
      {@required BuildContext context, @required String imageUrl}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(right: 16.0, left: 16, top: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(carouselCardCornerRadius),
        image:
            DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
      ),
    );
  }

  Widget artistNameWidget() {
    return Positioned(
      child: Container(
        child: Text(
          artistName == ""
              ? AppLocalizations.of(context)
                  .translate(TEXT_CAROUSEL_WIDGET_DEFAULT_STUDENT_NAME)
              : artistName,
          style: TextStyle(color: Colors.white),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(carouselCardCornerRadius / 2),
            color: Colors.black.withOpacity(.5)),
        padding: EdgeInsets.all(4),
      ),
      right: 24,
      bottom: 8,
    );
  }

  Widget closeButton({@required Function onPressed}) {
    return Positioned(
      right: 6,
      top: 0,
      child: Container(
        decoration: BoxDecoration(
            color: accentColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.4),
                blurRadius: 1.0,
                spreadRadius: 1.0,
                offset: Offset(1, 1.5),
              )
            ]),
        child: GestureDetector(
            onTap: onPressed,
            child: Icon(
              Icons.close,
              color: Colors.white,
            )),
      ),
    );
  }
}
