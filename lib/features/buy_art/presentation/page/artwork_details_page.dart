import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart' as aw;
import 'package:student_art_collection/core/presentation/widget/build_loading.dart';
import 'package:student_art_collection/core/presentation/widget/gallery_grid.dart';
import 'package:student_art_collection/core/util/functions.dart';
import 'package:student_art_collection/features/buy_art/domain/entity/contact_form.dart';
import 'package:student_art_collection/features/buy_art/presentation/bloc/artwork_details/artwork_details_bloc.dart';
import 'package:student_art_collection/core/presentation/widget/carousel_image_viewer.dart';

import '../../../../service_locator.dart';

//for initial commit

class ArtworkDetailsPage extends StatefulWidget {
  static const ID = "/artwork_details";
  final aw.Artwork artwork;

  const ArtworkDetailsPage({Key key, @required this.artwork}) : super(key: key);

  @override
  _ArtworkDetailsPageState createState() =>
      _ArtworkDetailsPageState(artwork: artwork);
}

class _ArtworkDetailsPageState extends State<ArtworkDetailsPage> {
  final aw.Artwork artwork;

  _ArtworkDetailsPageState({@required this.artwork});

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  @override
  void dispose(){
    messageController.dispose();
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    String title = artwork.title != '' ? artwork.title : 'Untitled';

    return BlocProvider<ArtworkDetailsBloc>(
      create: (context) => sl<ArtworkDetailsBloc>(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(title),
        ),
        body: BlocListener<ArtworkDetailsBloc, ArtworkDetailsState>(
          listener: (context, state) {
            //listener logic
          },
          child: BlocBuilder<ArtworkDetailsBloc, ArtworkDetailsState>(
            builder: (context, state) {
              if (state is ArtworkDetailsLoadingState) {
                return BuildLoading();
              } else if (state is ArtworkDetailsFormSubmittedState) {
                return buildFormConfirmation(screenHeight: screenHeight);
              } else if (state is ArtworkDetailsErrorState) {
                return buildError();
              } else
                return SafeArea(
                  child: SingleChildScrollView(
                    child: buildLoaded(
                        screenHeight: screenHeight, context: context),
                  ),
                );
            },
          ),
        ),
      ),
    );
  }

  Widget buildError() {
    return Container(
      child: Center(child: Text('Error')),
    );
  }

  Widget buildFormLoading({@required double screenHeight}) {
    return Column(
      children: <Widget>[
        topBannerWidget(screenHeight: screenHeight),
        carouselWidget(screenHeight: screenHeight),
        BuildLoading(),
      ],
    );
  }

  Widget buildFormConfirmation({@required double screenHeight}) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: screenHeight * .06,
        ),
        carouselWidget(screenHeight: screenHeight),
        contactFormConfirmationWidget(screenHeight: screenHeight),
      ],
    );
  }

  Widget buildLoaded(
      {@required double screenHeight, @required BuildContext context}) {
    return Column(
      children: <Widget>[
        topBannerWidget(screenHeight: screenHeight),
        carouselWidget(screenHeight: screenHeight),
        contactFormWidget(screenHeight: screenHeight, context: context)
      ],
    );
  }

  Widget topBannerWidget({@required double screenHeight}) {
    double topBannerHeight = screenHeight * .04;
    return Container(
      height: topBannerHeight,
      alignment: Alignment.center,
      padding: EdgeInsets.all(8),
      child: Text('Want to purchase this piece? Fill out the form below'),
    );
  }

  Widget carouselWidget({@required double screenHeight}) {
    double carouselHeight = screenHeight * .3;

    //Todo: replace hard coded values with real default price when backend is updated
    String price = artwork.price == 0 ? '20' : artwork.price.toString();
    String artworkTitle = artwork.title == "" ? 'Untitled' : artwork.title;
    String artworkDate = artwork.datePosted == null
        ? DateTime.now().year.toString()
        : artwork.datePosted.year.toString();

    return Container(
      child: Stack(children: <Widget>[
        CarouselImageViewer(
          artwork: artwork,
          height: carouselHeight,
          isEditable: false,
        ),
        Positioned(
          bottom: 5,
          left: 24,
          child: Container(
              child: Text(
            artworkTitle + '\n ' + artworkDate,
            textAlign: TextAlign.left,
          )),
        ),
        Positioned(
          bottom: 5,
          right: 16,
          child: Container(
            child: Text(
              'Suggested Donation: \n \$' + price,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ]),
    );
  }

  Widget contactFormWidget(
      {@required double screenHeight, @required BuildContext context}) {
    // ignore: close_sinks
    final artworkDetailsBloc = BlocProvider.of<ArtworkDetailsBloc>(context);
    double smallBoxHeight = screenHeight * .07;
    double mediumBoxHeight = screenHeight * .2;

    return Column(
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              Container(
                height: smallBoxHeight/2,
                child: Center(
                    child: Divider(
                  thickness: 1.5,
                )),
              ),
              Container(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                height: smallBoxHeight,
                child: TextField(
                  controller: nameController,
                  maxLength: 40,
                  maxLengthEnforced: true,
                  decoration: InputDecoration(
                      labelText: 'Name',
                      counterText: "",
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(cardCornerRadius))),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                height: smallBoxHeight,
                child: TextField(
                  controller: emailController,
                  maxLength: 40,
                  maxLengthEnforced: true,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      counterText: "",
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(cardCornerRadius))),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                height: mediumBoxHeight,
                child: TextField(
                  controller: messageController,
                  keyboardType: TextInputType.multiline,
                  minLines: 9,
                  maxLines: null,
                  maxLength: 400,
                  maxLengthEnforced: true,
                  decoration: InputDecoration(
                      alignLabelWithHint: true,
                      labelText: 'Message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(cardCornerRadius),
                      )),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(right: 16),
          alignment: Alignment.bottomRight,
          child: Container(
            width: 90,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(cardCornerRadius)),
            child: FlatButton(
              onPressed: () {
                artworkDetailsBloc.add(SubmitContactForm(ContactForm(
                    sendTo: emailController.text,
                    from: "",
                    message: messageController.text,
                    subject: artwork.title,
                    name: nameController.text)));
              },
              child: Text('Submit'),
            ),
          ),
        )
      ],
    );
  }

  Widget contactFormConfirmationWidget({@required double screenHeight}) {
    return Center(
      child: Container(
        child: Center(
          child: Text('Form Submitted'),
        ),
      ),
    );
  }
}
