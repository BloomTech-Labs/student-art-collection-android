import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/presentation/widget/build_loading.dart';
import 'package:student_art_collection/core/presentation/widget/gallery_grid.dart';
import 'package:student_art_collection/core/util/text_constants.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';
import 'package:student_art_collection/features/buy_art/domain/entity/contact_form.dart';
import 'package:student_art_collection/features/buy_art/presentation/bloc/artwork_details/artwork_details_bloc.dart';
import 'package:student_art_collection/core/presentation/widget/carousel_image_viewer.dart';

import '../../../../app_localization.dart';
import '../../../../service_locator.dart';

class ArtworkDetailsPage extends StatefulWidget {
  static const ID = "/artwork_details";
  final Artwork artwork;

  const ArtworkDetailsPage({Key key, @required this.artwork}) : super(key: key);

  @override
  _ArtworkDetailsPageState createState() =>
      _ArtworkDetailsPageState(artwork: artwork);
}

class _ArtworkDetailsPageState extends State<ArtworkDetailsPage> {
  final Artwork artwork;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _ArtworkDetailsPageState({@required this.artwork});

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    String title = artwork.title != ''
        ? artwork.title
        : displayLocalizedString(context, TEXT_ARTWORK_DETAILS_UNTITLED_LABEL);

    return BlocProvider<ArtworkDetailsBloc>(
      create: (context) => sl<ArtworkDetailsBloc>(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text(title),
        ),
        body: BlocListener<ArtworkDetailsBloc, ArtworkDetailsState>(
          listener: (context, state) {
            if (state is ArtworkDetailsFormSubmittedState) {
              Navigator.pop(
                  context, TEXT_ARTWORK_DETAILS_FORM_SUBMITTED_MESSAGE);
            } else if (state is ArtworkDetailsErrorState) {
              showSnackBar(context, state.message);
            }
          },
          child: BlocBuilder<ArtworkDetailsBloc, ArtworkDetailsState>(
            builder: (context, state) {
              if (state is ArtworkDetailsLoadingState ||
                  state is ArtworkDetailsFormSubmittedState) {
                return BuildLoading();
              } else if (state is ArtworkDetailsErrorState) {
                return buildLoaded(
                    screenHeight: screenHeight, context: context);
              } else
                return buildLoaded(
                    screenHeight: screenHeight, context: context);
            },
          ),
        ),
      ),
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

  Widget buildLoaded(
      {@required double screenHeight, @required BuildContext context}) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            topBannerWidget(screenHeight: screenHeight),
            carouselWidget(screenHeight: screenHeight),
            contactFormWidget(screenHeight: screenHeight, context: context)
          ],
        ),
      ),
    );
  }

  Widget topBannerWidget({@required double screenHeight}) {
    double topBannerHeight = screenHeight * .04;
    return Container(
      height: topBannerHeight,
      alignment: Alignment.center,
      padding: EdgeInsets.all(8),
      child: Text(
        displayLocalizedString(
            context, TEXT_ARTWORK_DETAILS_TOP_BANNER_MESSAGE),
      ),
    );
  }

  Widget carouselWidget({@required double screenHeight}) {
    double carouselHeight = screenHeight * .3;

    //Todo: replace hard coded values with real default price when backend is updated
    String price = artwork.price == 0 ? '20' : artwork.price.toString();
    String artworkTitle = artwork.title == ""
        ? displayLocalizedString(context, TEXT_ARTWORK_DETAILS_UNTITLED_LABEL)
        : artwork.title;
    String artworkDate = artwork.datePosted == null
        ? DateTime.now().year.toString()
        : artwork.datePosted.year.toString();

    return Container(
      child: Stack(
        children: <Widget>[
          CarouselImageViewer(
            artwork: artwork,
            height: carouselHeight,
            isEditable: false,
          ),
          Positioned(
            bottom: 5,
            left: 24,
            child: Container(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: artworkTitle + '\n',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: artworkDate),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            right: 16,
            child: Container(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text: displayLocalizedString(
                            context, TEXT_ARTWORK_DETAILS_SUGGESTED_DONATION),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                    TextSpan(text: "\$" + price),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
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
                height: smallBoxHeight / 2,
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
                      labelText: displayLocalizedString(
                          context, TEXT_ARTWORK_DETAILS_NAME_LABEL),
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(cardCornerRadius),
                      )),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                height: smallBoxHeight,
                child: TextField(
                  controller: emailController,
                  maxLength: 40,
                  maxLengthEnforced: true,
                  decoration: InputDecoration(
                      labelText: displayLocalizedString(
                          context, TEXT_ARTWORK_DETAILS_EMAIL_LABEL),
                      counterText: "",
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(cardCornerRadius))),
                ),
              ),
              SizedBox(
                height: 10,
              ),
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
                      labelText: displayLocalizedString(
                          context, TEXT_ARTWORK_DETAILS_MESSAGE_LABEL),
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
            child: MaterialButton(
              elevation: 5,
              color: Colors.black,
              onPressed: () {
                artworkDetailsBloc.add(SubmitContactForm(ContactForm(
                    sendTo: artwork.schoolInfo.email,
                    from: emailController.text,
                    message: displayLocalizedString(
                            context, TEXT_ARTWORK_DETAILS_REPLY_TO) +
                        emailController.text +
                        "\n\n" +
                        messageController.text,
                    subject: nameController.text +
                        displayLocalizedString(
                            context, TEXT_ARTWORK_DETAILS_INQUIRES_ABOUT) +
                        artwork.title +
                        " #: " +
                        artwork.artId.toString(),
                    name: nameController.text)));
              },
              child: Text(
                displayLocalizedString(
                    context, TEXT_ARTWORK_DETAILS_SUBMIT_BUTTON_LABEL),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        )
      ],
    );
  }

  String displayLocalizedString(BuildContext context, String label) {
    return AppLocalizations.of(context).translate(label);
  }

  void popAndReturn(
    BuildContext context,
    String message,
  ) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context, message);
    } else {
      SystemNavigator.pop();
    }
  }

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        displayLocalizedString(
          context,
          message,
        ),
        textAlign: TextAlign.center,
      ),
    );
    _scaffoldKey.currentState.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
