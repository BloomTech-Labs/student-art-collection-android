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
        caategory,
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
