import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_art_collection/core/presentation/widget/build_loading.dart';
import 'package:student_art_collection/core/presentation/widget/gallery_grid.dart';
import 'package:student_art_collection/core/util/text_constants.dart';
import 'package:student_art_collection/features/buy_art/presentation/bloc/gallery/gallery_bloc.dart';
import '../../../../app_localization.dart';
import '../../../../service_locator.dart';
import 'artwork_details_page.dart';

class GalleryPage extends StatefulWidget {
  static const ID = "/gallery";

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  BuildContext _blocContext;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GalleryBloc>(
      create: (context) => sl<GalleryBloc>(),
      child: Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                buildInitial(_blocContext);
              },
            )
          ],
          centerTitle: true,
          title: Text(
            displayLocalizedString(context, TEXT_GALLERY_APP_BAR_TITLE),
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
              _blocContext = context;
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
        child: Text(
            displayLocalizedString(context, TEXT_GALLERY_ERROR_STATE_MESSAGE)));
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
          _scaffoldkey.currentContext,
          message,
        ),
        textAlign: TextAlign.center,
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
