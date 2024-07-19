import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/testData/testData.dart';
import 'package:flutter_app/widgets/appbar.dart';
import 'package:flutter_app/widgets/arrows.dart';
import 'package:flutter_app/stuff/themes.dart';
import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/widgets/informationPanel.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import '../data/message/MessageCtoCAM.dart';
import '../data/message/MessageCAMtoSAM.dart';
import '../data/message/MessageSAMtoCAM.dart';
import '../data/message/MessageCAMtoC.dart';

/// is used to set the new protocolInstance by other widgets(protocolInstances.dart)
StreamController<int> setInstanceStreamController =
    StreamController<int>.broadcast();

/// is used to inform that socket connection was closed by AM by other widgets(login.dart)
StreamController<bool> webSocketEndStreamController =
    StreamController<bool>.broadcast();

/// is used to put new Data in message list
GlobalKey<AnimatedListState> messageListKey = GlobalKey<AnimatedListState>();

/// ScrollController for scrolling through the messageTiles
AutoScrollController scrollControllerBottomPanel = AutoScrollController();

/// ScrollController for scrolling through the graphTiles
AutoScrollController scrollControllerGraph = AutoScrollController();

/// is used to put new Data in graph list
GlobalKey<AnimatedListState> graphListKey = GlobalKey<AnimatedListState>();

/// index of selected message/graphTile
int tappedMessageIndex = -1;

/// This is the Widget of the main site where all data is shown
class Dummy extends StatefulWidget {
  Dummy(this.instanceStream, this.webSocketStream);

  final Stream<int> instanceStream;
  final Stream<bool> webSocketStream;

  @override
  _DummyState createState() => _DummyState();
}

class _DummyState extends State<Dummy> {
  /// controller for sliding up bottomPanel
  SlidingUpPanelController _bottomPanelController = SlidingUpPanelController();

  /// used to tell if BottomPanel is anchored
  bool _isAnchored = false;

  /// sets new protocolInstance to show
  void _setProtocolInstance(int index) {
    /// This is needed remove and add items to animated list which are new in new protocolInstance
    int _lengthDifference =
        testProtocolInstances[selectedProtocolInstance].messages.length -
            testProtocolInstances[index].messages.length;
    print(_lengthDifference);

    // new list is shorter than previous list: Length does not change on remove until animation is done
    if (_lengthDifference > 0) {
      for (int i = 0; i < _lengthDifference; i++) {
        print("eins wird removed");
        graphListKey.currentState.removeItem(0, (context, animation) => null);
        messageListKey.currentState.removeItem(0, (context, animation) => null);
      }
      tappedMessageIndex = -1;

      // new list is longer than previous list: adding new items
    } else if (_lengthDifference < 0) {
      for (int i = 0; i < _lengthDifference.abs(); i++) {
        print("eins wird hinzugefügt");
        graphListKey.currentState.insertItem(0);
        messageListKey.currentState.insertItem(0);
      }
    }
    print("changing Instance");

    setState(() {
      selectedProtocolInstance = index;
    });
  }

  /// when webSocket on AM closes this gets called by login.dart via webSocketEndStreamController
  _onCloseWebsocket() {
    _showWebsocketClosedNotification();
  }

