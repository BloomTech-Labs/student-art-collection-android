import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart' as aw;
import 'package:student_art_collection/core/presentation/widget/build_loading.dart';
import 'package:student_art_collection/core/presentation/widget/empty_container.dart';
import 'package:student_art_collection/core/util/fuctions.dart';
import 'package:student_art_collection/core/util/page_constants.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';
import 'package:student_art_collection/features/buy_art/presentation/bloc/gallery/gallery_bloc.dart';
import 'package:student_art_collection/features/list_art/presentation/widget/horizontal_progress_bar.dart';

import '../../../../service_locator.dart';
import 'artwork_details_page.dart';


class GalleryPage extends StatelessWidget{

  static const ID = "/gallery";

  @override
  Widget build(BuildContext context) {
    return  BlocProvider<GalleryBloc>(
      create: (context) => sl<GalleryBloc>(),
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text('Student Art Gallery'),
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 1.0),
            child: BlocBuilder<GalleryBloc, GalleryState>(
              builder: (context, state) {
                if (state is GalleryLoadingState) {
                  return AppBarLoading();
                } else
                  return EmptyContainer();
              },
            ),
          ),
        ),
        body: BlocListener<GalleryBloc, GalleryState>(
          listener: (context, state) {
            if (state is GalleryErrorState) {
              final snackBar = SnackBar(content: Text(state.message));
              Scaffold.of(context).showSnackBar(snackBar);
            }
          },
          child: BlocBuilder<GalleryBloc, GalleryState>(
            builder: (context, state){
              if(state is GalleryLoadingState){
                return BuildLoading();
              }else if (state is GalleryLoadedState){
                return StaggeredGrid(artworkList: state.artworkList);
              }else if (state is GalleryErrorState){
                return buildError();
              }else return buildInitial(context);
            },
          ),
        ),
      ),
    );
  }


  Widget buildInitial(BuildContext context) {
    getArtworkList(context);
    return Center(child: Text("initial"));
  }

  Widget buildError() {
    return Center(child: Text("error"));
  }

  void getArtworkList(BuildContext context){
    final galleryBloc = BlocProvider.of<GalleryBloc>(context);
    galleryBloc.add(GetArtworkList());
  }
}

class StaggeredGrid extends StatelessWidget {
  final List<aw.Artwork> artworkList;
  const StaggeredGrid({Key key, this.artworkList}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<int> sizeList = [];
    for(aw.Artwork artwork in artworkList){
      sizeList.add(randomInRange(14, 20));
    }

    return Padding(
      padding: const EdgeInsets.only(left:16.0, right:16.0),
      child: StaggeredGridView.countBuilder(
        scrollDirection: Axis.vertical,
        crossAxisCount: staggerCount,
        itemCount: artworkList.length,
        itemBuilder: (BuildContext context, int index) => Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(ArtworkDetailsPage.ID, arguments: artworkList[index]);
                //Navigate to carousel view
              },
              child: StaggeredGridTile(
                artwork: artworkList[index],
              ),
            ),
          ],
        ),
        staggeredTileBuilder: (int index) {
          StaggeredTile staggeredTile =
          StaggeredTile.count(staggerCount ~/ numOfRows, sizeList[index]);
          return staggeredTile;
        },
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
      ),
    );
  }
}

class StaggeredGridTile extends StatelessWidget {
  final aw.Artwork artwork;

  const StaggeredGridTile({
    Key key,
    this.artwork,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Stack(
          children: <Widget>[
            BuildLoading(),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: imageBorderColor),
                borderRadius: BorderRadius.circular(cardCornerRadius),
                image: DecorationImage(
                  image: NetworkImage(artwork.images[0].imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




