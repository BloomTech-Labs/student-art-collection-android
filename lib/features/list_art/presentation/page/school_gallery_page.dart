import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/presentation/bloc/base_artwork_filter_type.dart';
import 'package:student_art_collection/core/presentation/bloc/base_artwork_sort_type.dart';
import 'package:student_art_collection/core/presentation/bloc/base_artwork_state.dart';
import 'package:student_art_collection/core/presentation/page/login_page.dart';
import 'package:student_art_collection/core/presentation/widget/app_bar_logo.dart';
import 'package:student_art_collection/core/presentation/widget/empty_container.dart';
import 'package:student_art_collection/core/presentation/widget/filter_drawer.dart';
import 'package:student_art_collection/core/presentation/widget/gallery_grid.dart';
import 'package:student_art_collection/core/util/text_constants.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';
import 'package:student_art_collection/features/buy_art/presentation/page/gallery_page.dart';
import 'package:student_art_collection/features/list_art/presentation/artwork_to_return.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/gallery/school_gallery_bloc.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/gallery/school_gallery_event.dart';
import 'package:student_art_collection/features/list_art/presentation/page/artwork_upload_page.dart';
import 'package:student_art_collection/features/list_art/presentation/widget/horizontal_progress_bar.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

import '../../../../app_localization.dart';
import '../../../../service_locator.dart';

class SchoolGalleryPage extends StatefulWidget {
  static const String ID = "schoolgallery";

  @override
  _SchoolGalleryPageState createState() => _SchoolGalleryPageState();
}

class _SchoolGalleryPageState extends State<SchoolGalleryPage> {
  GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>(); // The app's "state".
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

  List<Artwork> artworks;

  void _select(SchoolGalleryChoice choice) {
    if (choice.title == 'Logout') {
      _dispatchLogoutEvent();
    } else if (choice.title == 'Buyer') {
      Navigator.pushNamed(context, GalleryPage.ID);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilterDrawer(
      isSchool: true,
      onApplyPressed: (filters, sort) {
        _dispatchGetSchoolArtEvent(
          sortType: sort,
          filterTypes: filters,
        );
        _toggle();
      },
      innerDrawerKey: _innerDrawerKey,
      scaffold: BlocProvider<SchoolGalleryBloc>(
        create: (context) => sl<SchoolGalleryBloc>(),
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            bottom: PreferredSize(
              preferredSize: Size(double.infinity, 1.0),
              child: BlocBuilder<SchoolGalleryBloc, GalleryState>(
                builder: (context, state) {
                  _blocContext = context;
                  if (state is GalleryLoadingState) {
                    return AppBarLoading();
                  }
                  return EmptyContainer();
                },
              ),
            ),
            centerTitle: true,
            actions: <Widget>[
              PopupMenuButton<SchoolGalleryChoice>(
                icon: Icon(Icons.settings),
                elevation: 4,
                onSelected: _select,
                itemBuilder: (context) {
                  return schoolGalleryChoices.map((SchoolGalleryChoice choice) {
                    return PopupMenuItem<SchoolGalleryChoice>(
                      height: 20.0,
                      value: choice,
                      child: Material(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              choice.title,
                              style: TextStyle(
                                backgroundColor: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList();
                },
              ),
              IconButton(
                onPressed: () {
                  _toggle();
                },
                icon: Icon(Icons.filter_list),
              )
            ],
            title: Text(
              'Admin',
              style: TextStyle(fontSize: 24),
            ),
          ),
          body: BlocListener<SchoolGalleryBloc, GalleryState>(
            listener: (context, state) {
              _blocContext = context;
              if (state is Unauthorized) {
                Navigator.pushReplacementNamed(context, LoginPage.ID);
              } else if (state is GalleryErrorState) {
                showSnackBar(state.message);
              }
            },
            child: BlocBuilder<SchoolGalleryBloc, GalleryState>(
              builder: (context, state) {
                _blocContext = context;
                if (state is GalleryLoadedState) {
                  artworks = state.artworkList;
                  return GalleryGrid(
                    showEmptyArtworks: true,
                    artworkList: artworks,
                    isStaggered: false,
                    onTap: (artwork, index) async {
                      final result = await Navigator.pushNamed(
                          context, ArtworkUploadPage.ID,
                          arguments: artwork);
                      if (result is ArtworkToReturn) {
                        showSnackBar(result.message);
                        if (result.tag == 'update') {
                          setState(() {
                            artworks[index] = result.artwork;
                          });
                        } else if (result.tag == 'delete') {
                          setState(() {
                            artworks.removeAt(index);
                          });
                        }
                      }
                    },
                  );
                } else if (state is GalleryInitialState) {
                  _dispatchGetSchoolArtEvent();
                }
                return EmptyContainer();
              },
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton(
            elevation: 6.0,
            child: Icon(
              Icons.add,
            ),
            backgroundColor: accentColor,
            onPressed: () async {
              final result =
                  await Navigator.pushNamed(context, ArtworkUploadPage.ID);
              if (result is ArtworkToReturn) {
                showSnackBar(result.message);
                setState(() {
                  artworks.add(result.artwork);
                });
              }
            },
          ),
        ),
      ),
    );
  }

  void _dispatchGetSchoolArtEvent({
    Map<String, FilterType> filterTypes,
    SortType sortType,
  }) {
    BlocProvider.of<SchoolGalleryBloc>(_blocContext).add(
      GetAllSchoolArtworkEvent(
        sortType: sortType,
        filterTypes: filterTypes,
      ),
    );
  }

  void _dispatchLogoutEvent() {
    BlocProvider.of<SchoolGalleryBloc>(_blocContext).add(
      LogoutEvent(),
    );
  }

  void showSnackBar(String message) {
    final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(displayLocalizedString(
          message,
        )));
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  String displayLocalizedString(String label) {
    return AppLocalizations.of(context).translate(label);
  }
}

class SchoolGalleryChoice {
  const SchoolGalleryChoice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<SchoolGalleryChoice> schoolGalleryChoices =
    const <SchoolGalleryChoice>[
  const SchoolGalleryChoice(title: 'Logout'),
  const SchoolGalleryChoice(title: 'Buyer'),
];
