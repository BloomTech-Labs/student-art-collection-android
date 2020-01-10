import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:student_art_collection/core/util/secret.dart';

class SecretLoader {
  final String secretPath;

  SecretLoader({this.secretPath = 'secrets.json'});

  Future<CloudinarySecret> load() {
    return rootBundle.loadStructuredData<CloudinarySecret>(this.secretPath,
        (jsonStr) async {
      final secret = CloudinarySecret.fromJson(json.decode(jsonStr));
      return secret;
    });
  }
}
