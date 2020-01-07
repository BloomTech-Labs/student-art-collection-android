
import 'package:flutter/material.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/presentation/page/starter_screen.dart';
import 'package:student_art_collection/features/buy_art/presentation/page/artwork_details_page.dart';
import 'package:student_art_collection/features/buy_art/presentation/page/gallery_page.dart';
import 'package:student_art_collection/features/list_art/presentation/page/login_page.dart';
import 'package:student_art_collection/features/list_art/presentation/page/registration_page.dart';
import 'package:student_art_collection/features/list_art/presentation/page/school_gallery_page.dart';

class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;

    switch(settings.name){
      case SchoolLoginPage.ID:
        return MaterialPageRoute(builder: (_) => SchoolLoginPage());
      case GalleryPage.ID:
        return MaterialPageRoute(builder: (_) => GalleryPage());
      case ArtworkDetailsPage.ID:{
        if(args is Artwork){
        return MaterialPageRoute(builder: (_) => ArtworkDetailsPage(artwork: args,));
        }
        return _errorRoute();}
      case SchoolRegistrationPage.ID:
        return MaterialPageRoute(builder: (_) => SchoolRegistrationPage());
      case StarterScreen.ID:
        return MaterialPageRoute(builder: (_) => StarterScreen());
      case SchoolGalleryPage.ID:
        return MaterialPageRoute(builder: (_) => SchoolGalleryPage());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute(){
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(child: Text('ERROR'),),
      );
    });
  }
}
