import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:graphql/client.dart';
import 'package:student_art_collection/core/data/data_source/base_remote_data_source.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/error/exception.dart';
import 'package:student_art_collection/core/util/api_constants.dart';
import 'package:student_art_collection/core/util/functions.dart';
import 'package:student_art_collection/features/buy_art/data/data_source/mutation.dart';
import 'package:student_art_collection/features/buy_art/data/data_source/query.dart';
import 'package:student_art_collection/features/buy_art/data/model/contact_form_model.dart';
import 'package:student_art_collection/features/buy_art/domain/entity/contact_form.dart';
import 'package:student_art_collection/features/buy_art/domain/usecase/get_all_artwork.dart';

abstract class BuyerRemoteDataSource {
  /// Throws a [ServerException] for all error codes
  Future<List<Artwork>> getAllArtwork({SearchFilters searchFilters});

  Future<ContactForm> contactFormConfirmation(
      {@required ContactForm contactForm});

  Future<String> getCurrentZipcode();
}

class GraphQLBuyerRemoteDataSource extends BaseRemoteDataSource
    implements BuyerRemoteDataSource {
  final Geolocator geolocator;

  GraphQLBuyerRemoteDataSource({
    client: GraphQLClient,
    @required this.geolocator,
  }) : super(graphQLClient: client);

  @override
  Future<List<Artwork>> getAllArtwork({SearchFilters searchFilters}) async {
    if (searchFilters.zipcode != null &&
        searchFilters.category != null &&
        searchFilters.category > 0 &&
        searchFilters.category < 6) {
      final QueryResult result = await performQuery(
          GET_ARTWORKS_BY_FILTER,
          {
            'zipcode':
                searchFilters.zipcode == true ? await getCurrentZipcode() : '',
            'category': searchFilters.category > 0 && searchFilters.category < 6
                ? searchFilters.category.toString()
                : '',
          },
          false);
      if (result.hasException) {
        throw ServerException();
      }
      return convertResultToArtworkList(result, "filter");
    } else {
      final QueryResult result =
          await performQuery(GET_ALL_ARTWORK_FOR_BUYER, null, true);
      if (result.hasException) {
        throw ServerException();
      }
      return convertResultToArtworkList(result, "allArts");
    }
  }

  @override
  Future<ContactForm> contactFormConfirmation(
      {@required ContactForm contactForm}) async {
    final QueryResult result = await performMutation(
      SUBMIT_CONTACT_FORM_MUTATION,
      {
        CONTACT_FORM_SEND_TO: contactForm.sendTo,
        CONTACT_FORM_FROM: contactForm.from,
        CONTACT_FORM_SUBJECT: contactForm.subject,
        CONTACT_FORM_MESSAGE: contactForm.message,
        CONTACT_FORM_NAME: contactForm.name
      },
    );

    if (result.hasException) {
      throw ServerException();
    }

    return ContactFormModel.fromJson(result.data['action']);
  }

  @override
  Future<String> getCurrentZipcode() async {
    Position position = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(
      Coordinates(
        position.latitude,
        position.longitude,
      ),
    );
    return addresses.first.postalCode;
  }
}
