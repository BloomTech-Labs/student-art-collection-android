import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart' as aw;
import 'package:student_art_collection/core/util/theme_constants.dart';
import 'package:student_art_collection/features/buy_art/presentation/bloc/artwork_details/artwork_details_bloc.dart';

import '../../../../service_locator.dart';

class ArtworkDetailsPage extends StatelessWidget {
  static const ID = "/artwork_details";

  final aw.Artwork artwork;

  const ArtworkDetailsPage({Key key, @required this.artwork}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ArtworkDetailsBloc>(
      create: (context) => sl<ArtworkDetailsBloc>(),
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text('Artwork Details'),
        ),
        body: BlocListener<ArtworkDetailsBloc, ArtworkDetailsState>(
          listener: (context, state){
          },
          child: BlocBuilder<ArtworkDetailsBloc, ArtworkDetailsState>(
            builder: (context, state){
              return buildLoaded();
            },
          ),
        ),
      )
    );
  }

  Widget buildError(){return Container(child: Text('Error'));}

  Widget buildLoaded(){return Container(child: Text('Loaded'));}
}
