import 'package:flutter/material.dart';
import 'package:flutter_app/data/message/MessageCAMtoC.dart';
import 'package:flutter_app/data/message/MessageCAMtoSAM.dart';
import 'package:flutter_app/data/message/MessageCtoCAM.dart';
import 'package:flutter_app/data/message/MessageSAMtoCAM.dart';
import 'package:flutter_app/data/tickets/TicketCAMtoC.dart';
import 'package:flutter_app/data/tickets/TicketSAMtoCAM.dart';
import 'package:flutter_app/stuff/language.dart';
import 'package:flutter_app/widgets/ticketsAndRules.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_app/testData/testData.dart';
import 'package:flutter_app/widgets/informationPanel.dart';
import 'package:flutter_app/widgets/protocolInstances.dart';
import 'package:flutter_app/pages/dummy.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'dart:async';

/// for inserting data in protocolInstancesList
List<int> protocolInstanceNumbers = [-1];
int maxProtocolInstanceNumber = -1;

/// the webSocketClient gets initiated in openWebSocketConnection
WebSocketChannel channel;

/// to indicate if it is the first login(for detecting language of the Browser)
bool firstLogin = true;

/// used bellow for comparison
String numbers = "0123456789";

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  /// for getting the language of the operating system
  List<Locale> _systemLocale = WidgetsBinding.instance.window.locales;

  void initState() {
    super.initState();
  }

  /// sets the message that gets shown to the user
  void _setErrorMessage(String message) {
    setState(() {
      _error = message;
    });
  }

  /// This method handles the language of the operating system
  void _setLanguage() {
    Locale localeLanguage;
    setState(() {
      localeLanguage = _systemLocale.first;
    });

    if (localeLanguage.toString() == "de_DE") {
      setState(() {
        languageSetting.setLanguage(Language.german, context);
      });
    } else {
      setState(() {
        languageSetting.setLanguage(Language.english, context);
      });
    }
  }

  /// textControllers to change the textFields
  var _userNameController = TextEditingController();
  var _passwordController = TextEditingController();
  var _addressCAMController = TextEditingController();
  var _addressSAMController = TextEditingController();

  /// vars to let the password appear in text or dots
  bool _seePassword = false;
  Icon _iconSee = Icon(
    FontAwesomeIcons.eyeSlash,
    size: 17,
  );
  Icon _iconDontSee = Icon(
    FontAwesomeIcons.eye,
    size: 17,
  );

  /// indicates if loginButton is active (grey vs. color)
  bool _loginButton = false;

  /// ErrorMessage that is shown to user
  String _error = "";

  /// userVars
  /// should be 'admin'
  String _username = "";

  /// should be 'password'
  String _password = "";

  /// address should be 'localhost:8040'
  String _addressCAM = '';

  @override
  Widget build(BuildContext context) {
    if (firstLogin) {
      _setLanguage();
      firstLogin = false;
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(55, 170, 156, .1),
                  Color.fromRGBO(55, 170, 156, 1),
                ]),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                ),
                Text(
                  "DCAF-Analyzer",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "OpenSans",
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: 350,
                  height: 450,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'hello'.tr().toString(),
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'loginPls'.tr().toString(),
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 270,
                        child: TextField(
                          controller: _userNameController,
                          cursorColor: Colors.grey,
                          decoration: InputDecoration(
                            labelText: 'username'.tr().toString(),
                            suffixIcon: Icon(
                              FontAwesomeIcons.user,
                              size: 17,
                            ),
                          ),
                          onChanged: (value) {
                            _username = value;
                            _checkForLoginButton();
                          },
                        ),
                      ),

                      Container(
                        width: 270,
                        child: TextField(
                          controller: _passwordController,
                          cursorColor: Colors.grey,
                          obscureText: !_seePassword,
                          decoration: InputDecoration(
                            labelText: 'password'.tr().toString(),
                            suffixIcon: IconButton(
                              icon: _seePassword ? _iconDontSee : _iconSee,
                              onPressed: () {
                                setState(() {
                                  _seePassword = !_seePassword;
                                });
                              },
                            ),
                          ),
                          onChanged: (value) {
                            _password = value;
                            _checkForLoginButton();
                          },
                        ),
                      ),
                      Container(
                        width: 270,
                        child: TextField(
                          controller: _addressCAMController,
                          cursorColor: Colors.grey,
                          decoration: InputDecoration(
                            labelText: "addressFromAM".tr().toString(),
                          ),
                          onChanged: (value) {
                            _addressCAM = value;
                            _checkForLoginButton();
                          },
                        ),
                      ),

                      SizedBox(
                        height: 35,
                      ),

                      /// for ErrorMessages
                      Visibility(
                        visible: _error != "",
                        child: Text(
                          _error,
                          style: TextStyle(
                            color: Colors.red[700],
                            fontSize: 20,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 35,
                      ),

                      /// This container contains the login-button which handles the login-functions
                      Container(
                        alignment: Alignment.center,
                        width: 250,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: _loginButton
                                ? [
                                    Color.fromRGBO(55, 170, 156, 1),
                                    Color.fromRGBO(55, 170, 156, .7),
                                  ]
                                : [Colors.grey[600], Colors.grey[500]],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Container(
                            alignment: Alignment.center,
                            child: TextButton(
                              style: ButtonStyle(
                                minimumSize:
                                    MaterialStateProperty.all(Size(300, 100)),
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0x00000000)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                _loginButton
                                    ? openWebSocketConnection(context)
                                    : null;
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// to check if loginButton should be active or not
  void _checkForLoginButton() {
    if (_username.length > 0 &&
        _password.length > 0 &&
        _addressCAM.length > 0) {
      setState(() {
        _loginButton = true;
      });
    } else {
      setState(() {
        _loginButton = false;
      });
    }
  }

  /// to handle incoming data on webSocket
  void onData(dynamic data) {
    String _messageType = "";

    print(data);

    String newData = data;

    List<Message> newMessages;
    List<Ticket> newTickets;

    /// to see if newData starts with number (for ProtocolInstanceCounter)
    int count = 0;
    String prefixNumberStr = "";
    int prefixNumber = -1;

    for (int i = 0; i < newData.length; i++) {
      var c = newData[i];
      if (numbers.contains(c)) {
        prefixNumberStr += c;
        count++;
      } else {
        break;
      }
    }
    prefixNumberStr.length != 0
        ? prefixNumber = int.parse(prefixNumberStr)
        : null;
    newData = newData.substring(count);
    print("prefixNumber: " + prefixNumber.toString());

    if (newData.startsWith('mCtoCAM: ')) {
      _messageType = "m";
      newData = newData.substring(9);
      var jsonMessages = jsonDecode(newData) as List;
      newMessages = jsonMessages
          .map((tagJson) => MessageCtoCAM.fromJson(tagJson))
          .toList();
    } else if (newData.startsWith('mCAMtoSAM: ')) {
      _messageType = "m";
      newData = newData.substring(11);
      var jsonMessages = jsonDecode(newData) as List;
      newMessages = jsonMessages
          .map((tagJson) => MessageCAMtoSAM.fromJson(tagJson))
          .toList();
    } else if (newData.startsWith('mSAMtoCAM: ')) {
      _messageType = "m";
      newData = newData.substring(11);
      var jsonMessages = jsonDecode(newData) as List;
      newMessages = jsonMessages
          .map((tagJson) => MessageSAMtoCAM.fromJson(tagJson))
          .toList();
    } else if (newData.startsWith('mCAMtoC: ')) {
      _messageType = "m";
      newData = newData.substring(9);
      var jsonMessages = jsonDecode(newData) as List;
      newMessages = jsonMessages
          .map((tagJson) => MessageCAMtoC.fromJson(tagJson))
          .toList();
    } else if (newData.startsWith('tSAMtoCAM: ')) {
      _messageType = "t";
      newData = newData.substring(11);
      var jsonMessages = jsonDecode(newData) as List;
      newTickets = jsonMessages
          .map((tagJson) => TicketSAMtoCAM.fromJson(tagJson))
          .toList();
    } else if (newData.startsWith('tCAMtoC: ')) {
      _messageType = "t";
      newData = newData.substring(9);
      var jsonMessages = jsonDecode(newData) as List;
      newTickets = jsonMessages
          .map((tagJson) => TicketCAMtoC.fromJson(tagJson))
          .toList();
    } else if (newData.startsWith('connecting: ')) {
      _messageType = "c";
      newData = newData.substring(12);

      if (newData == "200") {
        /// resetting all Data from previous session to login
        testProtocolInstances = [
          new ProtocolInstance([], [], testRulesSAMC, testRulesCAMC)
        ];
        selectedProtocolInstance = 0;
        tappedMessageIndex = -1;
        activeTabBarIndex = 0;
        expandedTiles = [1, 1, 1];
        numberOfExpandedTiles = 3;
        protocolInstanceNumbers = [-1];
        maxProtocolInstanceNumber = -1;

        Navigator.pushNamed(context, "/dummy");

        /// resetting userdata

        _username = "";
        _password = "";
        _addressCAM = "";

        _userNameController.text = "";
        _passwordController.text = "";
        _addressCAMController.text = "";

        _error = "";

        _checkForLoginButton();
      } else if (newData == "end") {
        webSocketEndStreamController.add(true);
      } else {
        _setErrorMessage(newData);
      }
      return;
    } else {
      print("Message has the wrong syntax");
    }

    if (_messageType == "m") {
      print("newMessage");

      if (maxProtocolInstanceNumber == -1) {
        testProtocolInstances[0].addNewMessage(newMessages[0]);
        protocolInstanceNumbers[0] = prefixNumber;
        maxProtocolInstanceNumber = prefixNumber;
        streamControllerNewMatZero.add(true);
      } else if (protocolInstanceNumbers.contains(prefixNumber)) {
        testProtocolInstances[protocolInstanceNumbers.indexOf(prefixNumber)]
            .addNewMessage(newMessages[0]);

        /// only if Messages have been empty before the protocolInstances have to be re rendered
        if (testProtocolInstances[protocolInstanceNumbers.indexOf(prefixNumber)]
                .messages
                .length ==
            1) {
          streamControllerNewMatZero.add(true);
        }
      } else {
        ProtocolInstance newProtocolInstance =
            new ProtocolInstance([], [], testRulesSAMC, testRulesCAMC);
        newProtocolInstance.addNewMessage(newMessages[0]);
        testProtocolInstances.add(newProtocolInstance);
        protocolInstanceNumbers.add(prefixNumber);
        maxProtocolInstanceNumber = prefixNumber;

        /// insert new protocolInstance visually
        if (activeTabBarIndex == 1) {
          protocolInstancesKey.currentState
              .insertItem(testProtocolInstances.length - 1);
          scrollControllerProtocolInstances.scrollToIndex(
              testProtocolInstances.length - 1,
              preferPosition: AutoScrollPosition.begin);
        }
      }

      if (protocolInstanceNumbers.indexOf(prefixNumber) ==
          selectedProtocolInstance) {
        /// for graph
        graphListKey.currentState.insertItem(
            testProtocolInstances[selectedProtocolInstance].messages.length -
                1);
        if (tappedMessageIndex == -1) {
          /// for graph
          scrollControllerGraph.scrollToIndex(
            testProtocolInstances[selectedProtocolInstance].messages.length - 1,
            preferPosition: AutoScrollPosition.begin,
          );

          /// for bottomPanel
          scrollControllerBottomPanel.scrollToIndex(
            testProtocolInstances[selectedProtocolInstance].messages.length - 1,
            preferPosition: AutoScrollPosition.begin,
          );
        }

        /// for bottomPanel
        messageListKey.currentState.insertItem(
            testProtocolInstances[selectedProtocolInstance].messages.length -
                1);
      }
    } else if (_messageType == "t") {
      print("newTicket");

      if (maxProtocolInstanceNumber == -1) {
        testProtocolInstances[0]..addNewTicket(newTickets[0]);
        protocolInstanceNumbers[0] = prefixNumber;
        maxProtocolInstanceNumber = prefixNumber;
      } else if (protocolInstanceNumbers.contains(prefixNumber)) {
        testProtocolInstances[protocolInstanceNumbers.indexOf(prefixNumber)]
            .addNewTicket(newTickets[0]);
      } else {
        ProtocolInstance newProtocolInstance =
            new ProtocolInstance([], [], testRulesSAMC, testRulesCAMC);
        newProtocolInstance.addNewTicket(newTickets[0]);
        testProtocolInstances.add(newProtocolInstance);
        protocolInstanceNumbers.add(prefixNumber);
        maxProtocolInstanceNumber = prefixNumber;

        /// insert new protocolInstance visually
        if (activeTabBarIndex == 1) {
          protocolInstancesKey.currentState
              .insertItem(testProtocolInstances.length - 1);
          scrollControllerProtocolInstances.scrollToIndex(
              testProtocolInstances.length - 1,
              preferPosition: AutoScrollPosition.begin);
        }
      }

      /// insert new tickets visually
      if (protocolInstanceNumbers.indexOf(prefixNumber) ==
              selectedProtocolInstance &&
          activeTabBarIndex == 0) {
        ticketListKey.currentState.insertItem(
            testProtocolInstances[selectedProtocolInstance].tickets.length - 1);
        scrollControllerTicket.scrollToIndex(
            testProtocolInstances[selectedProtocolInstance].tickets.length - 1,
            preferPosition: AutoScrollPosition.begin);
      }
    }
  }

  Future openWebSocketConnection(BuildContext context) async {
    print("connecting to webSocket");

    try {
      channel =
          WebSocketChannel.connect(Uri.parse("wss://" + _addressCAM + "/"));
    } catch (exception) {
      print(exception);
      _setErrorMessage("Address has wrong syntax");
    }

    print("sending username and password");
    channel.sink.add("$_username,$_password");

    channel.stream.listen(onData, onError: (error) {
      print("in Error");
      _setErrorMessage("Connecting to AM failed");
    }, cancelOnError: true);
  }
}
