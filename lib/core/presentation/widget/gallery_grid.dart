import 'package:cached_network_image/cached_network_image.dart';
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
const double cardCornerRadius = 2.0;
const double staggeredGridMainAxisSpacing = 16.0;
const double staggeredGridCrossAxisSpacing = 16.0;

bool showTitleAnimations = false;
int prevIndex = 0;

void setShowTitleAnimations({@required int newIndex}) {
  int tempIndex = prevIndex;
  prevIndex = newIndex;
  if (tempIndex > newIndex) {
    showTitleAnimations = false;
  } else {
    showTitleAnimations = true;
  }
}

class GalleryGrid extends StatelessWidget {
  final List<aw.Artwork> artworkList;
  final bool isStaggered;
  final EdgeInsets padding;
  final int mainAxisSpacing;
  final int crossAxisSpacing;
  final Function(aw.Artwork, int index) onTap;
  final bool showEmptyArtworks;

  const GalleryGrid({
    Key key,
    @required this.artworkList,
    @required this.isStaggered,
    this.padding,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.onTap,
    this.showEmptyArtworks = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<aw.Artwork> validatedArtworkList;
    if (showEmptyArtworks) {
      validatedArtworkList = artworkList;
    } else {
      validatedArtworkList = artworkValidation(artworkList);
    }
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
            index: index,
            artwork: validatedArtworkList[index],
            onTap: (artwork) => onTap(artwork, index),
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
  final int index;
  final Function(aw.Artwork artwork) onTap;

  const GridTile({
    Key key,
    @required this.artwork,
    this.borderColor,
    this.setCornerRadius,
    this.onTap,
    this.index,
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
    setShowTitleAnimations(newIndex: index);

    final bool isAnimatedTitle = showTitleAnimations;

    return GestureDetector(
      onTap: onTap == null ? () {} : () => onTap(artwork),
      child: Material(
        elevation: 4,
        shadowColor: accentColor,
        child: Container(
          child: Center(
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: borderColor == null
                            ? gridBorderColor
                            : borderColor),
                    borderRadius: BorderRadius.circular(cornerRadius),
                    image: DecorationImage(
                      image: artwork.images.length > 0
                          ? CachedNetworkImageProvider(
                              artwork.images[0].imageUrl)
                          : CachedNetworkImageProvider(
                              'https://i.ytimg.com/vi/cX7ZVg2IoYw/maxresdefault.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Stack(children: <Widget>[
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
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
