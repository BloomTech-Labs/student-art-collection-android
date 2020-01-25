import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:student_art_collection/core/presentation/bloc/base_artwork_filter_type.dart';
import 'package:student_art_collection/core/presentation/bloc/base_artwork_sort_type.dart';
import 'package:student_art_collection/core/util/functions.dart';
import 'package:student_art_collection/core/util/text_constants.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';
import 'package:student_art_collection/features/list_art/presentation/widget/auth_input_decoration.dart';

import '../../../app_localization.dart';

class FilterDrawer extends StatefulWidget {
  final Widget scaffold;
  final GlobalKey innerDrawerKey;
  final Function(
    Map<String, FilterType> filterTypes,
    SortType sortType,
  ) onApplyPressed;
  final bool isSchool;

  FilterDrawer({
    this.scaffold,
    this.onApplyPressed,
    this.innerDrawerKey,
    this.isSchool,
  });

  @override
  _FilterDrawerState createState() => _FilterDrawerState(
        innerDrawerKey,
        scaffold: scaffold,
        onApplyPressed: onApplyPressed,
        isSchool: isSchool,
      );
}

class _FilterDrawerState extends State<FilterDrawer> {
  final Widget scaffold;
  GlobalKey _innerDrawerKey;
  final Function(
    Map<String, FilterType> filterTypes,
    SortType sortType,
  ) onApplyPressed;
  final bool isSchool;

  bool nearMeSelected = false;
  String _selectedCategory;
  String _searchQuery;

  final searchTextController = TextEditingController();

  void clearSearch() {
    setState(() {
      _searchQuery = null;
      searchTextController.clear();
    });
  }

  SortType selectedSortType;
  FilterTypeSearch filterTypeName = FilterTypeSearch(searchQuery: '');
  FilterTypeZipCode filterTypeZipCode = FilterTypeZipCode();
  FilterTypeCategory filterTypeCategory = FilterTypeCategory();

  _FilterDrawerState(
    GlobalKey key, {
    this.scaffold,
    this.onApplyPressed,
    this.isSchool,
  }) {
    _innerDrawerKey = key;
  }

  List<String> schoolSortLabels = [
    TEXT_ARTWORK_SORT_TITLE_ASC_LABEL,
    TEXT_ARTWORK_SORT_TITLE_DESC_LABEL,
    TEXT_ARTWORK_SORT_ARTIST_NAME_ASC_LABEL,
    TEXT_ARTWORK_SORT_ARTIST_NAME_DESC_LABEL,
    TEXT_ARTWORK_SORT_MOST_RECENT_LABEL,
    TEXT_ARTWORK_SORT_OLDEST_LABEL,
    TEXT_ARTWORK_SORT_MOST_EXPENSIVE_LABEL,
    TEXT_ARTWORK_SORT_LEAST_EXPENSIVE_LABEL,
  ];

  List<String> buyerSortLabels = [
    TEXT_ARTWORK_SORT_TITLE_ASC_LABEL,
    TEXT_ARTWORK_SORT_TITLE_DESC_LABEL,
    TEXT_ARTWORK_SORT_SCHOOL_NAME_ASC_LABEL,
    TEXT_ARTWORK_SORT_SCHOOL_NAME_DESC_LABEL,
    TEXT_ARTWORK_SORT_ARTIST_NAME_ASC_LABEL,
    TEXT_ARTWORK_SORT_ARTIST_NAME_DESC_LABEL,
    TEXT_ARTWORK_SORT_MOST_RECENT_LABEL,
    TEXT_ARTWORK_SORT_OLDEST_LABEL,
    TEXT_ARTWORK_SORT_MOST_EXPENSIVE_LABEL,
    TEXT_ARTWORK_SORT_LEAST_EXPENSIVE_LABEL,
  ];

  List<String> getLocalizedLabels(List<String> labels) {
    List<String> localizedLabels = [];
    labels.forEach((label) {
      localizedLabels.add(displayLocalizedString(label));
    });
    return localizedLabels;
  }

  List categories = [
    TEXT_ARTWORK_UPLOAD_CATEGORY_1,
    TEXT_ARTWORK_UPLOAD_CATEGORY_2,
    TEXT_ARTWORK_UPLOAD_CATEGORY_3,
    TEXT_ARTWORK_UPLOAD_CATEGORY_4,
    TEXT_ARTWORK_UPLOAD_CATEGORY_5,
    TEXT_ARTWORK_UPLOAD_CATEGORY_6,
  ];

