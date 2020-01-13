import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
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

class SchoolGalleryPage extends StatelessWidget {
  static const String ID = "schoolgallery";
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SchoolGalleryBloc>(
      create: (context) => sl<SchoolGalleryBloc>(),
      child: Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)
                .translate(TEXT_SCHOOL_GALLERY_APP_BAR_TITLE),
          ),
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 1.0),
            child: BlocBuilder<SchoolGalleryBloc, SchoolGalleryState>(
              builder: (context, state) {
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
            if (state is SchoolGalleryLoaded) {}
          },
          child: ArtworkGallery(),
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

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
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

class ArtworkGallery extends StatefulWidget {
  @override
  _ArtworkGalleryState createState() => _ArtworkGalleryState();
}

class _ArtworkGalleryState extends State<ArtworkGallery> {
  @override
  void initState() {
    super.initState();
    _dispatchGetSchoolArtEvent();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SchoolGalleryBloc, SchoolGalleryState>(
      builder: (context, state) {
        if (state is SchoolGalleryLoaded) {
          return GalleryGrid(
            artworkList: state.artworks,
            isStaggered: false,
            onTap: (artwork, index) async {
              final result = await Navigator.pushNamed(
                  context, ArtworkUploadPage.ID,
                  arguments: artwork);
              if (result is ArtworkToReturn) {
                showSnackBar(context, result.message);
              }
            },
          );
        } else if (state is SchoolGalleryEmpty) {
          _dispatchGetSchoolArtEvent();
        }
        return EmptyContainer();
      },
    );
  }

  void _dispatchGetSchoolArtEvent() {
    BlocProvider.of<SchoolGalleryBloc>(context).add(
      GetAllSchoolArtworkEvent(),
    );
  }

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(displayLocalizedString(
          context,
          message,
        )));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  String displayLocalizedString(BuildContext context, String label) {
    return AppLocalizations.of(context).translate(label);
  }
}
