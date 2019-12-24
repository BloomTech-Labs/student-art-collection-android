import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:student_art_collection/core/util/page_constants.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';
import 'package:student_art_collection/core/util/fuctions.dart';

List<NetworkImage> images = List();
List<int> imageHeights = List();

final HttpLink httpLink = HttpLink(
  uri: 'https://student-artco-staging.herokuapp.com/graphql',
);

ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: httpLink, cache: NormalizedInMemoryCache(dataIdFromObject: typenameDataIdFromObject),
    ));


/*const int numberOfImages = 20;

NetworkImage generateImage() {
  var image = NetworkImage("https://picsum.photos/"
      "${randomInRange(300, 700)}/"
      "${randomInRange(300, 700)}");

  if (image != null) {
    return image;
  } else
    return NetworkImage(
        'https://upload.wikimedia.org/wikipedia/commons/6/66/RiP2013_Paramore_Hayley_Williams_0003.jpg');
}

void populateImages() {
  for (int i = 0; i < numberOfImages; i++) {
    imageHeights.add(randomInRange(minImageHeight, maxImageHeight));
    images.add(generateImage());
  }
}
*/
class GalleryScreen extends StatefulWidget {
  static const ID = '/';

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  @override
  void initState() {

    // TODO: implement initState
    super.initState();
  }

  String readRepositories = """query getImages{
  allImages{
  image_url
}
}""";

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text('Student Art Collection'),
        ),
        body: Query(
          options: QueryOptions(
              document: readRepositories
            // this is the query string you just created
          ),
          // Just like in apollo refetch() could be used to manually trigger a refetch
          // while fetchMore() can be used for pagination purpose
          builder: (QueryResult result,
              {VoidCallback refetch, FetchMore fetchMore}) {

            if (result.loading) {
              return Text('Loading');
            }

            // it can be either Map or List
            List resultList = result.data['allImages'];


            return GalleryExtraction(
              images: resultList,
            );
          },
        ),
      ),
    );
  }
}

class GalleryExtraction extends StatelessWidget {

  final List images;

  const GalleryExtraction({
    Key key, this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        color: backgroundColor,
        child: StaggeredGridView.countBuilder(
          scrollDirection: Axis.vertical,
          crossAxisCount: staggerCount,
          itemCount: images.length,
          itemBuilder: (BuildContext context, int index) => Stack(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                    Navigator.pushNamed(context, '/details');
                },
                child: Container(
                  padding: EdgeInsets.all(2.0),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(cardCornerRadius),
                        image: DecorationImage(
                          image: NetworkImage(images[index]['image_url']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],),
          staggeredTileBuilder: (int index) {
            StaggeredTile staggeredTile = StaggeredTile.count(
                staggerCount ~/ numOfRows, 20);
            return staggeredTile;
          },
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
        ),
      ),
    );
  }
}
