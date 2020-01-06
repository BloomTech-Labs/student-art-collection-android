import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart' as aw;
import 'package:student_art_collection/core/presentation/widget/build_loading.dart';
import 'package:student_art_collection/core/util/fuctions.dart';
import 'package:student_art_collection/core/util/page_constants.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';

class GalleryScreen extends StatefulWidget {
  static const ID = '/gallery';


  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    List<aw.Artwork> mockArtwork = [
      aw.Artwork(artId: 1, images: [
        aw.Image(imageId: 1, artId: 1, imageUrl: 'https://picsum.photos/600/900'),
        aw.Image(imageId: 2, artId: 1, imageUrl: 'https://picsum.photos/600/900'),
        aw.Image(imageId: 3, artId: 1, imageUrl: 'https://picsum.photos/600/900')],
          price: 25, schoolId: 1 ),
      aw.Artwork(artId: 1, images: [
        aw.Image(imageId: 1, artId: 1, imageUrl: 'https://picsum.photos/601/900'),
        aw.Image(imageId: 2, artId: 1, imageUrl: 'https://picsum.photos/600/900'),
        aw.Image(imageId: 3, artId: 1, imageUrl: 'https://picsum.photos/600/900')],
          price: 25, schoolId: 1 ),
      aw.Artwork(artId: 1, images: [
        aw.Image(imageId: 1, artId: 1, imageUrl: 'https://picsum.photos/602/900'),
        aw.Image(imageId: 2, artId: 1, imageUrl: 'https://picsum.photos/600/900'),
        aw.Image(imageId: 3, artId: 1, imageUrl: 'https://picsum.photos/600/900')],
          price: 25, schoolId: 1 ),
      aw.Artwork(artId: 1, images: [
        aw.Image(imageId: 1, artId: 1, imageUrl: 'https://picsum.photos/603/900'),
        aw.Image(imageId: 2, artId: 1, imageUrl: 'https://picsum.photos/600/900'),
        aw.Image(imageId: 3, artId: 1, imageUrl: 'https://picsum.photos/600/900')],
          price: 25, schoolId: 1 ),
      aw.Artwork(artId: 1, images: [
        aw.Image(imageId: 1, artId: 1, imageUrl: 'https://picsum.photos/604/900'),
        aw.Image(imageId: 2, artId: 1, imageUrl: 'https://picsum.photos/600/900'),
        aw.Image(imageId: 3, artId: 1, imageUrl: 'https://picsum.photos/600/900')],
          price: 25, schoolId: 1 ),
      aw.Artwork(artId: 1, images: [
        aw.Image(imageId: 1, artId: 1, imageUrl: 'https://picsum.photos/605/900'),
        aw.Image(imageId: 2, artId: 1, imageUrl: 'https://picsum.photos/600/900'),
        aw.Image(imageId: 3, artId: 1, imageUrl: 'https://picsum.photos/600/900')],
          price: 25, schoolId: 1 ),
      aw.Artwork(artId: 1, images: [
        aw.Image(imageId: 1, artId: 1, imageUrl: 'https://picsum.photos/606/900'),
        aw.Image(imageId: 2, artId: 1, imageUrl: 'https://picsum.photos/600/900'),
        aw.Image(imageId: 3, artId: 1, imageUrl: 'https://picsum.photos/600/900')],
          price: 25, schoolId: 1 ),
      aw.Artwork(artId: 1, images: [
        aw.Image(imageId: 1, artId: 1, imageUrl: 'https://picsum.photos/607/900'),
        aw.Image(imageId: 2, artId: 1, imageUrl: 'https://picsum.photos/600/900'),
        aw.Image(imageId: 3, artId: 1, imageUrl: 'https://picsum.photos/600/900')],
          price: 25, schoolId: 1 ),
      aw.Artwork(artId: 1, images: [
        aw.Image(imageId: 1, artId: 1, imageUrl: 'https://picsum.photos/608/900'),
        aw.Image(imageId: 2, artId: 1, imageUrl: 'https://picsum.photos/600/900'),
        aw.Image(imageId: 3, artId: 1, imageUrl: 'https://picsum.photos/600/900')],
          price: 25, schoolId: 1 ),
      aw.Artwork(artId: 1, images: [
        aw.Image(imageId: 1, artId: 1, imageUrl: 'https://picsum.photos/609/900'),
        aw.Image(imageId: 2, artId: 1, imageUrl: 'https://picsum.photos/600/900'),
        aw.Image(imageId: 3, artId: 1, imageUrl: 'https://picsum.photos/600/900')],
          price: 25, schoolId: 1 ),
      aw.Artwork(artId: 1, images: [
        aw.Image(imageId: 1, artId: 1, imageUrl: 'https://picsum.photos/610/900'),
        aw.Image(imageId: 2, artId: 1, imageUrl: 'https://picsum.photos/600/900'),
        aw.Image(imageId: 3, artId: 1, imageUrl: 'https://picsum.photos/600/900')],
          price: 25, schoolId: 1 ),
      aw.Artwork(artId: 1, images: [
        aw.Image(imageId: 1, artId: 1, imageUrl: 'https://picsum.photos/611/900'),
        aw.Image(imageId: 2, artId: 1, imageUrl: 'https://picsum.photos/600/900'),
        aw.Image(imageId: 3, artId: 1, imageUrl: 'https://picsum.photos/600/900')],
          price: 25, schoolId: 1 ),
      aw.Artwork(artId: 1, images: [
        aw.Image(imageId: 1, artId: 1, imageUrl: 'https://picsum.photos/612/900'),
        aw.Image(imageId: 2, artId: 1, imageUrl: 'https://picsum.photos/600/900'),
        aw.Image(imageId: 3, artId: 1, imageUrl: 'https://picsum.photos/600/900')],
          price: 25, schoolId: 1 ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Student Art Collection'),
      ),
      body: buildStaggeredGridViewWithData(context, mockArtwork),);
  }
}

Widget buildInitial(){
  return Center(
  );
}

Widget buildStaggeredGridViewWithData(BuildContext context, List<aw.Artwork> artworkList){
List<int> sizeList = [];
  for(aw.Artwork artwork in artworkList){
    sizeList.add(randomInRange(12, 20));
  }

  return StaggeredGridView.countBuilder(
    scrollDirection: Axis.vertical,
    crossAxisCount: staggerCount,
    itemCount: artworkList.length,
    itemBuilder: (BuildContext context, int index) => Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            //Navigate to carousel view
          },
          child: Container(
            padding: EdgeInsets.all(2.0),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(cardCornerRadius),
                  image: DecorationImage(
                    image: NetworkImage(artworkList[index].images[0].imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
    staggeredTileBuilder: (int index) {
      StaggeredTile staggeredTile = StaggeredTile.count(
          staggerCount ~/ numOfRows,
          sizeList[index]);
      return staggeredTile;
    },
    mainAxisSpacing: 16.0,
    crossAxisSpacing: 16.0,
  );
}

