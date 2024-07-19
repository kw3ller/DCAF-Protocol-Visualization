import 'package:flutter/material.dart';
import 'package:flutter_app/pages/dummy.dart';
import 'package:flutter_app/pages/login.dart';
import 'package:flutter_app/stuff/themes.dart';
import 'package:easy_localization/easy_localization.dart';

/// main function wraps MyApp with easyLocalization for languageSupport
void main() {
  runApp(
    EasyLocalization(
      child: MyApp(),
      path: "resources/langs",
      saveLocale: true,
      supportedLocales: [
        Locale('en', 'US'),
        Locale('de', 'DE'),
      ],
    ),
  );
}

/// mainApp with themes and routes for all sites
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: "DCAF-Analyzer",
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      themeMode: currentTheme.currentTheme,
      initialRoute: "/login",
      routes: {
        "/dummy": (context) => Dummy(setInstanceStreamController.stream,
            webSocketEndStreamController.stream),
        "/login": (context) => Login()
      },
    );
  }
}
