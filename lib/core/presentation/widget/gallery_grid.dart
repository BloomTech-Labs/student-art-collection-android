import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart' as aw;
import 'package:student_art_collection/core/util/fuctions.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';

import 'build_loading.dart';

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
  final Function(aw.Artwork) onTap;

  const GalleryGrid(
      {Key key,
        @required this.artworkList,
        @required this.isStaggered,
        this.padding,
        this.mainAxisSpacing,
        this.crossAxisSpacing,
        this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<int> sizeList = [];
    for (int i = 0; i< 1000; i++) {
      sizeList.add(randomInRange((minImageHeight+maxImageHeight)~/2.5, maxImageHeight));
    }

    return Padding(
      padding:
      padding == null ? EdgeInsets.only(left: 16.0, right: 16.0) : padding,
      child: StaggeredGridView.countBuilder(
        scrollDirection: Axis.vertical,
        crossAxisCount: staggerCount,
        itemCount: artworkList.length,
        itemBuilder: (BuildContext context, int index) => Stack(
          children: <Widget>[
            GridTile(
              artwork: artworkList[index],
              onTap: onTap,
            ),
          ],
        ),
        staggeredTileBuilder: (int index) {
          StaggeredTile staggeredTile = StaggeredTile.count(
              staggerCount ~/ numOfRows,
              isStaggered == true
                  ? sizeList[index]
                  : (maxImageHeight + minImageHeight) / 2);
          return staggeredTile;
        },
        mainAxisSpacing: mainAxisSpacing == null? 16.0 : mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing == null? 16.0 : crossAxisSpacing,
      ),
    );
  }
}

class GridTile extends StatelessWidget {
  final aw.Artwork artwork;
  final int cornerRadius;
  final Color borderColor;
  final Function(aw.Artwork artwork) onTap;

  const GridTile({
    Key key,
    @required this.artwork,
    this.borderColor,
    this.cornerRadius, this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap == null? (){} : () => onTap(artwork),
      child: Container(
        child: Center(
          child: Stack(
            children: <Widget>[
              BuildLoading(),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color:
                      borderColor == null ? gridBorderColor : borderColor),
                  borderRadius: BorderRadius.circular(
                      cornerRadius == null ? cardCornerRadius : cornerRadius),
                  image: DecorationImage(
                    image: NetworkImage(artwork.images[0].imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}