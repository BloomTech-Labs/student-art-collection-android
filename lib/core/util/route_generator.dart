import 'package:flutter/material.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/features/buy_art/presentation/page/artwork_details_page.dart';
import 'package:student_art_collection/features/buy_art/presentation/page/gallery_page.dart';
import 'package:student_art_collection/features/list_art/presentation/page/artwork_upload_page.dart';
import 'package:student_art_collection/core/presentation/page/login_page.dart';
import 'package:student_art_collection/features/list_art/presentation/page/registration_page.dart';
import 'package:student_art_collection/features/list_art/presentation/page/school_gallery_page.dart';
import 'package:student_art_collection/features/list_art/presentation/page/school_home_page.dart';
import 'package:student_art_collection/features/list_art/presentation/page/school_profile_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case LoginPage.ID:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case GalleryPage.ID:
        return MaterialPageRoute(builder: (_) => GalleryPage());
      case ArtworkDetailsPage.ID:
        {
          if (args is Artwork) {
            return MaterialPageRoute(
                builder: (_) => ArtworkDetailsPage(
                      artwork: args,
                    ));
          }
          return _errorRoute();
        }
      case SchoolRegistrationPage.ID:
        return MaterialPageRoute(builder: (_) => SchoolRegistrationPage());
      case SchoolHomePage.ID:
        return MaterialPageRoute(builder: (_) => SchoolHomePage());
      case SchoolGalleryPage.ID:
        return MaterialPageRoute(builder: (_) => SchoolGalleryPage());
      case SchoolProfilePage.ID:
        return MaterialPageRoute(builder: (_) => SchoolProfilePage());
      case ArtworkUploadPage.ID:
        {
          if (args is Artwork) {
            return MaterialPageRoute(
                builder: (_) => ArtworkUploadPage(
                      artwork: args,
                    ));
          }
          return MaterialPageRoute(
              builder: (_) => ArtworkUploadPage(
                    artwork: args,
                  ));
        }
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
