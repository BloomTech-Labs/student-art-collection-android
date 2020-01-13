import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/presentation/page/login_page.dart';
import 'package:student_art_collection/core/presentation/widget/empty_container.dart';
import 'package:student_art_collection/core/presentation/widget/gallery_grid.dart';
import 'package:student_art_collection/core/util/text_constants.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';
import 'package:student_art_collection/features/list_art/presentation/artwork_to_return.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/gallery/school_gallery_bloc.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/gallery/school_gallery_event.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/gallery/school_gallery_state.dart';
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
  GlobalKey<ScaffoldState> _scaffoldkey =
      new GlobalKey<ScaffoldState>(); // The app's "state".
  BuildContext _blocContext;

  List<Artwork> artworks;

  void _select(SchoolGalleryChoice choice) {
    if (choice.title == 'Logout') {
      _dispatchLogoutEvent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SchoolGalleryBloc>(
      create: (context) => sl<SchoolGalleryBloc>(),
      child: Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          actions: <Widget>[
            PopupMenuButton<SchoolGalleryChoice>(
              onSelected: _select,
              itemBuilder: (context) {
                return schoolGalleryChoices.map((SchoolGalleryChoice choice) {
                  return PopupMenuItem<SchoolGalleryChoice>(
                    value: choice,
                    child: Text(choice.title),
                  );
                }).toList();
              },
            )
          ],
          title: Text(
            AppLocalizations.of(context)
                .translate(TEXT_SCHOOL_GALLERY_APP_BAR_TITLE),
          ),
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 1.0),
            child: BlocBuilder<SchoolGalleryBloc, SchoolGalleryState>(
              builder: (context, state) {
                _blocContext = context;
                if (state is SchoolGalleryLoading) {
                  return AppBarLoading();
                }
                return EmptyContainer();
              },
            ),
          ),
        ),
        body: BlocListener<SchoolGalleryBloc, SchoolGalleryState>(
          listener: (context, state) {
            _blocContext = context;
            if (state is SchoolGalleryLoaded) {
            } else if (state is Unauthorized) {
              Navigator.pushReplacementNamed(context, LoginPage.ID);
            }
          },
          child: BlocBuilder<SchoolGalleryBloc, SchoolGalleryState>(
            builder: (context, state) {
              if (state is SchoolGalleryLoaded) {
                artworks = state.artworks;
                return GalleryGrid(
                  showEmptyArtworks: true,
                  artworkList: artworks,
                  isStaggered: false,
                  onTap: (artwork, index) async {
                    final result = await Navigator.pushNamed(
                        context, ArtworkUploadPage.ID,
                        arguments: artwork);
                    if (result is ArtworkToReturn) {
                      showSnackBar(context, result.message);
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
              } else if (state is SchoolGalleryEmpty) {
                _dispatchGetSchoolArtEvent(context);
              }
              return EmptyContainer();
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
              showSnackBar(context, result.message);
              setState(() {
                artworks.add(result.artwork);
              });
            }
          },
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: TitledBottomNavigationBar(
            currentIndex: 2, // Use this to update the Bar giving a position
            onTap: (index) {
              print("Selected Index: $index");
            },
            items: [
              TitledNavigationBarItem(title: 'Home', icon: Icons.home),
              TitledNavigationBarItem(title: 'Search', icon: Icons.search),
            ],
            activeColor: accentColor,
          ),
          shape: CircularNotchedRectangle(),
          notchMargin: 4.0,
        ),
      ),
    );
  }

  void _dispatchGetSchoolArtEvent(BuildContext context) {
    BlocProvider.of<SchoolGalleryBloc>(context).add(
      GetAllSchoolArtworkEvent(),
    );
  }

  void _dispatchLogoutEvent() {
    BlocProvider.of<SchoolGalleryBloc>(_blocContext).add(
      LogoutEvent(),
    );
  }

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(displayLocalizedString(
          context,
          message,
        )));
    _scaffoldkey.currentState.showSnackBar(snackBar);
  }

  String displayLocalizedString(BuildContext context, String label) {
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
  const SchoolGalleryChoice(title: 'Logout', icon: Icons.local_gas_station),
];
