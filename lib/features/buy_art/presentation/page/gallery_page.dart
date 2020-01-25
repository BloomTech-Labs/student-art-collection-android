import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:student_art_collection/core/presentation/bloc/base_artwork_filter_type.dart';
import 'package:student_art_collection/core/presentation/bloc/base_artwork_sort_type.dart';
import 'package:student_art_collection/core/presentation/bloc/base_artwork_state.dart';
import 'package:student_art_collection/core/presentation/widget/build_loading.dart';
import 'package:student_art_collection/core/presentation/widget/filter_drawer.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  BuildContext _blocContext;

  //  Current State of InnerDrawerState
  final GlobalKey<InnerDrawerState> _innerDrawerKey =
      GlobalKey<InnerDrawerState>();

  void _toggle() {
    _innerDrawerKey.currentState.toggle(
        // direction is optional
        // if not set, the last direction will be used
        //InnerDrawerDirection.start OR InnerDrawerDirection.end
        direction: InnerDrawerDirection.end);
  }

  @override
  Widget build(BuildContext context) {
    return FilterDrawer(
      innerDrawerKey: _innerDrawerKey,
      isSchool: false,
      onApplyPressed: (filters, sort) {
        getArtworkList(sortType: sort, filterTypes: filters);
        _toggle();
      },
      scaffold: BlocProvider<GalleryBloc>(
        create: (context) => sl<GalleryBloc>(),
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  buildInitial();
                },
              ),
              IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: () {
                  _toggle();
                },
              ),
            ],
            centerTitle: true,
            title: Hero(
              tag: 'logo',
              child: SvgPicture.asset(
                'assets/artco_logo_large.svg',
                color: Colors.white,
                semanticsLabel: 'App Logo',
                fit: BoxFit.contain,
              ),
            ),
          ),
          body: BlocListener<GalleryBloc, GalleryState>(
            listener: (context, state) {
              _blocContext = context;
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
                  return buildLoaded(artworkList: state.artworkList);
                } else if (state is GalleryErrorState) {
                  return buildError(context: context);
                } else
                  return buildInitial();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInitial() {
    getArtworkList();
    return Center();
  }

  Widget buildError({@required BuildContext context}) {
    return Center(
        child: Text(
            displayLocalizedString(context, TEXT_GALLERY_ERROR_STATE_MESSAGE)));
  }

  Widget buildLoaded({@required artworkList}) {
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
          _scaffoldKey.currentContext,
          message,
        ),
        textAlign: TextAlign.center,
      ),
    );
    _scaffoldKey.currentState.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void getArtworkList({
    List<FilterType> filterTypes,
    SortType sortType,
  }) {
    // ignore: close_sinks
    final galleryBloc = BlocProvider.of<GalleryBloc>(_blocContext);
    galleryBloc.add(GetArtworkList(
      sortType: sortType,
      filterTypes: filterTypes,
    ));
  }
}
