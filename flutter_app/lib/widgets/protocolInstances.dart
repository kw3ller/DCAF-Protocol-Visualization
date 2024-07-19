import 'package:flutter/material.dart';
import 'package:flutter_app/data/message/MessageCAMtoC.dart';
import 'package:flutter_app/data/message/MessageCAMtoSAM.dart';
import 'package:flutter_app/data/message/MessageCtoCAM.dart';
import 'package:flutter_app/data/message/MessageSAMtoCAM.dart';
import 'package:flutter_app/stuff/themes.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:flutter_app/widgets/informationPanel.dart';
import 'package:flutter_app/testData/testData.dart';
import 'package:flutter_app/pages/dummy.dart';
import 'dart:async';
import 'package:easy_localization/easy_localization.dart';

/// is used by Login openWebSocketConnection when new message at ProtocolInstance
/// at index zero occurs so setState has to get called so it can be shown
StreamController<bool> streamControllerNewMatZero =
    StreamController<bool>.broadcast();

/// ScrollController for scrolling through protocolInstances
AutoScrollController scrollControllerProtocolInstances = AutoScrollController();

/// key for inserting/ deleting into protocolInstances animatedList
GlobalKey<AnimatedListState> protocolInstancesKey =
    GlobalKey<AnimatedListState>();

/// the protocolInstances tab of informationPanel.dart
class ProtocolInstances extends StatefulWidget {
  ProtocolInstances(this._streamNewMessage);
  final Stream<bool> _streamNewMessage;

  @override
  _ProtocolInstancesState createState() => _ProtocolInstancesState();
}

