const String GET_ALL_ARTWORK_FOR_BUYER = r'''
query getAllArtwork{
  allArts{
    id
    school{
    email
    id
    school_id
    school_name
    }
    price
    sold
    title
    artist_name
    description
    date_posted
  images{
    id
    art_id
    image_url
  }
    category{
  id
  category
  }
}
}
    ''';

const String GET_ARTWORKS_BY_FILTER = r'''
query GetArtworksByZip(
  $zipcode: String,
  $category: String
) {
  filter(
    filter: {
      zipcode: {
        eq: $zipcode
      },
      category: {
        eq: $category
      }
    }
  ) {
      id
      school {
        email
        id
        school_id
        school_name
    }
      price
      sold
      title
      artist_name
      description
      date_posted
      images{
        id
        art_id
        image_url
    }
      category {
        id
        category
    }
  }
} 
''';
