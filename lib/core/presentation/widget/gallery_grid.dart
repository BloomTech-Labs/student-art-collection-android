import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart' as aw;
import 'package:student_art_collection/core/util/functions.dart';
import 'package:student_art_collection/core/util/text_constants.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';

import '../../../app_localization.dart';

//determines the size ratios for image cards
const int staggerCount = 20;
//sets the number of rows
const int numOfRows = 2;
//sets the max image height based off of a ratio of the stagger count
const int maxImageHeight = 20;
//sets the min image height based off of a ratio of the stagger count
const int minImageHeight = 10;
//sets the radius of the image cards
const double cardCornerRadius = 10.0;
const double staggeredGridMainAxisSpacing = 16.0;
const double staggeredGridCrossAxisSpacing = 16.0;

class GalleryGrid extends StatelessWidget {
  final List<aw.Artwork> artworkList;
  final bool isStaggered;
  final EdgeInsets padding;
  final int mainAxisSpacing;
  final int crossAxisSpacing;
  final Function(aw.Artwork, int index) onTap;
  final bool heroOnURL;

  const GalleryGrid(
      {Key key,
      @required this.artworkList,
      @required this.isStaggered,
      this.padding,
      this.mainAxisSpacing,
      this.crossAxisSpacing,
      this.onTap,
      this.heroOnURL})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<aw.Artwork> validatedArtworkList = artworkValidation(artworkList);
    List<int> sizeList = [];
    for (int i = 0; i < validatedArtworkList.length; i++) {
      sizeList.add(randomInRange(
          (minImageHeight + maxImageHeight) ~/ 2.5, maxImageHeight));
    }

    return Padding(
      padding:
          padding == null ? EdgeInsets.only(left: 16.0, right: 16.0) : padding,
      child: StaggeredGridView.countBuilder(
        scrollDirection: Axis.vertical,
        crossAxisCount: staggerCount,
        itemCount: validatedArtworkList.length,
        itemBuilder: (BuildContext context, int index) => Padding(
          padding: (index == 0 || index == 1)
              ? const EdgeInsets.only(top: 16.0)
              : const EdgeInsets.all(0.0),
          child: GridTile(
            artwork: validatedArtworkList[index],
            onTap: (artwork) => onTap(artwork, index),
            heroOnURL: heroOnURL,
          ),
        ),
        staggeredTileBuilder: (int index) {
          StaggeredTile staggeredTile = StaggeredTile.count(
              staggerCount ~/ numOfRows,
              isStaggered == true
                  ? sizeList[index]
                  : (maxImageHeight + minImageHeight) / 2);
          return staggeredTile;
        },
        mainAxisSpacing: mainAxisSpacing == null ? 16.0 : mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing == null ? 16.0 : crossAxisSpacing,
      ),
    );
  }

  List<aw.Artwork> artworkValidation(List<aw.Artwork> invalidatedArtwork) {
    List<aw.Artwork> validatedArtwork = [];
    for (aw.Artwork artwork in invalidatedArtwork) {
      if (artwork.images.length != 0) {
        validatedArtwork.add(artwork);
      }
    }
    return validatedArtwork;
  }
}

class GridTile extends StatelessWidget {
  final aw.Artwork artwork;
  final double setCornerRadius;
  final Color borderColor;
  final bool heroOnURL;
  final Function(aw.Artwork artwork) onTap;

  const GridTile({
    Key key,
    @required this.artwork,
    this.borderColor,
    this.setCornerRadius,
    this.onTap,
    this.heroOnURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double cornerRadius =
        setCornerRadius == null ? cardCornerRadius : setCornerRadius;

    String title = artwork.title != ''
        ? artwork.title
        : AppLocalizations.of(context)
            .translate(TEXT_GALLERY_GRID_WIDGET_DEFAULT_ARTWORK_TITLE);

    title = title.length > 13 ? title.substring(0, 13) + '...' : title;

    return GestureDetector(
      onTap: onTap == null ? () {} : () => onTap(artwork),
      child: Container(
        child: Center(
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color:
                          borderColor == null ? gridBorderColor : borderColor),
                  borderRadius: BorderRadius.circular(cornerRadius),
                  image: DecorationImage(
                    image: NetworkImage(artwork.images[0].imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.5),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(cornerRadius),
                      bottomLeft: Radius.circular(cornerRadius),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                alignment: Alignment.bottomCenter,
                child: Text(
                  title,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
