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
