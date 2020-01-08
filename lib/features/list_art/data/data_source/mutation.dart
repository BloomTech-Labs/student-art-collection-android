import 'package:dartz/dartz.dart';

const String ADD_SCHOOL_MUTATION = r'''
  mutation AddSchool(
    $schoolId: ID!, 
    $schoolName: String!,
    $email: String!,
    $address: String!,
    $city: String!,
    $zipcode: String!) {
      action: addSchool(
        school_id: $schoolId,
        school_name: $schoolName,
        email: $email,
        address: $address,
        city: $city,
        zipcode: $zipcode
       ) {
        school_id,
        school_name,
        email, 
        address,
        city,
        zipcode
      }
    }
''';

const String ADD_ARTWORK_MUTATION = r'''
  mutation AddArtworkToSchool(
    $school_id: ID!,
    $category: ID!,
    $price: Int,
    $sold: Boolean,
    $title: String,
    $artist_name: String,
    $description: String) {
      action: addArt(
        school_id: $school_id,
        category: $category,
        price: $price,
        sold: $sold,
        title: $title,
        artist_name: $artist_name,
        description: $description,
      ) {
        id,
        category,
        school_id,
        price,
        sold,
        title,
        artist_name,
        description,
        date_posted,
        images
      }
    }
''';

const String ADD_IMAGE_TO_ARTWORK_MUTATION = r'''
  mutation AddImageToArtwork(
    $art_id: ID!,
    $image_url: String) {
      action addImage(
        art_id: $art:id, 
        image_url: $image_url
      ) {
        id,
        art_id,
        image_url
      }
    }
''';
