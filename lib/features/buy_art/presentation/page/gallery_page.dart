import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_art_collection/core/presentation/widget/build_loading.dart';
import 'package:student_art_collection/core/presentation/widget/empty_container.dart';
import 'package:student_art_collection/core/presentation/widget/gallery_grid.dart';
import 'package:student_art_collection/core/util/text_constants.dart';
import 'package:student_art_collection/features/buy_art/presentation/bloc/gallery/gallery_bloc.dart';
import 'package:student_art_collection/features/list_art/presentation/widget/horizontal_progress_bar.dart';
import '../../../../app_localization.dart';
import '../../../../service_locator.dart';
import 'artwork_details_page.dart';

class GalleryPage extends StatelessWidget {
  static const ID = "/gallery";

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GalleryBloc>(
      create: (context) => sl<GalleryBloc>(),
      child: Scaffold(
        key: _scaffoldkey,
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          centerTitle: true,
          title: Text(AppLocalizations.of(context)
              .translate(TEXT_GALLERY_APP_BAR_TITLE)),
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
                return buildLoaded(
                    artworkList: state.artworkList, context: context);
              } else if (state is GalleryErrorState) {
                return buildError(context: context);
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
    return Center();
  }

  Widget buildError({@required BuildContext context}) {
    return Center(
        child: Text(AppLocalizations.of(context)
            .translate(TEXT_GALLERY_ERROR_STATE_MESSAGE)));
  }

  Widget buildLoaded({@required BuildContext context, @required artworkList}) {
    return GalleryGrid(
      artworkList: artworkList,
      isStaggered: true,
      onTap: (artwork, index) async {
        final result = await Navigator.pushNamed(context, ArtworkDetailsPage.ID,
            arguments: artwork);
        if (result != null) {
          showSnackBar(context, result);
        }
      },
    );
  }

  String displayLocalizedString(BuildContext context, String label) {
    return AppLocalizations.of(context).translate(label);
  }

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        displayLocalizedString(
          context,
          message,
        ), textAlign: TextAlign.center,
      ),
    );
    _scaffoldkey.currentState.showSnackBar(snackBar);
  }

  void getArtworkList(BuildContext context) {
    // ignore: close_sinks
    final galleryBloc = BlocProvider.of<GalleryBloc>(context);
    galleryBloc.add(GetArtworkList());
  }
}