  /// shows dialog that socket was closed on AM
  _showWebsocketClosedNotification() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Center(
            child: AlertDialog(
              backgroundColor: CustomTheme.darkMode
                  ? Color.fromRGBO(105, 125, 133, 1)
                  : Color.fromRGBO(210, 210, 210, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              title: Text(
                "webSocketClosed".tr().toString(),
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).textTheme.bodyText1.color),
              ),
              content: Text(
                "webSocketClosedText".tr().toString(),
                style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).textTheme.bodyText1.color),
              ),
              elevation: 24,
              actions: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 12, 12),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(
                        color: CustomTheme.darkMode
                            ? Color.fromRGBO(69, 213, 195, 1)
                            : Color.fromRGBO(69, 98, 104, 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  /// changes height of bottomContainer through isAnchored
  void _changeBottomContainerHeight(bool anchored) {
    setState(() {
      _isAnchored = anchored;
    });
  }

  /// changes selected message (in bottom- and graph panel)
  void _changeTappedMessageIndex(int index) {
    setState(() {
      tappedMessageIndex == index
          ? tappedMessageIndex = -1
          : tappedMessageIndex = index;
    });
  }

  /// scrolls to tappedMessageIndex in graph
  void _scrollToTappedGraphTile(int index) {
    if (tappedMessageIndex != -1) {
      scrollControllerGraph.scrollToIndex(index,
          preferPosition: AutoScrollPosition.middle);
    }
  }

  /// scroll to tappedMessageIndex in bottomPanel
  void _scrollToTappedBottomTile(int index) {
    if (tappedMessageIndex != -1) {
      scrollControllerBottomPanel.scrollToIndex(index,
          preferPosition: AutoScrollPosition.middle);
    }
  }

  @override
  void initState() {
    super.initState();

    widget.instanceStream.listen((index) {
      _setProtocolInstance(index);
    });
    widget.webSocketStream.listen((event) {
      _onCloseWebsocket();
    });
    _isAnchored =
        SlidingUpPanelStatus.anchored == _bottomPanelController.status;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: MainAppbar(),
          body: Center(
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      _graphTileHead(),
                      Flexible(
                        child: _graphTile(context),
                      ),
                      AnimatedContainer(
                        height: _isAnchored
                            ? MediaQuery.of(context).size.height * 0.41
                            : MediaQuery.of(context).size.height * 0.07,
                        duration: Duration(milliseconds: 200),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Flexible(
                        child: RulesAndTicket(),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
        ),
        _bottomPanel(),
      ],
    );
  }

  ///
  ///
  /// Here everything with the graph starts
  ///
  ///

  /// gives head of graph (AM C S AS)
  Widget _graphTileHead() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: CustomTheme.darkMode
            ? Color.fromRGBO(84, 100, 106, 1)
            : Color.fromRGBO(240, 240, 240, 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 40,
                width: 80,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    "AM",
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 40,
                width: 30,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                    left: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                    right: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 40,
                width: 80,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    "C",
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 40,
                width: 30,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                    left: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                    right: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 40,
                width: 80,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    "S",
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 40,
                width: 30,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                    left: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                    right: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 40,
                width: 80,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    "AS",
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 40,
                width: 30,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                    left: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                    right: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// gives one graphTile
  _graphTile(BuildContext context) {
    return Scrollbar(
      isAlwaysShown: true,
      thickness: 10,
      showTrackOnHover: true,
      controller: scrollControllerGraph,
      child: AnimatedList(
        key: graphListKey,
        controller: scrollControllerGraph,
        initialItemCount:
            testProtocolInstances[selectedProtocolInstance].messages.length,
        itemBuilder: (context, index, animation) {
          return AutoScrollTag(
            key: ValueKey(index),
            controller: scrollControllerGraph,
            index: index,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1, 0),
                end: Offset(0, 0),
              ).animate(animation),
              child: InkWell(
                  hoverColor: Color(0x00000000),
                  splashFactory: NoSplash.splashFactory,
                  onTap: () {
                    _changeTappedMessageIndex(index);
                    _scrollToTappedBottomTile(index);
                  },
                  child: (() {
                    if (testProtocolInstances[selectedProtocolInstance]
                        .messages[index] is MessageCtoCAM) {
                      print("GraphCtoCAM");
                      return _graphCtoCAM(index);
                    } else if (testProtocolInstances[selectedProtocolInstance]
                        .messages[index] is MessageCAMtoSAM) {
                      print("GraphCAMtoSAM");
                      return _graphCAMtoSAM(index);
                    } else if (testProtocolInstances[selectedProtocolInstance]
                        .messages[index] is MessageSAMtoCAM) {
                      print("GraphSAMtoCAM");
                      return _graphSAMtoCAM(index);
                    } else if (testProtocolInstances[selectedProtocolInstance]
                        .messages[index] is MessageCAMtoC) {
                      print("GraphCAMtoC");
                      return _graphCAMtoC(index);
                    } else {
                      print("null in graphPanel");
                      return null;
                    }
                  }())),
            ),
          );
        },
      ),
    );
  }

  /// gives graphTile for message C to AM
  Widget _graphCtoCAM(int index) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: (() {
          if (index == tappedMessageIndex) {
            return CustomTheme.darkMode
                ? Color.fromRGBO(105, 125, 133, 1)
                : Color.fromRGBO(210, 210, 210, 1);
          } else {
            return CustomTheme.darkMode
                ? Color.fromRGBO(84, 100, 106, 1)
                : Color.fromRGBO(240, 240, 240, 1);
          }
        }()),
      ),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                height: 150,
                width: 30,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                    right: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                  ),
                ),
              ),
              Container(
                height: 150,
                width: 30,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                    right: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                  ),
                ),
              ),
              Container(
                height: 150,
                width: 30,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                    right: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                  ),
                ),
              ),
              Container(
                height: 150,
                width: 30,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                    right: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 3 / 5 * 1 / 8,
                ),
                SizedBox(
                  width: 16,
                ),
                CustomPaint(
                  size: Size(
                      MediaQuery.of(context).size.width * 3 / 5 * 2 / 8 - 42,
                      100),
                  painter: ShortLeftArrow(),
                ),
              ],
            ),
          ),
          Center(
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 3 / 5 * 1 / 8,
                ),
                SizedBox(
                  width: 16,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 3 / 5 * 2 / 8 -
                          35,
                      child: Center(
                        child: Text(
                          (testProtocolInstances[selectedProtocolInstance]
                                      .messages[index]
                                      .method ==
                                  null
                              ? " "
                              : testProtocolInstances[selectedProtocolInstance]
                                  .messages[index]
                                  .method),
                          style: TextStyle(
                            fontSize: 20,
                            backgroundColor: (() {
                              if (index == tappedMessageIndex) {
                                return CustomTheme.darkMode
                                    ? Color.fromRGBO(105, 125, 133, 1)
                                    : Color.fromRGBO(210, 210, 210, 1);
                              } else {
                                return CustomTheme.darkMode
                                    ? Color.fromRGBO(84, 100, 106, 1)
                                    : Color.fromRGBO(240, 240, 240, 1);
                              }
                            }()),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  index.toString(),
                ),
                SizedBox(
                  width: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// gives graphTile for message AM to AS
  Widget _graphCAMtoSAM(int index) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: (() {
          if (index == tappedMessageIndex) {
            return CustomTheme.darkMode
                ? Color.fromRGBO(105, 125, 133, 1)
                : Color.fromRGBO(210, 210, 210, 1);
          } else {
            return CustomTheme.darkMode
                ? Color.fromRGBO(84, 100, 106, 1)
                : Color.fromRGBO(240, 240, 240, 1);
          }
        }()),
      ),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                height: 150,
                width: 30,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                    right: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                  ),
                ),
              ),
              Container(
                height: 150,
                width: 30,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                    right: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                  ),
                ),
              ),
              Container(
                height: 150,
                width: 30,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                    right: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                  ),
                ),
              ),
              Container(
                height: 150,
                width: 30,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                    right: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 3 / 5 * 1 / 8 - 5,
                ),
                SizedBox(
                  width: 16,
                ),
                CustomPaint(
                  size: Size(
                      MediaQuery.of(context).size.width * 3 / 5 * 6 / 8 - 55,
                      100),
                  painter: LongRightArrow(),
                ),
              ],
            ),
          ),
          Center(
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 3 / 5 * 1 / 8,
                ),
                SizedBox(
                  width: 16,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 3 / 5 * 6 / 8 -
                          40,
                      child: Center(
                        child: Text(
                          (testProtocolInstances[selectedProtocolInstance]
                                      .messages[index]
                                      .method ==
                                  null
                              ? " "
                              : testProtocolInstances[selectedProtocolInstance]
                                  .messages[index]
                                  .method),
                          style: TextStyle(
                            fontSize: 20,
                            backgroundColor: (() {
                              if (index == tappedMessageIndex) {
                                return CustomTheme.darkMode
                                    ? Color.fromRGBO(105, 125, 133, 1)
                                    : Color.fromRGBO(210, 210, 210, 1);
                              } else {
                                return CustomTheme.darkMode
                                    ? Color.fromRGBO(84, 100, 106, 1)
                                    : Color.fromRGBO(240, 240, 240, 1);
                              }
                            }()),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  index.toString(),
                ),
                SizedBox(
                  width: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// gives graphTile for message AS to AM
  Widget _graphSAMtoCAM(int index) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: (() {
          if (index == tappedMessageIndex) {
            return CustomTheme.darkMode
                ? Color.fromRGBO(105, 125, 133, 1)
                : Color.fromRGBO(210, 210, 210, 1);
          } else {
            return CustomTheme.darkMode
                ? Color.fromRGBO(84, 100, 106, 1)
                : Color.fromRGBO(240, 240, 240, 1);
          }
        }()),
      ),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                height: 150,
                width: 30,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                    right: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                  ),
                ),
              ),
              Container(
                height: 150,
                width: 30,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                    right: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                  ),
                ),
              ),
              Container(
                height: 150,
                width: 30,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                    right: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                  ),
                ),
              ),
              Container(
                height: 150,
                width: 30,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                    right: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 3 / 5 * 1 / 8,
                ),
                SizedBox(
                  width: 16,
                ),
                CustomPaint(
                  size: Size(
                      MediaQuery.of(context).size.width * 3 / 5 * 6 / 8 - 56,
                      100),
                  painter: LongLeftArrow(),
                ),
              ],
            ),
          ),
          Center(
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 3 / 5 * 1 / 8,
                ),
                SizedBox(
                  width: 16,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 3 / 5 * 6 / 8 -
                          40,
                      child: Center(
                        child: Text(
                          "Response code: " +
                              (testProtocolInstances[selectedProtocolInstance]
                                          .messages[index]
                                          .responseCode ==
                                      null
                                  ? " "
                                  : testProtocolInstances[
                                          selectedProtocolInstance]
                                      .messages[index]
                                      .responseCode),
                          style: TextStyle(
                            fontSize: 20,
                            backgroundColor: (() {
                              if (index == tappedMessageIndex) {
                                return CustomTheme.darkMode
                                    ? Color.fromRGBO(105, 125, 133, 1)
                                    : Color.fromRGBO(210, 210, 210, 1);
                              } else {
                                return CustomTheme.darkMode
                                    ? Color.fromRGBO(84, 100, 106, 1)
                                    : Color.fromRGBO(240, 240, 240, 1);
                              }
                            }()),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  index.toString(),
                ),
                SizedBox(
                  width: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// gives graphTile for message AM to C
  Widget _graphCAMtoC(int index) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: (() {
          if (index == tappedMessageIndex) {
            return CustomTheme.darkMode
                ? Color.fromRGBO(105, 125, 133, 1)
                : Color.fromRGBO(210, 210, 210, 1);
          } else {
            return CustomTheme.darkMode
                ? Color.fromRGBO(84, 100, 106, 1)
                : Color.fromRGBO(240, 240, 240, 1);
          }
        }()),
      ),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                height: 150,
                width: 30,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                    right: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                  ),
                ),
              ),
              Container(
                height: 150,
                width: 30,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                    right: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                  ),
                ),
              ),
              Container(
                height: 150,
                width: 30,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                    right: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                  ),
                ),
              ),
              Container(
                height: 150,
                width: 30,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                    right: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 3 / 5 * 1 / 8 - 3,
                ),
                SizedBox(
                  width: 16,
                ),
                CustomPaint(
                  size: Size(
                      MediaQuery.of(context).size.width * 3 / 5 * 2 / 8 - 40,
                      100),
                  painter: ShortRightArrow(),
                ),
              ],
            ),
          ),
          Center(
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 3 / 5 * 1 / 8,
                ),
                SizedBox(
                  width: 16,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 3 / 5 * 2 / 8 -
                          35,
                      child: Center(
                        child: Text(
                          "Response code: " +
                              (testProtocolInstances[selectedProtocolInstance]
                                          .messages[index]
                                          .responseCode ==
                                      null
                                  ? " "
                                  : testProtocolInstances[
                                          selectedProtocolInstance]
                                      .messages[index]
                                      .responseCode),
                          style: TextStyle(
                            fontSize: 20,
                            backgroundColor: (() {
                              if (index == tappedMessageIndex) {
                                return CustomTheme.darkMode
                                    ? Color.fromRGBO(105, 125, 133, 1)
                                    : Color.fromRGBO(210, 210, 210, 1);
                              } else {
                                return CustomTheme.darkMode
                                    ? Color.fromRGBO(84, 100, 106, 1)
                                    : Color.fromRGBO(240, 240, 240, 1);
                              }
                            }()),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  index.toString(),
                ),
                SizedBox(
                  width: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///
  ///
  /// Here starts everything with the _bottomPanel
  ///
  ///

  /// gives the bottomPanel
  Widget _bottomPanel() {
    return SlidingUpPanelWidget(
      enableOnTap: false, //Enable the onTap callback for control bar.
      child: Container(
        width: MediaQuery.of(context).size.width * 3 / 5 - 30,
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        decoration: ShapeDecoration(
          color: CustomTheme.darkMode
              ? Color.fromRGBO(49, 63, 73, 1)
              : Color.fromRGBO(86, 122, 130, 1),
          shadows: [
            BoxShadow(
              blurRadius: 5.0,
              spreadRadius: 2,
              color: const Color(0x11000000),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
          ),
        ),
        child: Column(
          children: <Widget>[
            InkWell(
              hoverColor: Color(0x00000000),
              onTap: () {
                if (SlidingUpPanelStatus.collapsed ==
                    _bottomPanelController.status) {
                  _bottomPanelController.anchor();

                  _changeBottomContainerHeight(true);
                } else {
                  _bottomPanelController.collapse();

                  _changeBottomContainerHeight(false);
                }
              },
              child: Container(
                alignment: Alignment.center,
                height: 50.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        if (SlidingUpPanelStatus.expanded ==
                            _bottomPanelController.status) {
                          _bottomPanelController.anchor();

                          _changeBottomContainerHeight(true);
                        } else {
                          _bottomPanelController.expand();

                          _changeBottomContainerHeight(false);
                        }
                      },
                      color: CustomTheme.darkMode ? Colors.white : Colors.black,
                      icon: Icon(
                        SlidingUpPanelStatus.expanded ==
                                _bottomPanelController.status
                            ? Icons.close_fullscreen
                            : Icons.open_in_full,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (SlidingUpPanelStatus.collapsed ==
                            _bottomPanelController.status) {
                          _bottomPanelController.anchor();

                          _changeBottomContainerHeight(true);
                        } else {
                          _bottomPanelController.collapse();

                          _changeBottomContainerHeight(false);
                        }
                      },
                      color: CustomTheme.darkMode ? Colors.white : Colors.black,
                      icon: Icon(
                        SlidingUpPanelStatus.collapsed ==
                                _bottomPanelController.status
                            ? Icons.expand_less
                            : Icons.remove,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: AnimatedContainer(
                height: _isAnchored
                    ? MediaQuery.of(context).size.height * 0.35
                    : MediaQuery.of(context).size.height,
                child: _messageTile(context),
                color: CustomTheme.darkMode
                    ? Color.fromRGBO(57, 68, 72, 1)
                    : Color.fromRGBO(188, 188, 188, 1),
                duration: Duration(milliseconds: 200),
              ),
            ),
          ],
          mainAxisSize: MainAxisSize.min,
        ),
      ),
      controlHeight: 50.0,
      anchor: 0.4,

      panelController: _bottomPanelController,
      onTap: () {
        if (SlidingUpPanelStatus.anchored == _bottomPanelController.status) {
          _bottomPanelController.collapse();
        } else {
          _bottomPanelController.anchor();
        }
      },
      dragDown: (details) {
        print('dragDown');
      },
      dragStart: (details) {
        print('dragStart');
      },
      dragCancel: () {
        print('dragCancel');
      },
      dragUpdate: (details) {
        print(
            'dragUpdate,${_bottomPanelController.status == SlidingUpPanelStatus.dragging ? 'dragging' : ''}');
      },
      dragEnd: (details) {
        print('dragEnd');
      },
    );
  }

  /// gives list with messageTiles
  _messageTile(BuildContext context) {
    return Scrollbar(
      isAlwaysShown: true,
      thickness: 10,
      showTrackOnHover: true,
      controller: scrollControllerBottomPanel,
      child: AnimatedList(
        key: messageListKey,
        controller: scrollControllerBottomPanel,
        initialItemCount:
            testProtocolInstances[selectedProtocolInstance].messages.length,
        itemBuilder: (context, index, animation) {
          return AutoScrollTag(
            key: ValueKey(index),
            controller: scrollControllerBottomPanel,
            index: index,
            child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-1, 0),
                  end: Offset(0, 0),
                ).animate(animation),
                child: (() {
                  if (testProtocolInstances[selectedProtocolInstance]
                      .messages[index] is MessageCtoCAM) {
                    print("MessageCtoCAM");
                    return _messageCtoCAM(index);
                  } else if (testProtocolInstances[selectedProtocolInstance]
                      .messages[index] is MessageCAMtoSAM) {
                    print("MessageCAMtoSAM");
                    return _messageCAMtoSAM(index);
                  } else if (testProtocolInstances[selectedProtocolInstance]
                      .messages[index] is MessageSAMtoCAM) {
                    print("MessageSAMtoCAM");
                    return _messageSAMtoCAM(index);
                  } else if (testProtocolInstances[selectedProtocolInstance]
                      .messages[index] is MessageCAMtoC) {
                    print("MessageCAMtoC");
                    return _messageCAMtoC(index);
                  } else {
                    print("null message in bottomPanel");
                    return null;
                  }
                }())),
          );
        },
      ),
    );
  }

  /// gives tile with message C to AM
  _messageCtoCAM(int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 20, 10),
      child: InkWell(
        hoverColor: Color(0x00000000),
        splashFactory: NoSplash.splashFactory,
        onTap: () {
          _changeTappedMessageIndex(index);
          _scrollToTappedGraphTile(index);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: tappedMessageIndex == index
                ? Border.all(
                    color: Theme.of(context).accentColor,
                    width: 2,
                  )
                : null,
            color: CustomTheme.darkMode
                ? Color.fromRGBO(84, 100, 106, 1)
                : Color.fromRGBO(240, 240, 240, 1),
          ),
          height: 195,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Message C to AM:',
                    ),
                    Text(
                      'Content-Format: ' +
                          (testProtocolInstances[selectedProtocolInstance]
                                      .messages[index]
                                      .payloadType ==
                                  null
                              ? " "
                              : testProtocolInstances[selectedProtocolInstance]
                                  .messages[index]
                                  .payloadType),
                    ),
                    Text(
                      'Method: ' +
                          (testProtocolInstances[selectedProtocolInstance]
                                      .messages[index]
                                      .method ==
                                  null
                              ? " "
                              : testProtocolInstances[selectedProtocolInstance]
                                  .messages[index]
                                  .method),
                    ),
                    Text(
                      'URI: ' +
                          (testProtocolInstances[selectedProtocolInstance]
                                      .messages[index]
                                      .uri ==
                                  null
                              ? " "
                              : testProtocolInstances[selectedProtocolInstance]
                                  .messages[index]
                                  .uri),
                    ),
                    Text('Payload: {'),
                    Text(
                      '       1: ' +
                          (testProtocolInstances[selectedProtocolInstance]
                                      .messages[index]
                                      .payloadCtoCAM
                                      .number1 ==
                                  null
                              ? " "
                              : testProtocolInstances[selectedProtocolInstance]
                                  .messages[index]
                                  .payloadCtoCAM
                                  .number1),
                    ),
                    Text(
                      '       5: ' +
                          (testProtocolInstances[selectedProtocolInstance]
                                      .messages[index]
                                      .payloadCtoCAM
                                      .number5 ==
                                  null
                              ? " "
                              : testProtocolInstances[selectedProtocolInstance]
                                  .messages[index]
                                  .payloadCtoCAM
                                  .number5),
                    ),
                    Text(
                      '       9: ' +
                          (testProtocolInstances[selectedProtocolInstance]
                                      .messages[index]
                                      .payloadCtoCAM
                                      .number9 ==
                                  null
                              ? " "
                              : testProtocolInstances[selectedProtocolInstance]
                                  .messages[index]
                                  .payloadCtoCAM
                                  .number9),
                    ),
                    Text('}'),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      index.toString(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// gives tile with message AM to AS
  _messageCAMtoSAM(int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 20, 10),
      child: InkWell(
        hoverColor: Color(0x00000000),
        splashFactory: NoSplash.splashFactory,
        onTap: () {
          _changeTappedMessageIndex(index);
          _scrollToTappedGraphTile(index);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: tappedMessageIndex == index
                ? Border.all(
                    color: Theme.of(context).accentColor,
                    width: 2,
                  )
                : null,
            color: CustomTheme.darkMode
                ? Color.fromRGBO(84, 100, 106, 1)
                : Color.fromRGBO(240, 240, 240, 1),
          ),
          height: 195,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Message AM to AS:',
                    ),
                    Text(
                      'Content-Format: ' +
                          (testProtocolInstances[selectedProtocolInstance]
                                      .messages[index]
                                      .payloadType ==
                                  null
                              ? " "
                              : testProtocolInstances[selectedProtocolInstance]
                                  .messages[index]
                                  .payloadType),
                    ),
                    Text(
                      'Method: ' +
                          (testProtocolInstances[selectedProtocolInstance]
                                      .messages[index]
                                      .method ==
                                  null
                              ? " "
                              : testProtocolInstances[selectedProtocolInstance]
                                  .messages[index]
                                  .method),
                    ),
                    Text(
                      'URI: ' +
                          (testProtocolInstances[selectedProtocolInstance]
                                      .messages[index]
                                      .uri ==
                                  null
                              ? " "
                              : testProtocolInstances[selectedProtocolInstance]
                                  .messages[index]
                                  .uri),
                    ),
                    Text('Payload: {'),
                    Text(
                      '       1: ' +
                          (testProtocolInstances[selectedProtocolInstance]
                                      .messages[index]
                                      .payloadCtoCAM
                                      .number1 ==
                                  null
                              ? " "
                              : testProtocolInstances[selectedProtocolInstance]
                                  .messages[index]
                                  .payloadCtoCAM
                                  .number1),
                    ),
                    Text(
                      '       5: ' +
                          (testProtocolInstances[selectedProtocolInstance]
                                      .messages[index]
                                      .payloadCtoCAM
                                      .number5 ==
                                  null
                              ? " "
                              : testProtocolInstances[selectedProtocolInstance]
                                  .messages[index]
                                  .payloadCtoCAM
                                  .number5),
                    ),
                    Text(
                      '       9: ' +
                          (testProtocolInstances[selectedProtocolInstance]
                                      .messages[index]
                                      .payloadCtoCAM
                                      .number9 ==
                                  null
                              ? " "
                              : testProtocolInstances[selectedProtocolInstance]
                                  .messages[index]
                                  .payloadCtoCAM
                                  .number9),
                    ),
                    Text('}'),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      index.toString(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// gives tile with message AS to AM
  _messageSAMtoCAM(int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 20, 10),
      child: InkWell(
        hoverColor: Color(0x00000000),
        splashFactory: NoSplash.splashFactory,
        onTap: () {
          _changeTappedMessageIndex(index);
          _scrollToTappedGraphTile(index);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: tappedMessageIndex == index
                ? Border.all(
                    color: Theme.of(context).accentColor,
                    width: 2,
                  )
                : null,
            color: CustomTheme.darkMode
                ? Color.fromRGBO(84, 100, 106, 1)
                : Color.fromRGBO(240, 240, 240, 1),
          ),
          height: 235,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Message AS to AM:',
                    ),
                    Text(
                      'Response code: ' +
                          (testProtocolInstances[selectedProtocolInstance]
                                      .messages[index]
                                      .responseCode ==
                                  null
                              ? " "
                              : testProtocolInstances[selectedProtocolInstance]
                                  .messages[index]
                                  .responseCode),
                    ),
                    Text(
                      'Content-Format: ' +
                          (testProtocolInstances[selectedProtocolInstance]
                                      .messages[index]
                                      .payloadType ==
                                  null
                              ? " "
                              : testProtocolInstances[selectedProtocolInstance]
                                  .messages[index]
                                  .payloadType),
                    ),
                    Text('Payload: {'),
                    Text(
                      '       3: ' +
                          (testProtocolInstances[selectedProtocolInstance]
                                      .messages[index]
                                      .payloadSAMtoCAM
                                      .number3 ==
                                  null
                              ? " "
                              : testProtocolInstances[selectedProtocolInstance]
                                  .messages[index]
                                  .payloadSAMtoCAM
                                  .number3),
                    ),
                    Text(
                      '       6: ' +
                          (testProtocolInstances[selectedProtocolInstance]
                                      .messages[index]
                                      .payloadSAMtoCAM
                                      .number6 ==
                                  null
                              ? " "
                              : testProtocolInstances[selectedProtocolInstance]
                                  .messages[index]
                                  .payloadSAMtoCAM
                                  .number6),
                    ),
                    Text(
                      '       7: ' +
                          (testProtocolInstances[selectedProtocolInstance]
                                      .messages[index]
                                      .payloadSAMtoCAM
                                      .number7 ==
                                  null
                              ? " "
                              : testProtocolInstances[selectedProtocolInstance]
                                  .messages[index]
                                  .payloadSAMtoCAM
                                  .number7),
                    ),
                    Text(
                      '       8: ' +
                          (testProtocolInstances[selectedProtocolInstance]
                                      .messages[index]
                                      .payloadSAMtoCAM
                                      .number8 ==
                                  null
                              ? " "
                              : testProtocolInstances[selectedProtocolInstance]
                                  .messages[index]
                                  .payloadSAMtoCAM
                                  .number8),
                    ),
                    Text(
                      '       9: ' +
                          (testProtocolInstances[selectedProtocolInstance]
                                      .messages[index]
                                      .payloadSAMtoCAM
                                      .number9 ==
                                  null
                              ? " "
                              : testProtocolInstances[selectedProtocolInstance]
                                  .messages[index]
                                  .payloadSAMtoCAM
                                  .number9),
                    ),
                    Text(
                      '       17: ' +
                          (testProtocolInstances[selectedProtocolInstance]
                                      .messages[index]
                                      .payloadSAMtoCAM
                                      .number17 ==
                                  null
                              ? " "
                              : testProtocolInstances[selectedProtocolInstance]
                                  .messages[index]
                                  .payloadSAMtoCAM
                                  .number17),
                    ),
                    Text('}'),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      index.toString(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// gives tile with message AM to C
  _messageCAMtoC(int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 20, 10),
      child: InkWell(
        hoverColor: Color(0x00000000),
        splashFactory: NoSplash.splashFactory,
        onTap: () {
          _changeTappedMessageIndex(index);
          _scrollToTappedGraphTile(index);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: tappedMessageIndex == index
                ? Border.all(
                    color: Theme.of(context).accentColor,
                    width: 2,
                  )
                : null,
            color: CustomTheme.darkMode
                ? Color.fromRGBO(84, 100, 106, 1)
                : Color.fromRGBO(240, 240, 240, 1),
          ),
          height: 235,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Message AM to C:',
                    ),
                    Text(
                      'Response code: ' +
                          (testProtocolInstances[selectedProtocolInstance]
                                      .messages[index]
                                      .responseCode ==
                                  null
                              ? " "
                              : testProtocolInstances[selectedProtocolInstance]
                                  .messages[index]
                                  .responseCode),
                    ),
                    Text(
                      'Content-Format: ' +
                          (testProtocolInstances[selectedProtocolInstance]
                                      .messages[index]
                                      .payloadType ==
                                  null
                              ? " "
                              : testProtocolInstances[selectedProtocolInstance]
                                  .messages[index]
                                  .payloadType),
                    ),
                    Text('Payload: {'),
                    Text(
                      '       3: ' +
                          (testProtocolInstances[selectedProtocolInstance]
                                      .messages[index]
                                      .payloadSAMtoCAM
                                      .number3 ==
                                  null
                              ? " "
                              : testProtocolInstances[selectedProtocolInstance]
                                  .messages[index]
                                  .payloadSAMtoCAM
                                  .number3),
                    ),
                    Text(
                      '       6: ' +
                          (testProtocolInstances[selectedProtocolInstance]
                                      .messages[index]
                                      .payloadSAMtoCAM
                                      .number6 ==
                                  null
                              ? " "
                              : testProtocolInstances[selectedProtocolInstance]
                                  .messages[index]
                                  .payloadSAMtoCAM
                                  .number6),
                    ),
                    Text(
                      '       7: ' +
                          (testProtocolInstances[selectedProtocolInstance]
                                      .messages[index]
                                      .payloadSAMtoCAM
                                      .number7 ==
                                  null
                              ? " "
                              : testProtocolInstances[selectedProtocolInstance]
                                  .messages[index]
                                  .payloadSAMtoCAM
                                  .number7),
                    ),
                    Text(
                      '       8: ' +
                          (testProtocolInstances[selectedProtocolInstance]
                                      .messages[index]
                                      .payloadSAMtoCAM
                                      .number8 ==
                                  null
                              ? " "
                              : testProtocolInstances[selectedProtocolInstance]
                                  .messages[index]
                                  .payloadSAMtoCAM
                                  .number8),
                    ),
                    Text(
                      '       9: ' +
                          (testProtocolInstances[selectedProtocolInstance]
                                      .messages[index]
                                      .payloadSAMtoCAM
                                      .number9 ==
                                  null
                              ? " "
                              : testProtocolInstances[selectedProtocolInstance]
                                  .messages[index]
                                  .payloadSAMtoCAM
                                  .number9),
                    ),
                    Text(
                      '       17: ' +
                          (testProtocolInstances[selectedProtocolInstance]
                                      .messages[index]
                                      .payloadSAMtoCAM
                                      .number17 ==
                                  null
                              ? " "
                              : testProtocolInstances[selectedProtocolInstance]
                                  .messages[index]
                                  .payloadSAMtoCAM
                                  .number17),
                    ),
                    Text('}'),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      index.toString(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
