const String GET_SCHOOL_QUERY = r'''
  query GetSchool(
    $id: ID!
    ) {
      school(id: $id) {
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
      category,
      school_id,
      price,
      sold,
      title,
      artist_name,
      description,
      date_posted
     }
  }
''';
