import 'package:flutter/material.dart';
import 'package:flutter_app/pages/login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_app/stuff/themes.dart';
import 'package:flutter_app/stuff/language.dart';
import 'package:easy_localization/easy_localization.dart';

/// the appBar that is shown at the to of main site
class MainAppbar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _MainAppbarState createState() => _MainAppbarState();

  @override
  Size get preferredSize {
    return new Size.fromHeight(kToolbarHeight);
  }
}

class _MainAppbarState extends State<MainAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Container(),
      backgroundColor: Theme.of(context).primaryColor,
      title: SelectableText("DCAF-Analyzer"),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0, 5, 12, 12),
          child: SettingsPopup(),
        ),
      ],
    );
  }
}

/// the settings that get shown, when clicking on button in appBar (darkMode, language, logout)
class SettingsPopup extends StatefulWidget {
  @override
  _SettingsPopupState createState() => _SettingsPopupState();
}

class _SettingsPopupState extends State<SettingsPopup> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Center(
        child: Icon(
          FontAwesomeIcons.user,
        ),
      ),
      tooltip: 'openSettings'.tr().toString(),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                children: <Widget>[
                  /// languageButton
                  InkWell(
                    onTap: () {
                      if (LanguageSetting.selectedLanguage == Language.german) {
                        languageSetting.setLanguage(Language.english, context);
                      } else if (LanguageSetting.selectedLanguage ==
                          Language.english) {
                        languageSetting.setLanguage(Language.german, context);
                      }
                    },
                    child: Container(
                      width: 300,
                      height: 50,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              'language'.tr().toString(),
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Container(
                              height: 30,
                              child: ToggleButtons(
                                children: <Widget>[
                                  Text("DE"),
                                  Text("EN"),
                                ],
                                fillColor: Colors.grey[400],
                                borderRadius: BorderRadius.circular(8),
                                borderWidth: 2,
                                borderColor: Colors.grey,
                                selectedBorderColor: Colors.grey,
                                isSelected: [
                                  LanguageSetting.selectedLanguage ==
                                      Language.german,
                                  LanguageSetting.selectedLanguage ==
                                      Language.english
                                ],
                                onPressed: (int index) {
                                  if (LanguageSetting.selectedLanguage ==
                                      Language.german) {
                                    languageSetting.setLanguage(
                                        Language.english, context);
                                  } else if (LanguageSetting.selectedLanguage ==
                                      Language.english) {
                                    languageSetting.setLanguage(
                                        Language.german, context);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// themeButton
                  InkWell(
                    onTap: () {
                      currentTheme.toggleTheme();
                      setState(() {});
                    },
                    child: Container(
                      width: 300,
                      height: 60,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              'color'.tr().toString(),
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Container(
                              width: 120,
                              height: 50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: 60,
                                    child: Stack(
                                      overflow: Overflow.visible,
                                      children: [
                                        CustomPaint(
                                          size: Size(40, 40),
                                          painter: ThemeCircle(
                                            primaryColor: CustomTheme
                                                .lightTheme.primaryColor,
                                            backgroundColor: CustomTheme
                                                .lightTheme.backgroundColor,
                                            accentColor: !CustomTheme.darkMode
                                                ? CustomTheme
                                                    .lightTheme.accentColor
                                                : Colors.grey[400],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 60,
                                    child: Stack(
                                      overflow: Overflow.visible,
                                      children: [
                                        CustomPaint(
                                          size: Size(40, 40),
                                          painter: ThemeCircle(
                                            primaryColor: CustomTheme
                                                .darkTheme.primaryColor,
                                            backgroundColor: CustomTheme
                                                .darkTheme.backgroundColor,
                                            accentColor: CustomTheme.darkMode
                                                ? CustomTheme
                                                    .darkTheme.accentColor
                                                : Colors.grey[400],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    indent: 10,
                    endIndent: 10,
                    thickness: 2,
                  ),

                  /// Logoutbutton
                  Container(
                    width: 300,
                    height: 50,
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        _logout();
                        // Navigator.pushReplacementNamed(context, "/login");
                      },
                      child: Container(
                        width: 300,
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  /// gets called by logoutButton closes webSocket and goes back to login
  Future _logout() async {
    channel.sink.add("logout");
    channel.sink.close();

    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }
}

/// visual custom circle which gets used in themeButton
class ThemeCircle extends CustomPainter {
  final Color primaryColor;
  final Color backgroundColor;
  final Color accentColor;

  const ThemeCircle(
      {Key key, this.primaryColor, this.accentColor, this.backgroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    // Circle
    Paint paint_1 = new Paint()
      ..color = this.accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.5000000, size.height * 0.1111600);
    path_1.cubicTo(
        size.width * 0.6551200,
        size.height * 0.1111600,
        size.width * 0.8883400,
        size.height * 0.2198600,
        size.width * 0.8883400,
        size.height * 0.4995000);
    path_1.cubicTo(
        size.width * 0.8883400,
        size.height * 0.6546200,
        size.width * 0.7718600,
        size.height * 0.8878400,
        size.width * 0.5000000,
        size.height * 0.8878400);
    path_1.cubicTo(
        size.width * 0.3446400,
        size.height * 0.8878400,
        size.width * 0.1116600,
        size.height * 0.7713600,
        size.width * 0.1116600,
        size.height * 0.4995000);
    path_1.cubicTo(
        size.width * 0.1116600,
        size.height * 0.3441400,
        size.width * 0.2281400,
        size.height * 0.1111600,
        size.width * 0.5000000,
        size.height * 0.1111600);
    path_1.close();

    canvas.drawPath(path_1, paint_1);

    // line in circle
    Paint paint_2 = new Paint()
      ..color = this.accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.7762600, size.height * 0.2236600);
    path_2.lineTo(size.width * 0.2278400, size.height * 0.7769200);

    canvas.drawPath(path_2, paint_2);

    // half circle right
    Paint paint_3 = new Paint()
      ..color = this.backgroundColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path_3 = Path();
    path_3.moveTo(size.width * 0.7767600, size.height * 0.2377200);
    path_3.cubicTo(
        size.width * 0.3780800,
        size.height * 0.6394400,
        size.width * 0.3755200,
        size.height * 0.6433600,
        size.width * 0.2424600,
        size.height * 0.7777400);
    path_3.cubicTo(
        size.width * 0.3413800,
        size.height * 0.8696800,
        size.width * 0.5849800,
        size.height * 0.9505600,
        size.width * 0.7680200,
        size.height * 0.7687400);
    path_3.cubicTo(
        size.width * 0.9530000,
        size.height * 0.5713200,
        size.width * 0.8705000,
        size.height * 0.3154400,
        size.width * 0.7767600,
        size.height * 0.2377200);
    path_3.close();

    canvas.drawPath(path_3, paint_3);

    // half circle left
    Paint paint_4 = new Paint()
      ..color = this.primaryColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path_4 = Path();
    path_4.moveTo(size.width * 0.2265200, size.height * 0.7628800);
    path_4.cubicTo(
        size.width * 0.6276350,
        size.height * 0.3587950,
        size.width * 0.6294400,
        size.height * 0.3584400,
        size.width * 0.7631400,
        size.height * 0.2237400);
    path_4.cubicTo(
        size.width * 0.7106200,
        size.height * 0.1669200,
        size.width * 0.4555600,
        size.height * 0.0222600,
        size.width * 0.2351200,
        size.height * 0.2254400);
    path_4.cubicTo(
        size.width * 0.0179600,
        size.height * 0.4722600,
        size.width * 0.1667200,
        size.height * 0.7160000,
        size.width * 0.2265200,
        size.height * 0.7628800);
    path_4.close();

    canvas.drawPath(path_4, paint_4);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
