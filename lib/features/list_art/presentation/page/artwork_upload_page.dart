import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/upload/artwork_upload_bloc.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/upload/artwork_upload_event.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/upload/artwork_upload_state.dart';

import '../../../../service_locator.dart';

class ArtworkUploadPage extends StatelessWidget {
  static const String ID = 'school_artwork_detail';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ArtworkUploadBloc>(
      create: (context) => sl<ArtworkUploadBloc>(),
      child: Scaffold(
        appBar: AppBar(),
        body: BlocListener<ArtworkUploadBloc, ArtworkUploadState>(
          listener: (context, state) {},
          child: UploadForm(),
        ),
      ),
    );
  }
}

class UploadForm extends StatefulWidget {
  @override
  _UploadFormState createState() => _UploadFormState();
}

class _UploadFormState extends State<UploadForm> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        onPressed: () {
          dispatchUpload();
        },
        child: Text(
          'Test',
        ),
      ),
    );
  }

  dispatchUpload() {
    BlocProvider.of<ArtworkUploadBloc>(context).add(UploadNewArtworkEvent(
        category: 1,
        price: 20,
        sold: false,
        title: 'Android Test Art',
        artistName: 'Test Student',
        description: 'Test description',
        imageUrls: [
          'https://images.pexels.com/photos/102127/pexels-photo-102127.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
          'https://images.pexels.com/photos/459225/pexels-photo-459225.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=940',
          'https://images.pexels.com/photos/2303796/pexels-photo-2303796.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
          'https://images.pexels.com/photos/459225/pexels-photo-459225.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
        ]));
  }
}
