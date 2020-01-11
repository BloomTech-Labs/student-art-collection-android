import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_art_collection/core/presentation/widget/build_loading.dart';
import 'package:student_art_collection/core/presentation/widget/empty_container.dart';
import 'package:student_art_collection/core/presentation/widget/gallery_grid.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';
import 'package:student_art_collection/features/buy_art/presentation/bloc/gallery/gallery_bloc.dart';
import 'package:student_art_collection/features/list_art/presentation/widget/horizontal_progress_bar.dart';
import '../../../../service_locator.dart';
import 'artwork_details_page.dart';

class GalleryPage extends StatelessWidget {
  static const ID = "/gallery";

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GalleryBloc>(
      create: (context) => sl<GalleryBloc>(),
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          centerTitle: true,
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
            builder: (context, state) {
              if (state is GalleryLoadingState) {
                return BuildLoading();
              } else if (state is GalleryLoadedState) {
                return GalleryGrid(
                  artworkList: state.artworkList,
                  isStaggered: true,
                  onTap: (artwork) {
                    Navigator.pushNamed(context, ArtworkDetailsPage.ID,
                        arguments: artwork);
                  },
                );
              } else if (state is GalleryErrorState) {
                return buildError();
              } else
                return buildInitial(context);
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

  void getArtworkList(BuildContext context) {
    final galleryBloc = BlocProvider.of<GalleryBloc>(context);
    galleryBloc.add(GetArtworkList());
  }
}
