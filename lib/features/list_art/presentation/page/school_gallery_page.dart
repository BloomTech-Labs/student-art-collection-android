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
        floatingActionButton: FloatingActionButton(
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
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: primaryColor,
          selectedFontSize: 14,
          unselectedFontSize: 14,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text(AppLocalizations.of(context)
                  .translate(TEXT_SCHOOL_GALLERY_HOME_TAG)),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text(AppLocalizations.of(context)
                  .translate(TEXT_SCHOOL_GALLERY_SEARCH_TAG)),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              title: Text(AppLocalizations.of(context)
                  .translate(TEXT_SCHOOL_GALLERY_MESSAGES_TAG)),
            ),
          ],
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
