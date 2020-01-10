import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_art_collection/core/presentation/widget/empty_container.dart';
import 'package:student_art_collection/core/presentation/widget/gallery_grid.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';
import 'package:student_art_collection/features/buy_art/presentation/page/artwork_details_page.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/auth/school_auth_bloc.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/gallery/school_gallery_bloc.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/gallery/school_gallery_event.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/gallery/school_gallery_state.dart';
import 'package:student_art_collection/features/list_art/presentation/page/artwork_upload_page.dart';
import 'package:student_art_collection/features/list_art/presentation/widget/horizontal_progress_bar.dart';

import '../../../../service_locator.dart';

class SchoolGalleryPage extends StatelessWidget {
  static const String ID = "schoolgallery";

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SchoolGalleryBloc>(
      create: (context) => sl<SchoolGalleryBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'School Art Gallery',
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
          onPressed: () {
            Navigator.pushNamed(context, ArtworkUploadPage.ID);
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
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text('Search'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              title: Text('Messages'),
            ),
          ],
        ),
      ),
    );
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
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SchoolGalleryBloc, SchoolGalleryState>(
      builder: (context, state) {
        if (state is SchoolGalleryLoaded) {
          return GalleryGrid(
            artworkList: state.artworks,
            isStaggered: false,
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
}
