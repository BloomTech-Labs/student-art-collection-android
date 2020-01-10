import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:student_art_collection/core/util/secret.dart';

class SecretLoader {
  final String secretPath;

  SecretLoader({this.secretPath = 'secrets.json'});

  Future<Secret> load() {
    return rootBundle.loadStructuredData<Secret>(this.secretPath,
        (jsonStr) async {
      final secret = Secret.fromJson(json.decode(jsonStr));
      return secret;
    });
  }
}
