import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart' as aw;
import 'package:student_art_collection/core/presentation/widget/gallery_grid.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';
import 'package:student_art_collection/features/buy_art/presentation/bloc/artwork_details/artwork_details_bloc.dart';
import 'package:student_art_collection/features/buy_art/presentation/widget/carousel_image_viewer.dart';

import '../../../../service_locator.dart';

//for initial commit

class ArtworkDetailsPage extends StatelessWidget {
  static const ID = "/artwork_details";

  final aw.Artwork artwork;

  const ArtworkDetailsPage({Key key, @required this.artwork}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = artwork.title != '' ? artwork.title : 'Untitled';
    return BlocProvider<ArtworkDetailsBloc>(
      create: (context) => sl<ArtworkDetailsBloc>(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          centerTitle: true,
          title: Text(title),
        ),
        body: buildLoaded(context),
      ),
    );
  }

  Widget buildError() {
    return Container(
      child: Text('Error'),
    );
  }

  Widget buildLoaded(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double carouselHeight = screenHeight * .3;
    double smallBoxHeight = screenHeight * .07;
    double mediumBoxHeight = screenHeight * .17;
    double topBannerHeight = screenHeight * .06;


    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: topBannerHeight,
              alignment: Alignment.center,
              padding: EdgeInsets.all(8),
              child: Text('Want to purchase this piece? Fill out the form below'),
            ),
            Container(
              child: Stack(children: <Widget>[
                CarouselImageViewer(
                  artwork: artwork,
                  height: carouselHeight,
                ),
                Positioned(
                  bottom: 5,
                  left: 24,
                  child: Container(
                      child:Text("Wilting Roses" + "\n  " + "2017", textAlign: TextAlign.left,)),
                ),
                Positioned(
                  bottom: 5,
                  right: 16,
                  child: Container(
                  child: Text('Suggested Donation: \n \$' + '30', textAlign: TextAlign.center,),),
                ),
              ]),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: smallBoxHeight,
                    child: Center(child: Divider(
                      thickness: 1.5,
                    )),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                    height: smallBoxHeight,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Name',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(cardCornerRadius))
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    height: smallBoxHeight,
                    child: TextField(
                      decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(cardCornerRadius))
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    height: mediumBoxHeight,
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      minLines: 9,
                      maxLines: null,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                          labelText: 'Message',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(cardCornerRadius),)
                      ),
                    ),
                  ),

                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 16),
              alignment: Alignment.bottomRight,
              child: Container(
                width: 90,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(cardCornerRadius)
                ),
                child: FlatButton( onPressed: () {}, child: Text('Submit'),

                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
