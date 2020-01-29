import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/presentation/bloc/base_artwork_filter_type.dart';
import 'package:student_art_collection/core/presentation/bloc/base_artwork_sort_type.dart';
import 'package:student_art_collection/core/presentation/bloc/base_artwork_state.dart';
import 'package:student_art_collection/core/presentation/widget/build_loading.dart';
import 'package:student_art_collection/core/presentation/widget/empty_container.dart';
import 'package:student_art_collection/core/presentation/widget/filter_drawer.dart';
import 'package:student_art_collection/core/presentation/widget/gallery_grid.dart';
import 'package:student_art_collection/core/util/text_constants.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';
import 'package:student_art_collection/features/buy_art/presentation/bloc/gallery/gallery_bloc.dart';
import 'package:student_art_collection/features/list_art/presentation/widget/horizontal_progress_bar.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
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
  List<Artwork> artworks;

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

  Map<String, FilterType> filterTypes = {
    'zipcode': FilterTypeZipCode(
      zipcode: true,
    ),
    'category': FilterTypeCategory(),
    'search': FilterTypeSearch(),
  };

  @override
  Widget build(BuildContext context) {
    return FilterDrawer(
      innerDrawerKey: _innerDrawerKey,
      isSchool: false,
      onApplyPressed: (filters, sort) {
        filterTypes = filters;
        getArtworkList(sortType: sort, filterTypes: filterTypes);
        _toggle();
      },
      scaffold: BlocProvider<GalleryBloc>(
        create: (context) => sl<GalleryBloc>(),
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
              bottom: PreferredSize(
                preferredSize: Size(double.infinity, 1.0),
                child: BlocBuilder<GalleryBloc, GalleryState>(
                  builder: (context, state) {
                    _blocContext = context;
                    if (state is GalleryLoadingState) {
                      return AppBarLoading();
                    }
                    return EmptyContainer();
                  },
                ),
              ),
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
              title: Text(
                'Browse',
                style: TextStyle(
                  fontSize: 24,
                ),
              )),
          body: BlocListener<GalleryBloc, GalleryState>(
            listener: (context, state) {
              _blocContext = context;
              if (state is GalleryErrorState) {
                showSnackBar(context, state.message);
              }
            },
            child: BlocBuilder<GalleryBloc, GalleryState>(
              builder: (context, state) {
                _blocContext = context;
                if (state is GalleryLoadedState) {
                  artworks = state.artworkList;
                  return buildLoaded(artworkList: artworks);
                } else if (state is GalleryInitialState) return buildInitial();
                return EmptyContainer();
              },
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.transparent,
            child: TitledBottomNavigationBar(
              currentIndex: 0, // Use this to update the Bar giving a position
              onTap: (index) {
                print("Selected Index: $index");
              },
              items: [
                TitledNavigationBarItem(
                    title: displayLocalizedString(
                      context,
                      TEXT_SCHOOL_GALLERY_HOME_TAG,
                    ),
                    icon: Icons.home),
                TitledNavigationBarItem(
                    title: displayLocalizedString(
                      context,
                      TEXT_SCHOOL_GALLERY_CART_TAG,
                    ),
                    icon: Icons.shopping_cart),
              ],
              activeColor: accentColor,
            ),
            shape: CircularNotchedRectangle(),
            notchMargin: 4.0,
          ),
        ),
      ),
    );
  }

  Widget buildInitial() {
    getArtworkList(filterTypes: filterTypes);
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
    Map<String, FilterType> filterTypes,
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
