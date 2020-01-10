import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:student_art_collection/core/util/functions.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/upload/artwork_upload_bloc.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/upload/artwork_upload_event.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/upload/artwork_upload_state.dart';
import 'package:student_art_collection/features/list_art/presentation/widget/auth_input_decoration.dart';

import '../../../../service_locator.dart';

class ArtworkUploadPage extends StatelessWidget {
  static const String ID = 'school_artwork_detail';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ArtworkUploadBloc>(
      create: (context) => sl<ArtworkUploadBloc>(),
      child: Scaffold(
        appBar: AppBar(),
        body: BlocListener<ArtworkUploadBloc, ArtworkUploadState>(
          listener: (context, state) {},
          child: UploadWidget(),
        ),
      ),
    );
  }
}

class UploadWidget extends StatefulWidget {
  @override
  _UploadWidgetState createState() => _UploadWidgetState();
}

class _UploadWidgetState extends State<UploadWidget> {
  String title, artistName, description;
  bool sold;
  int category, price;
  List<String> imageUrls;
  List<File> imageFiles;

  DateTime selectedDate = DateTime.now();

  final dateTextController = TextEditingController();
  final priceTextController = TextEditingController();
  final categoryTextController = TextEditingController();

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

  List<String> _getPrices() {
    return [
      '\$5',
      '\$10',
      '\$15',
      '\$20',
      '\$25',
      '\$30',
      '\$35',
      '\$40',
      '\$45',
      '\$50',
    ];
  }

  List<String> _getCategories() {
    return [
      'Photography',
      'Drawing',
      'Painting',
      'Sculpture',
      'Other',
    ];
  }

  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imageFiles.add(image);
    });
  }

  @override
  void initState() {
    super.initState();
    imageFiles = List();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
                child: OutlineButton(
                  child: Icon(
                    Icons.image,
                    color: accentColor,
                  ),
                  onPressed: () {
                    _getImage();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
              ),
              Flexible(
                flex: 6,
                fit: FlexFit.loose,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10),
                    TextField(
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        title = value;
                      },
                      decoration: getAuthInputDecoration('Enter Artwork Title'),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        artistName = value;
                      },
                      decoration: getAuthInputDecoration('Enter Student Name'),
                    ),
                    SizedBox(height: 10),
                    Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        TextField(
                          enabled: false,
                          decoration:
                              getAuthInputDecoration('Select Date Created'),
                          controller: dateTextController,
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
                    SizedBox(height: 10),
                    Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        TextField(
                          enabled: false,
                          decoration:
                              getAuthInputDecoration('Select Artwork Price'),
                          controller: priceTextController,
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
                    SizedBox(height: 10),
                    Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        TextField(
                          enabled: false,
                          decoration:
                              getAuthInputDecoration('Select Artwork Category'),
                          controller: categoryTextController,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            dispatchUpload();
                          },
                          color: accentColor,
                          textColor: Colors.white,
                          child: Text(
                            'Submit',
                          ),
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
    );
  }

  dispatchUpload() {
    BlocProvider.of<ArtworkUploadBloc>(context).add(UploadNewArtworkEvent(
      title: title,
      category: category,
      price: price,
      artistName: artistName,
      description: description,
      imageFiles: imageFiles,
      sold: sold,
    ));
  }
}
