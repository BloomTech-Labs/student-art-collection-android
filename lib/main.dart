import 'package:flutter/material.dart';
import 'package:student_art_collection/core/presentation/page/login_page.dart';
import 'package:student_art_collection/core/util/route_generator.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_localization.dart';
import 'service_locator.dart' as locator;

//test
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await locator.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          textTheme: TextTheme(
            title: TextStyle(color: Colors.white, fontSize: 20),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          color: primaryColor,
        ),
        primaryColor: primaryColor,
        accentColor: accentColor,
      ),
      initialRoute: LoginPage.ID,
      onGenerateRoute: RouteGenerator.generateRoute,
      supportedLocales: [
        Locale('en', 'US'),
        Locale('es', 'MX'),
        Locale('es', 'AR'),
        Locale('es', 'CL'),
        Locale('es', 'CO'),
        Locale('es', 'PE'),
        Locale('es', 'PR'),
        Locale('es', 'ES'),
        Locale('es', 'VE'),
        Locale('fr', 'BE'),
        Locale('fr', 'CA'),
        Locale('fr', 'FR'),
        Locale('fr', 'LU'),
        Locale('fr', 'CH'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
    );
  }
}
