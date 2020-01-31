import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:student_art_collection/core/presentation/widget/empty_container.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/profile/school_profile_bloc.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/profile/school_profile_event.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/profile/school_profile_state.dart';
import 'package:student_art_collection/features/list_art/presentation/widget/auth_input_decoration.dart';
import 'package:student_art_collection/features/list_art/presentation/widget/horizontal_progress_bar.dart';

import '../../../../service_locator.dart';

class SchoolProfilePage extends StatefulWidget {
  static const String ID = "school_profile";

  @override
  _SchoolProfilePageState createState() => _SchoolProfilePageState();
}

class _SchoolProfilePageState extends State<SchoolProfilePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  BuildContext _blocContext;

  final schoolNameController = TextEditingController();
  final schoolAddressController = TextEditingController();
  final schoolCityController = TextEditingController();
  final schoolZipcodeController = TextEditingController();

  String schoolName;
  String address;
  String city;
  String zipcode;
  String state;

  void setSchoolInfo(School school) {
    schoolNameController.text = school.schoolName;
    schoolAddressController.text = school.address;
    schoolCityController.text = school.city;
    schoolZipcodeController.text = school.zipcode;

    schoolName = school.schoolName;
    address = school.address;
    city = school.city;
    zipcode = school.zipcode;
  }

  @override
  Widget build(BuildContext context) => BlocProvider<SchoolProfileBloc>(
        create: (context) => sl<SchoolProfileBloc>(),
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            bottom: PreferredSize(
              preferredSize: Size(double.infinity, 1.0),
              child: BlocBuilder<SchoolProfileBloc, SchoolProfileState>(
                builder: (context, state) {
                  _blocContext = context;
                  if (state is SchoolProfileLoading) {
                    return AppBarLoading();
                  }
                  return EmptyContainer();
                },
              ),
            ),
            centerTitle: true,
            title: BlocBuilder<SchoolProfileBloc, SchoolProfileState>(
              builder: (context, state) {
                if (state is SchoolProfileInitial) {
                  return Text(
                    state.school.schoolName,
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  );
                } else if (state is SchoolProfileUpdated) {
                  return Text(
                    state.school.schoolName,
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  );
                } else {
                  return Text(
                    'Profile',
                    style: TextStyle(fontSize: 24),
                  );
                }
              },
            ),
          ),
          body: BlocListener<SchoolProfileBloc, SchoolProfileState>(
            listener: (context, state) {
              if (state is SchoolProfileInitial) {
                setSchoolInfo(state.school);
              } else if (state is SchoolProfileUpdated) {
                setState(() {
                  schoolNameController.text = state.school.schoolName;
                  schoolAddressController.text = state.school.address;
                  schoolCityController.text = state.school.city;
                  schoolZipcodeController.text = state.school.zipcode;
                });
              } else if (state is SchoolProfileError) {
                showSnackBar(state.message);
              } else if (state is SchoolProfileUpdated) {
                showSnackBar('School Information was updated!');
              }
            },
            child: BlocBuilder<SchoolProfileBloc, SchoolProfileState>(
              builder: (context, state) {
                if (state is SchoolProfileInitial) {
                  setSchoolInfo(state.school);
                }
                return Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'School Information',
                            style: TextStyle(fontSize: 24),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextField(
                            onChanged: (value) {
                              schoolName = value;
                            },
                            decoration: getAuthInputDecoration('Name'),
                            controller: schoolNameController,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextField(
                            onChanged: (value) {
                              address = value;
                            },
                            decoration:
                                getAuthInputDecoration('Street Address'),
                            controller: schoolAddressController,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: <Widget>[
                              Flexible(
                                flex: 1,
                                child: TextField(
                                  onChanged: (value) {
                                    city = value;
                                  },
                                  decoration: getAuthInputDecoration('City'),
                                  controller: schoolCityController,
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Flexible(
                                flex: 1,
                                child: TextField(
                                  onChanged: (value) {
                                    zipcode = value;
                                  },
                                  decoration: getAuthInputDecoration('Zipcode'),
                                  controller: schoolZipcodeController,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              FloatingActionButton(
                                elevation: 4,
                                onPressed: () {
                                  if (state is SchoolProfileLoading) {
                                    showSnackBar(
                                        'Please wait until loading is complete');
                                  } else {
                                    dispatchUpdate();
                                  }
                                },
                                backgroundColor: accentColor,
                                child: Icon(Icons.check),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

  void showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  dispatchUpdate() {
    BlocProvider.of<SchoolProfileBloc>(_blocContext).add(
      UpdateSchoolInfoEvent(
        schoolName: schoolName,
        city: city,
        address: address,
        zipcode: zipcode,
        state: state,
      ),
    );
  }
}
