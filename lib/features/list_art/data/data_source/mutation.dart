import 'package:dartz/dartz.dart';

const String ADD_SCHOOL_MUTATION = r'''
  mutation AddSchool(
    $school_id: ID!, 
    $school_name: String!,
    $email: String!,
    $address: String!,
    $city: String!,
    $zipcode: String!) {
      action: addSchool(
        school_id: $school_id,
        school_name: $school_name,
        email: $email,
        address: $address,
        city: $city,
        zipcode: $zipcode
       ) {
        id,
        school_id,
        school_name,
        email, 
        address,
        city,
        zipcode
      }
    }
''';

const String UPDATE_SCHOOL_MUTATION = r'''
  mutation UpdateSchool(
    $id: ID!, 
    $school_name: String!,
    $email: String!,
    $address: String!,
    $city: String!,
    $zipcode: String!) {
      action: updateSchool(
        id: $id,
        school_name: $school_name,
        email: $email,
        address: $address,
        city: $city,
        zipcode: $zipcode
       ) {
        id,
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
    $description: String
    $image_url: String!) {
      action: addArt(
        school_id: $school_id,
        category: $category,
        price: $price,
        sold: $sold,
        title: $title,
        artist_name: $artist_name,
        description: $description,
        image_url: $image_url
      ) {
        id,
        category {
          id,
          category
        },
        school{
          school_name,
          id,
          school_id,
          email
        }
        price,
        sold,
        title,
        artist_name,
        description,
        date_posted,
        images {
          id,
          art_id,
          image_url
        }
      }
    }
''';

const String UPDATE_ARTWORK_MUTATION = r'''
  mutation AddArtworkToSchool(
    $id: ID!,
    $price: Int,
    $sold: Boolean,
    $title: String,
    $artist_name: String,
    $description: String) {
      action: updateArt(
        id: $id,
        price: $price,
        sold: $sold,
        title: $title,
        artist_name: $artist_name,
        description: $description,
      ) {
        id,
        category {
          id,
          category
        },
        school{
          school_name,
          id,
          school_id,
          email
        }
        price,
        sold,
        title,
        artist_name,
        description,
        date_posted,
        images {
          id,
          art_id,
          image_url
        }
      }
    }
''';

const String ADD_IMAGE_TO_ARTWORK_MUTATION = r'''
  mutation AddImageToArtwork(
    $art_id: Int,
    $image_url: String) {
      action: addImage(
        art_id: $art_id, 
        image_url: $image_url
      ) {
        id,
        art_id,
        image_url
      }
    }
''';

const String DELETE_IMAGE_FROM_ARTWORK = r'''
  mutation DeleteImage(
    $id: ID!) {
      action: deleteImage(
        id: $id
      ) {
        id
      }
    }
''';

const String DELETE_ARTWORK = r'''
  mutation DeleteArtwork(
  $id: ID!) {
    action: deleteArt(
      id: $id             
    ) {
      id
    }
  }
''';
