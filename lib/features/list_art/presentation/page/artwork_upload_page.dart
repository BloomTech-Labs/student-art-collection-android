import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  DateTime selectedDate = DateTime.now();

  final dateTextController = TextEditingController();
  final priceTextController = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: selectedDate,
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dateTextController.text = formatDate(selectedDate);
      });
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
              Flexible(
                fit: FlexFit.loose,
                flex: 4,
                child: Container(
                  color: Colors.blue,
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
                      decoration: getAuthInputDecoration('Enter artwork title'),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        artistName = value;
                      },
                      decoration:
                          getAuthInputDecoration('Enter student\'s name'),
                    ),
                    SizedBox(height: 10),
                    Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        TextField(
                          enabled: false,
                          decoration:
                              getAuthInputDecoration('Select created date'),
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
                              getAuthInputDecoration('Select artwork price'),
                          controller: priceTextController,
                        ),
                      ],
                    ),
                    RaisedButton(
                      onPressed: () {
                        dispatchUpload();
                      },
                      child: Text(
                        'Test',
                      ),
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
        category: 1,
        price: 20,
        sold: false,
        title: 'Android Test Art',
        artistName: 'Test Student',
        description: 'Test description',
        imageUrls: [
          'https://images.pexels.com/photos/102127/pexels-photo-102127.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
          'https://images.pexels.com/photos/459225/pexels-photo-459225.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=940',
          'https://images.pexels.com/photos/2303796/pexels-photo-2303796.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
          'https://images.pexels.com/photos/459225/pexels-photo-459225.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
        ]));
  }
}