class _ProtocolInstancesState extends State<ProtocolInstances> {
  /// setState gets called by streamControllerNewMatZero when new message at index 0 occurs
  void _mySetState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget._streamNewMessage.listen((index) {
      _mySetState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      isAlwaysShown: true,
      thickness: 10,
      showTrackOnHover: true,
      controller: scrollControllerProtocolInstances,
      child: Container(
        height: MediaQuery.of(context).size.height - 170,
        child: AnimatedList(
          key: protocolInstancesKey,
          controller: scrollControllerProtocolInstances,
          initialItemCount: testProtocolInstances.length,
          itemBuilder: (context, index, animation) {
            return AutoScrollTag(
              key: ValueKey(index),
              controller: scrollControllerProtocolInstances,
              index: index,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-1, 0),
                  end: Offset(0, 0),
                ).animate(animation),
                child: _protocolInstance(index),
              ),
            );
          },
        ),
      ),
    );
  }

  /// gives one protocolInstance
  Widget _protocolInstance(int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, top: 10),
      child: InkWell(
        hoverColor: Color(0x00000000),
        splashFactory: NoSplash.splashFactory,
        onTap: () {
          setInstanceStreamController.add(index);
        },
        child: (() {
          if (testProtocolInstances[index].messages.isEmpty) {
            return _protocolInstanceEmptyMessage(index);
          } else if (testProtocolInstances[index].messages[0]
              is MessageCtoCAM) {
            return _protocolInstanceMCtoCAM(index);
          } else if (testProtocolInstances[index].messages[0]
              is MessageCAMtoSAM) {
            return _protocolInstanceMCAMtoSAM(index);
          } else if (testProtocolInstances[index].messages[0]
              is MessageSAMtoCAM) {
            return _protocolInstanceMSAMtoCAM(index);
          } else if (testProtocolInstances[index].messages[0]
              is MessageCAMtoC) {
            return _protocolInstanceMCAMtoC(index);
          }
        }()),
      ),
    );
  }

  /// protocolInstance with no message at index 0
  Widget _protocolInstanceEmptyMessage(int index) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: selectedProtocolInstance == index
            ? Border.all(
                color: Theme.of(context).accentColor,
                width: 2,
              )
            : null,
        color: CustomTheme.darkMode
            ? Color.fromRGBO(105, 125, 133, 1)
            : Color.fromRGBO(210, 210, 210, 1),
      ),
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
                  "noFirstMessage".tr().toString(),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  index.toString(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// protocolInstance with no messageCtoAM at index 0
  Widget _protocolInstanceMCtoCAM(int index) {
    return Container(
      height: 195,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: selectedProtocolInstance == index
            ? Border.all(
                color: Theme.of(context).accentColor,
                width: 2,
              )
            : null,
        color: CustomTheme.darkMode
            ? Color.fromRGBO(105, 125, 133, 1)
            : Color.fromRGBO(210, 210, 210, 1),
      ),
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
                  "firstMessageCtoCAM".tr().toString(),
                ),
                Text(
                  'Content-Format: ' +
                      (testProtocolInstances[index].messages[0].payloadType ==
                              null
                          ? " "
                          : testProtocolInstances[index]
                              .messages[0]
                              .payloadType),
                ),
                Text(
                  'Method: ' +
                      (testProtocolInstances[index].messages[0].method == null
                          ? " "
                          : testProtocolInstances[index].messages[0].method),
                ),
                Text(
                  'URI: ' +
                      (testProtocolInstances[index].messages[0].uri == null
                          ? " "
                          : testProtocolInstances[index].messages[0].uri),
                ),
                Text('Payload: {'),
                Text(
                  '       1: ' +
                      (testProtocolInstances[index]
                                  .messages[0]
                                  .payloadCtoCAM
                                  .number1 ==
                              null
                          ? " "
                          : testProtocolInstances[index]
                              .messages[0]
                              .payloadCtoCAM
                              .number1),
                ),
                Text(
                  '       5: ' +
                      (testProtocolInstances[index]
                                  .messages[0]
                                  .payloadCtoCAM
                                  .number5 ==
                              null
                          ? " "
                          : testProtocolInstances[index]
                              .messages[0]
                              .payloadCtoCAM
                              .number5),
                ),
                Text(
                  '       9: ' +
                      (testProtocolInstances[index]
                                  .messages[0]
                                  .payloadCtoCAM
                                  .number9 ==
                              null
                          ? " "
                          : testProtocolInstances[index]
                              .messages[0]
                              .payloadCtoCAM
                              .number9),
                ),
                Text('}'),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  index.toString(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// protocolInstance with no messageAMtoAS at index 0
  Widget _protocolInstanceMCAMtoSAM(int index) {
    return Container(
      height: 195,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: selectedProtocolInstance == index
            ? Border.all(
                color: Theme.of(context).accentColor,
                width: 2,
              )
            : null,
        color: CustomTheme.darkMode
            ? Color.fromRGBO(105, 125, 133, 1)
            : Color.fromRGBO(210, 210, 210, 1),
      ),
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
                  "firstMessageCAMtoSAM".tr().toString(),
                ),
                Text(
                  'Content-Format: ' +
                      (testProtocolInstances[index].messages[0].payloadType ==
                              null
                          ? " "
                          : testProtocolInstances[index]
                              .messages[0]
                              .payloadType),
                ),
                Text(
                  'Method: ' +
                      (testProtocolInstances[index].messages[0].method == null
                          ? " "
                          : testProtocolInstances[index].messages[0].method),
                ),
                Text(
                  'URI: ' +
                      (testProtocolInstances[index].messages[0].uri == null
                          ? " "
                          : testProtocolInstances[index].messages[0].uri),
                ),
                Text('Payload: {'),
                Text(
                  '       1: ' +
                      (testProtocolInstances[index]
                                  .messages[0]
                                  .payloadCtoCAM
                                  .number1 ==
                              null
                          ? " "
                          : testProtocolInstances[index]
                              .messages[0]
                              .payloadCtoCAM
                              .number1),
                ),
                Text(
                  '       5: ' +
                      (testProtocolInstances[index]
                                  .messages[0]
                                  .payloadCtoCAM
                                  .number5 ==
                              null
                          ? " "
                          : testProtocolInstances[index]
                              .messages[0]
                              .payloadCtoCAM
                              .number5),
                ),
                Text(
                  '       9: ' +
                      (testProtocolInstances[index]
                                  .messages[0]
                                  .payloadCtoCAM
                                  .number9 ==
                              null
                          ? " "
                          : testProtocolInstances[index]
                              .messages[0]
                              .payloadCtoCAM
                              .number9),
                ),
                Text('}'),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  index.toString(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// protocolInstance with no messageAStoAM at index 0
  Widget _protocolInstanceMSAMtoCAM(int index) {
    return Container(
      height: 235,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: selectedProtocolInstance == index
            ? Border.all(
                color: Theme.of(context).accentColor,
                width: 2,
              )
            : null,
        color: CustomTheme.darkMode
            ? Color.fromRGBO(105, 125, 133, 1)
            : Color.fromRGBO(210, 210, 210, 1),
      ),
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
                  "firstMessageSAMtoCAM".tr().toString(),
                ),
                Text(
                  'Response code: ' +
                      (testProtocolInstances[index].messages[0].responseCode ==
                              null
                          ? " "
                          : testProtocolInstances[index]
                              .messages[0]
                              .responseCode),
                ),
                Text(
                  'Content-Format: ' +
                      (testProtocolInstances[index].messages[0].payloadType ==
                              null
                          ? " "
                          : testProtocolInstances[index]
                              .messages[0]
                              .payloadType),
                ),
                Text('Payload: {'),
                Text(
                  '       3: ' +
                      (testProtocolInstances[index]
                                  .messages[0]
                                  .payloadSAMtoCAM
                                  .number3 ==
                              null
                          ? " "
                          : testProtocolInstances[index]
                              .messages[0]
                              .payloadSAMtoCAM
                              .number3),
                ),
                Text(
                  '       6: ' +
                      (testProtocolInstances[index]
                                  .messages[0]
                                  .payloadSAMtoCAM
                                  .number6 ==
                              null
                          ? " "
                          : testProtocolInstances[index]
                              .messages[0]
                              .payloadSAMtoCAM
                              .number6),
                ),
                Text(
                  '       7: ' +
                      (testProtocolInstances[index]
                                  .messages[0]
                                  .payloadSAMtoCAM
                                  .number7 ==
                              null
                          ? " "
                          : testProtocolInstances[index]
                              .messages[0]
                              .payloadSAMtoCAM
                              .number7),
                ),
                Text(
                  '       8: ' +
                      (testProtocolInstances[index]
                                  .messages[0]
                                  .payloadSAMtoCAM
                                  .number8 ==
                              null
                          ? " "
                          : testProtocolInstances[index]
                              .messages[0]
                              .payloadSAMtoCAM
                              .number8),
                ),
                Text(
                  '       9: ' +
                      (testProtocolInstances[index]
                                  .messages[0]
                                  .payloadSAMtoCAM
                                  .number9 ==
                              null
                          ? " "
                          : testProtocolInstances[index]
                              .messages[0]
                              .payloadSAMtoCAM
                              .number9),
                ),
                Text(
                  '       17: ' +
                      (testProtocolInstances[index]
                                  .messages[0]
                                  .payloadSAMtoCAM
                                  .number17 ==
                              null
                          ? " "
                          : testProtocolInstances[index]
                              .messages[0]
                              .payloadSAMtoCAM
                              .number17),
                ),
                Text('}'),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  index.toString(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// protocolInstance with no messageAMtoC at index 0
  Widget _protocolInstanceMCAMtoC(int index) {
    return Container(
      height: 235,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: selectedProtocolInstance == index
            ? Border.all(
                color: Theme.of(context).accentColor,
                width: 2,
              )
            : null,
        color: CustomTheme.darkMode
            ? Color.fromRGBO(105, 125, 133, 1)
            : Color.fromRGBO(210, 210, 210, 1),
      ),
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
                  "firstMessageCAMtoC".tr().toString(),
                ),
                Text(
                  'Response code: ' +
                      (testProtocolInstances[index].messages[0].responseCode ==
                              null
                          ? " "
                          : testProtocolInstances[index]
                              .messages[0]
                              .responseCode),
                ),
                Text(
                  'Content-Format: ' +
                      (testProtocolInstances[index].messages[0].payloadType ==
                              null
                          ? " "
                          : testProtocolInstances[index]
                              .messages[0]
                              .payloadType),
                ),
                Text('Payload: {'),
                Text(
                  '       3: ' +
                      (testProtocolInstances[index]
                                  .messages[0]
                                  .payloadSAMtoCAM
                                  .number3 ==
                              null
                          ? " "
                          : testProtocolInstances[index]
                              .messages[0]
                              .payloadSAMtoCAM
                              .number3),
                ),
                Text(
                  '       6: ' +
                      (testProtocolInstances[index]
                                  .messages[0]
                                  .payloadSAMtoCAM
                                  .number6 ==
                              null
                          ? " "
                          : testProtocolInstances[index]
                              .messages[0]
                              .payloadSAMtoCAM
                              .number6),
                ),
                Text(
                  '       7: ' +
                      (testProtocolInstances[index]
                                  .messages[0]
                                  .payloadSAMtoCAM
                                  .number7 ==
                              null
                          ? " "
                          : testProtocolInstances[index]
                              .messages[0]
                              .payloadSAMtoCAM
                              .number7),
                ),
                Text(
                  '       8: ' +
                      (testProtocolInstances[index]
                                  .messages[0]
                                  .payloadSAMtoCAM
                                  .number8 ==
                              null
                          ? " "
                          : testProtocolInstances[index]
                              .messages[0]
                              .payloadSAMtoCAM
                              .number8),
                ),
                Text(
                  '       9: ' +
                      (testProtocolInstances[index]
                                  .messages[0]
                                  .payloadSAMtoCAM
                                  .number9 ==
                              null
                          ? " "
                          : testProtocolInstances[index]
                              .messages[0]
                              .payloadSAMtoCAM
                              .number9),
                ),
                Text(
                  '       17: ' +
                      (testProtocolInstances[index]
                                  .messages[0]
                                  .payloadSAMtoCAM
                                  .number17 ==
                              null
                          ? " "
                          : testProtocolInstances[index]
                              .messages[0]
                              .payloadSAMtoCAM
                              .number17),
                ),
                Text('}'),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  index.toString(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
