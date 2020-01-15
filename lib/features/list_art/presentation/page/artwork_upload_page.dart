import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/presentation/widget/carousel_image_viewer.dart';
import 'package:student_art_collection/core/presentation/widget/dialog_button.dart';
import 'package:student_art_collection/core/presentation/widget/empty_container.dart';
import 'package:student_art_collection/core/util/functions.dart';
import 'package:student_art_collection/core/util/text_constants.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';
import 'package:student_art_collection/features/list_art/presentation/artwork_to_return.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/upload/artwork_upload_bloc.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/upload/artwork_upload_event.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/upload/artwork_upload_state.dart';
import 'package:student_art_collection/features/list_art/presentation/list_art_text_constants.dart';
import 'package:student_art_collection/features/list_art/presentation/widget/auth_input_decoration.dart';
import 'package:student_art_collection/features/list_art/presentation/widget/horizontal_progress_bar.dart';

import '../../../../app_localization.dart';
import '../../../../service_locator.dart';

class ArtworkUploadPage extends StatefulWidget {
  static const String ID = 'school_artwork_detail';
  final Artwork artwork;

  ArtworkUploadPage({this.artwork});

  @override
  _ArtworkUploadPageState createState() =>
      _ArtworkUploadPageState(artwork: artwork);
}

class _ArtworkUploadPageState extends State<ArtworkUploadPage> {
  Artwork artwork;
  String title, artistName, description;
  bool sold;
  int category, price;
  List<String> imageUrls;
  ArtworkUploadBloc _artworkUploadBloc;

  DateTime selectedDate = DateTime.now();

  final titleTextController = TextEditingController();
  final studentTextController = TextEditingController();
  final descriptionTextController = TextEditingController();
  final dateTextController = TextEditingController();
  final priceTextController = TextEditingController();
  final categoryTextController = TextEditingController();

  _ArtworkUploadPageState({
    this.artwork,
  });

  List<String> _getPrices() {
    return [
      displayLocalizedString(TEXT_ARTWORK_UPLOAD_PRICE_1),
      displayLocalizedString(TEXT_ARTWORK_UPLOAD_PRICE_2),
      displayLocalizedString(TEXT_ARTWORK_UPLOAD_PRICE_3),
      displayLocalizedString(TEXT_ARTWORK_UPLOAD_PRICE_4),
      displayLocalizedString(TEXT_ARTWORK_UPLOAD_PRICE_5),
      displayLocalizedString(TEXT_ARTWORK_UPLOAD_PRICE_6),
      displayLocalizedString(TEXT_ARTWORK_UPLOAD_PRICE_7),
      displayLocalizedString(TEXT_ARTWORK_UPLOAD_PRICE_8),
      displayLocalizedString(TEXT_ARTWORK_UPLOAD_PRICE_9),
      displayLocalizedString(TEXT_ARTWORK_UPLOAD_PRICE_10),
    ];
  }

  List<String> _getCategories() {
    return [
      displayLocalizedString(TEXT_ARTWORK_UPLOAD_CATEGORY_1),
      displayLocalizedString(TEXT_ARTWORK_UPLOAD_CATEGORY_2),
      displayLocalizedString(TEXT_ARTWORK_UPLOAD_CATEGORY_3),
      displayLocalizedString(TEXT_ARTWORK_UPLOAD_CATEGORY_4),
      displayLocalizedString(TEXT_ARTWORK_UPLOAD_CATEGORY_5),
    ];
  }