  List<DropdownMenuItem> generateMenuCategories() {
    List<DropdownMenuItem> items = [];
    categories.forEach((categoryLabel) {
      items.add(DropdownMenuItem(
        value: categoryLabel,
        child: Container(
          color: primaryColor,
          child: Text(displayLocalizedString(categoryLabel)),
        ),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InnerDrawer(
        key: _innerDrawerKey,
        rightChild: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 16),
            child: Column(
              children: <Widget>[
                Text(
                  'Filter',
                  style: TextStyle(
                    inherit: false,
                    fontSize: 24,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 16,
                    bottom: 8,
                  ),
                  child: Stack(
                    children: <Widget>[
                      TextField(
                        style: TextStyle(
                          color: accentColorOnPrimary,
                        ),
                        controller: searchTextController,
                        onChanged: (value) {
                          _searchQuery = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'Search',
                          labelStyle: TextStyle(
                            color: accentColorOnPrimary,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: accentColorOnPrimary,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: accentColorOnPrimary,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 1,
                        bottom: 1,
                        child: IconButton(
                          onPressed: () {
                            clearSearch();
                          },
                          icon: Icon(
                            Icons.clear,
                            color: accentColorOnPrimary,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Theme(
                  data: ThemeData(
                    canvasColor: primaryColor,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton(
                        hint: Text(
                          'Select Category',
                          style: TextStyle(
                            color: accentColorOnPrimary,
                          ),
                        ),
                        items: categories.map((category) {
                          return new DropdownMenuItem(
                            value: category,
                            child: Text(
                              displayLocalizedString(category),
                              style: TextStyle(
                                color: accentColorOnPrimary,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                        value: _selectedCategory,
                      ),
                    ),
                  ),
                ),
                !isSchool
                    ? Theme(
                        data: ThemeData(
                          unselectedWidgetColor: accentColorOnPrimary,
                        ),
                        child: CheckboxGroup(
                          onSelected: (label) {},
                          labelStyle: TextStyle(
                            color: accentColorOnPrimary,
                            fontSize: 16,
                          ),
                          activeColor: primaryColor,
                          labels: ['Only Art Near Me'],
                        ),
                      )
                    : Container(),
                Text(
                  'Sort',
                  style: TextStyle(
                    inherit: false,
                    fontSize: 24,
                  ),
                ),
                Divider(
                  color: accentColorOnPrimary,
                ),
                Theme(
                  data: ThemeData(
                    unselectedWidgetColor: accentColorOnPrimary,
                  ),
                  child: RadioButtonGroup(
                    onSelected: (label) {
                      selectedSortType = convertLabelToSortType(label);
                    },
                    labelStyle: TextStyle(
                      color: accentColorOnPrimary,
                      fontSize: 16,
                    ),
                    activeColor: accentColorOnPrimary,
                    labels: isSchool
                        ? getLocalizedLabels(schoolSortLabels)
                        : getLocalizedLabels(buyerSortLabels),
                  ),
                ),
                Divider(
                  color: accentColorOnPrimary,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    OutlineButton(
                      highlightedBorderColor: primaryColor,
                      splashColor: accentColorOnPrimary,
                      child: Text(
                        'Apply',
                        style: TextStyle(
                          color: accentColorOnPrimary,
                        ),
                      ),
                      onPressed: () {
                        onApplyPressed({
                          'category': filterTypeCategory,
                          'zipcode': filterTypeZipCode,
                          'search': filterTypeName
                        }, selectedSortType);
                      },
                      borderSide: BorderSide(
                        color: accentColorOnPrimary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        onTapClose: true,
        swipe: true,
        colorTransition: primaryColor,
        proportionalChildArea: true,
        borderRadius: 4,
        leftAnimationType: InnerDrawerAnimation.static,
        rightAnimationType: InnerDrawerAnimation.quadratic,
        backgroundColor: primaryColor,
        innerDrawerCallback: (a) => print(a),
        scaffold: scaffold,
      ),
    );
  }

  String displayLocalizedString(String label) {
    return AppLocalizations.of(context).translate(label);
  }

  SortType convertLabelToSortType(String label) {
    if (label == displayLocalizedString(TEXT_ARTWORK_SORT_TITLE_ASC_LABEL))
      return SortNameAsc();
    else if (label ==
        displayLocalizedString(TEXT_ARTWORK_SORT_TITLE_DESC_LABEL))
      return SortNameDesc();
    else if (label ==
        displayLocalizedString(TEXT_ARTWORK_SORT_SCHOOL_NAME_ASC_LABEL))
      return SortSchoolNameAsc();
    else if (label ==
        displayLocalizedString(TEXT_ARTWORK_SORT_SCHOOL_NAME_DESC_LABEL))
      return SortSchoolNameDesc();
    else if (label ==
        displayLocalizedString(TEXT_ARTWORK_SORT_ARTIST_NAME_ASC_LABEL))
      return SortStudentNameAsc();
    else if (label ==
        displayLocalizedString(TEXT_ARTWORK_SORT_ARTIST_NAME_DESC_LABEL))
      return SortStudentNameDesc();
    else if (label ==
        displayLocalizedString(TEXT_ARTWORK_SORT_MOST_RECENT_LABEL))
      return SortDatePostedDesc();
    else if (label == displayLocalizedString(TEXT_ARTWORK_SORT_OLDEST_LABEL))
      return SortDatePostedAsc();
    else if (label ==
        displayLocalizedString(TEXT_ARTWORK_SORT_MOST_EXPENSIVE_LABEL))
      return SortPriceDesc();
    else if (label ==
        displayLocalizedString(TEXT_ARTWORK_SORT_LEAST_EXPENSIVE_LABEL))
      return SortPriceAsc();
    else
      return SortNameAsc();
  }
}
