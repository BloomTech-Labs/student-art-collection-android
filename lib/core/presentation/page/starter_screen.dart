
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class StarterScreen extends StatefulWidget {
  static const ID = "/";

  @override
  _StarterScreenState createState() => _StarterScreenState();
}

class _StarterScreenState extends State<StarterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ExtendedImage.network(
                "https://picsum.photos/200/300",
                width: 200,
                height: 300,
                fit: BoxFit.fill,
                cache: true,
                border: Border.all(color: Colors.red, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                //cancelToken: cancellationToken,
              ).image
            )
          ),
        ),
        //cancelToken: cancellationToken,
      ),
    );
  }
}
