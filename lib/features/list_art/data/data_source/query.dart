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
