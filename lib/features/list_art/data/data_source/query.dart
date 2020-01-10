const String GET_SCHOOL_QUERY = r'''
  query GetSchool(
    $school_id: ID!
    ) {
      schoolBySchoolId(school_id: $school_id) {
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

const String GET_ARTWORK_FOR_SCHOOL = r'''
  query GetArtworkForSchool(
    $school_id: ID!
  ) {
     artBySchool(school_id: $school_id) {
      id,
      category{
      category
      id
      },
      school{
      school_name,
      id,
      school_id,
      email
      },
      price,
      sold,
      title,
      artist_name,
      description,
      date_posted
      images {
        id,
        art_id,
        image_url
      }
     }
  }
''';
