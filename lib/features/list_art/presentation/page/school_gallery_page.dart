import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/auth/school_auth_bloc.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/gallery/school_gallery_bloc.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/gallery/school_gallery_event.dart';

import '../../../../service_locator.dart';

class SchoolGalleryPage extends StatefulWidget {
  static const String ID = "schoolgallery";

  @override
  _SchoolGalleryPageState createState() => _SchoolGalleryPageState();
}

class _SchoolGalleryPageState extends State<SchoolGalleryPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SchoolGalleryBloc>(
      create: (context) => sl<SchoolGalleryBloc>(),
      child: Scaffold(
        appBar: AppBar(),
        body: ArtworkGallery(),
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
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        onPressed: () {
          BlocProvider.of<SchoolGalleryBloc>(context)
              .add(GetAllSchoolArtworkEvent());
        },
        child: Text('Get Artwork'),
      ),
    );
  }
}