  Future _getImage() async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.BOTTOMSLIDE,
      tittle: displayLocalizedString(TEXT_ARTWORK_IMAGE_DIALOG_TITLE_LABEL),
      desc: displayLocalizedString(TEXT_ARTWORK_IMAGE_DIALOG_DESCRIPTION_LABEL),
      btnOkOnPress: () async {
        var image = await ImagePicker.pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
          maxHeight: 768,
          maxWidth: 1024,
        );
        if (image != null) {
          dispatchImageHost(image);
        }
      },
      btnOkColor: accentColor,
      btnOkText:
          displayLocalizedString(TEXT_ARTWORK_IMAGE_DIALOG_CAMERA_TEXT_LABEL),
      btnCancelText:
          displayLocalizedString(TEXT_ARTWORK_IMAGE_DIALOG_GALLERY_TEXT_LABEL),
      btnCancelColor: accentColor,
      btnOkIcon: Icons.camera,
      btnCancelIcon: Icons.image,
      btnCancelOnPress: () async {
        var image = await ImagePicker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 85,
          maxHeight: 768,
          maxWidth: 1024,
        );
        if (image != null) {
          dispatchImageHost(image);
        }
      },
    ).show();
  }

  @override
  void initState() {
    super.initState();
    _artworkUploadBloc = sl<ArtworkUploadBloc>();
    imageUrls = List();
    if (artwork != null) {
      artwork.images.forEach((image) {
        imageUrls.add(image.imageUrl);
      });
      _artworkUploadBloc.add(InitializeEditArtworkPageEvent(artwork: artwork));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ArtworkUploadBloc>(
      create: (context) => _artworkUploadBloc,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {},
            )
          ],
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 1.0),
            child: BlocBuilder<ArtworkUploadBloc, ArtworkUploadState>(
              builder: (context, state) {
                if (state is ArtworkUploadLoading) {
                  return AppBarLoading();
                }
                return EmptyContainer();
              },
            ),
          ),
        ),
        body: BlocListener<ArtworkUploadBloc, ArtworkUploadState>(
          listener: (context, state) {
            if (state is ArtworkUploadSuccess) {
              popAndReturn(
                context,
                'upload',
                state.artwork,
                state.message,
              );
            } else if (state is ArtworkUpdateSuccess) {
              popAndReturn(
                context,
                'update',
                state.artwork,
                state.message,
              );
            } else if (state is EditArtworkInitialState) {
              setState(() {
                populateData(state.artwork);
              });
            } else if (state is ImageHostSuccess) {
              setState(() {
                imageUrls.add(state.imageUrl);
              });
            } else if (state is ArtworkUploadLoading) {
            } else if (state is ArtworkUploadError) {
              showSnackBar(context, state.message);
            } else if (state is ArtworkDeleteSuccess) {
              popAndReturn(
                context,
                'delete',
                null,
                TEXT_ARTWORK_DELETE_SUCCESS_MESSAGE_LABEL,
              );
            }
          },
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: double.infinity,
                      child: Stack(
                        children: <Widget>[
                          Material(
                            elevation: 2,
                            child: OutlineButton(
                              child: CarouselImageViewer(
                                isEditable: true,
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                imageList: imageUrls,
                                artwork: null,
                              ),
                              onPressed: () {},
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                          Positioned(
                            child: IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                color: accentColor,
                              ),
                              iconSize: 40,
                              onPressed: () {
                                _getImage();
                              },
                            ),
                            bottom: 0,
                            left: 0,
                          )
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 6,
                      fit: FlexFit.loose,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 10),
                          Material(
                            child: TextField(
                              controller: titleTextController,
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                title = value;
                              },
                              decoration: getAuthInputDecoration(
                                  displayLocalizedString(
                                      TEXT_ARTWORK_UPLOAD_ARTWORK_TITLE_LABEL)),
                            ),
                          ),
                          SizedBox(height: 10),
                          Material(
                            child: TextField(
                              controller: studentTextController,
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                artistName = value;
                              },
                              decoration: getAuthInputDecoration(
                                  displayLocalizedString(
                                      TEXT_ARTWORK_UPLOAD_STUDENT_NAME_LABEL)),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Flexible(
                                flex: 1,
                                child: Stack(
                                  overflow: Overflow.visible,
                                  children: <Widget>[
                                    Material(
                                      child: TextField(
                                        enabled: false,
                                        decoration: getAuthInputDecoration(
                                            displayLocalizedString(
                                                TEXT_ARTWORK_UPLOAD_DATE_SELECTION_LABEL)),
                                        controller: dateTextController,
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.date_range,
                                            color: accentColor,
                                          ),
                                          onPressed: () {
                                            _selectDate(context);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Flexible(
                                flex: 1,
                                child: Stack(
                                  overflow: Overflow.visible,
                                  children: <Widget>[
                                    Material(
                                      child: TextField(
                                        enabled: false,
                                        decoration: getAuthInputDecoration(
                                            displayLocalizedString(
                                                TEXT_ARTWORK_UPLOAD_PRICE_SELECTION_LABEL)),
                                        controller: priceTextController,
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.attach_money,
                                            color: accentColor,
                                          ),
                                          onPressed: () {
                                            _showPricePicker(context);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Stack(
                            overflow: Overflow.visible,
                            children: <Widget>[
                              Material(
                                child: TextField(
                                  enabled: false,
                                  decoration: getAuthInputDecoration(
                                      displayLocalizedString(
                                          TEXT_ARTWORK_UPLOAD_CATEGORY_SELECTION_LABEL)),
                                  controller: categoryTextController,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.category,
                                      color: accentColor,
                                    ),
                                    onPressed: () {
                                      _showCategoryPicker(context);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Material(
                            child: TextField(
                              controller: descriptionTextController,
                              maxLines: null,
                              maxLength: 200,
                              decoration: getAuthInputDecoration(
                                  displayLocalizedString(
                                      TEXT_ARTWORK_DESCRIPTION_FORM_HINT_LABEL)),
                              onChanged: (value) {
                                description = value;
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: FloatingActionButton(
                                    elevation: 4,
                                    heroTag: 'delete_button',
                                    onPressed: () {
                                      AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.WARNING,
                                          animType: AnimType.BOTTOMSLIDE,
                                          tittle: displayLocalizedString(
                                              TEXT_ARTWORK_DELETE_DIALOG_TITLE_LABEL),
                                          desc: displayLocalizedString(
                                              TEXT_ARTWORK_DELETE_DIALOG_DESCRIPTION_LABEL),
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () {
                                            dispatchDelete();
                                          }).show();
                                    },
                                    backgroundColor: accentColor,
                                    child: Icon(Icons.delete)),
                              ),
                              BlocBuilder<ArtworkUploadBloc,
                                  ArtworkUploadState>(
                                builder: (context, state) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: FloatingActionButton(
                                        elevation: 4,
                                        heroTag: 'save_button',
                                        onPressed: () {
                                          if (state is ArtworkUploadLoading) {
                                            showSnackBar(context,
                                                TEXT_ARTWORK_UPLOADING_WAIT_MESSAGE_LABEL);
                                          } else {
                                            dispatchUploadOrUpdate();
                                          }
                                        },
                                        backgroundColor: accentColor,
                                        child: Icon(Icons.check)),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dateTextController.text = formatDate(selectedDate);
      });
  }

  _showPricePicker(BuildContext context) {
    Picker picker = new Picker(
        adapter: PickerDataAdapter<String>(
          pickerdata: _getPrices(),
        ),
        changeToFirst: false,
        textAlign: TextAlign.left,
        columnPadding: const EdgeInsets.all(8.0),
        onConfirm: (Picker picker, List value) {
          setState(() {
            priceTextController.text =
                pickerValueToPureValue(picker.adapter.text);
            price = pricePickerValueToInt(
                pickerValueToPureValue(picker.adapter.text));
          });
        });
    picker.showModal(context);
  }

  _showCategoryPicker(BuildContext context) {
    Picker picker = new Picker(
        adapter: PickerDataAdapter<String>(
          pickerdata: _getCategories(),
        ),
        changeToFirst: false,
        textAlign: TextAlign.left,
        columnPadding: const EdgeInsets.all(8.0),
        onConfirm: (Picker picker, List value) {
          setState(() {
            final temp = _getCategories().indexOf(
                  pickerValueToPureValue(picker.adapter.text),
                ) +
                1;
            category = temp;
            categoryTextController.text = pickerValueToPureValue(
              picker.adapter.text,
            );
          });
        });
    picker.showModal(context);
  }

  void populateData(Artwork artwork) {
    this.artwork = artwork;
    title = artwork.title;
    titleTextController.text = artwork.title;
    description = artwork.description;
    descriptionTextController.text = artwork.description;
    artistName = artwork.artistName;
    studentTextController.text = artwork.artistName;
    dateTextController.text = formatDate(artwork.datePosted);
    sold = artwork.sold;
    category = artwork.category.categoryId;
    categoryTextController.text = artwork.category.categoryName;
    price = artwork.price.toInt();
    priceTextController.text = artwork.price.toInt().toString();
    imageUrls.clear();
    artwork.images.forEach((image) {
      imageUrls.add(image.imageUrl);
    });
  }

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(displayLocalizedString(message)));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void dispatchUploadOrUpdate() {
    if (artwork == null) {
      _artworkUploadBloc.add(UploadNewArtworkEvent(
          title: title,
          category: category,
          price: price,
          artistName: artistName,
          description: description,
          sold: sold,
          imageUrls: imageUrls));
    } else {
      _artworkUploadBloc.add(UpdateArtworkEvent(
          artwork: artwork,
          title: title,
          category: category,
          price: price,
          artistName: artistName,
          description: description,
          sold: sold,
          imageUrls: imageUrls));
    }
  }

  void dispatchImageHost(File file) {
    _artworkUploadBloc.add(HostImageEvent(imageFileToHost: file));
  }

  void dispatchDelete() {
    if (artwork != null) {
      _artworkUploadBloc.add(DeleteArtworkEvent(artId: artwork.artId));
    }
  }

  String displayLocalizedString(String label) {
    return AppLocalizations.of(context).translate(label);
  }

  void popAndReturn(
    BuildContext context,
    String tag,
    Artwork artwork,
    String message,
  ) {
    if (Navigator.canPop(context)) {
      Navigator.pop(
          context,
          ArtworkToReturn(
            artwork: artwork,
            message: message,
            tag: tag,
          ));
    } else {
      SystemNavigator.pop();
    }
  }
}
