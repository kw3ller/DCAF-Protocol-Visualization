import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/testData/testData.dart';
import 'package:flutter_app/widgets/informationPanel.dart';
import 'package:flutter_app/stuff/themes.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter_app/data/tickets/TicketSAMtoCAM.dart';
import 'package:flutter_app/data/tickets/TicketCAMtoC.dart';

/// to show which tiles are expanded (0 = tickets, 1 = RulesSAMC, 2 = RulesCAMC)
List<int> expandedTiles = [1, 1, 1];

/// to show how many tiles are expanded (for height adjustment)
int numberOfExpandedTiles = 3;

/// ScrollController for scrolling through tickets
AutoScrollController scrollControllerTicket = AutoScrollController();

/// ScrollController for scrolling through Rules from AS for C
AutoScrollController scrollControllerRulesSAMC = AutoScrollController();

/// ScrollController for scrolling through Rules from AM for C
AutoScrollController scrollControllerRulesCAMC = AutoScrollController();

/// key for inserting into ticketList
GlobalKey<AnimatedListState> ticketListKey = GlobalKey<AnimatedListState>();

/// key for inserting into RulesList AS for C
GlobalKey<AnimatedListState> rulesSAMCListKey = GlobalKey<AnimatedListState>();

/// key for inserting into RulesList AM for C
GlobalKey<AnimatedListState> rulesCAMCListKey = GlobalKey<AnimatedListState>();

/// the ticketAndRules tab of informationPanel.dart
class TicketsAndRules extends StatefulWidget {
  @override
  _TicketsAndRulesState createState() => _TicketsAndRulesState();
}

class _TicketsAndRulesState extends State<TicketsAndRules> {
  /// is used to store the string of method of selected rule
  String _tappedRule = "";

  /// gets called when a specific rule gets clicked
  void _changeTappedRule(String method) {
    setState(() {
      _tappedRule == method ? _tappedRule = "" : _tappedRule = method;
    });
  }

  /// scroll to _tappedRule in rules from AS for C
  void _scrollToRuleSAMC(String method) {
    int index = testProtocolInstances[selectedProtocolInstance]
        .rulesCAMC
        .methods
        .indexOf(method);
    if (index >= 0) {
      scrollControllerRulesSAMC.scrollToIndex(index,
          preferPosition: AutoScrollPosition.begin);
    }
  }

  /// scroll to _tappedRule in rules from AM for C
  void _scrollToRuleCAMC(String method) {
    int index = testProtocolInstances[selectedProtocolInstance]
        .rulesSAMC
        .methods
        .indexOf(method);
    if (index >= 0) {
      scrollControllerRulesCAMC.scrollToIndex(index,
          preferPosition: AutoScrollPosition.begin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ticketExpansionTile(),
        SizedBox(
          height: 8,
        ),
        _rulesSAMCExpansionTile(),
        SizedBox(
          height: 8,
        ),
        _rulesCAMCExpansionTile(),
      ],
    );
  }

  ///
  ///
  /// tickets of selectedProtocolInstance
  ///
  ///

  /// expansionTile which shows all the tickets of selectedProtocolInstance
  Widget _ticketExpansionTile() {
    return ExpansionTileCard(
      onExpansionChanged: (isOpen) {
        if (isOpen) {
          expandedTiles[0] = 1;
        } else {
          expandedTiles[0] = 0;
        }
        setState(() {
          numberOfExpandedTiles = expandedTiles.reduce((a, b) => a + b);
        });
      },
      initiallyExpanded: expandedTiles[0] == 1,
      baseColor: CustomTheme.darkMode
          ? Color.fromRGBO(105, 125, 133, 1)
          : Color.fromRGBO(210, 210, 210, 1),
      expandedColor: CustomTheme.darkMode
          ? Color.fromRGBO(105, 125, 133, 1)
          : Color.fromRGBO(210, 210, 210, 1),
      title: Text(
        "Tickets",
        style: Theme.of(context).textTheme.bodyText1,
      ),
      subtitle: Text(
        'exchangedTickets'.tr().toString(),
        style: Theme.of(context).textTheme.bodyText2,
      ),
      children: <Widget>[
        Divider(
          thickness: 1,
          height: 1,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: AnimatedContainer(
              height: _giveHeightOfExpansionTile(0),
              duration: const Duration(milliseconds: 300),
              child: Scrollbar(
                isAlwaysShown: true,
                thickness: 10,
                showTrackOnHover: true,
                controller: scrollControllerTicket,
                child: AnimatedList(
                  key: ticketListKey,
                  controller: scrollControllerTicket,
                  initialItemCount:
                      testProtocolInstances[selectedProtocolInstance]
                          .tickets
                          .length,
                  itemBuilder: (context, index, animation) {
                    return AutoScrollTag(
                      key: ValueKey(index),
                      controller: scrollControllerTicket,
                      index: index,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(-1, 0),
                          end: Offset(0, 0),
                        ).animate(animation),
                        child: (() {
                          if (testProtocolInstances[selectedProtocolInstance]
                              .tickets[index] is TicketSAMtoCAM) {
                            print("ticket SAM to CAM");
                            return _ticketSAMtoCAM(index);
                          } else if (testProtocolInstances[
                                  selectedProtocolInstance]
                              .tickets[index] is TicketCAMtoC) {
                            print("ticket CAM to C");
                            return _ticketCAMtoC(index);
                          } else {
                            print("null in ticketList");
                            return null;
                          }
                        }()),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// ticket from AS to AM which is used in above expansionTile
  Widget _ticketSAMtoCAM(int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, top: 10),
      child: InkWell(
        hoverColor: Color(0x00000000),
        splashFactory: NoSplash.splashFactory,
        onTap: () {
          /// TODO: onTap jump to message where ticket got exchanged
        },
        child: Container(
          height: 195,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: CustomTheme.darkMode
                ? Color.fromRGBO(84, 100, 106, 1)
                : Color.fromRGBO(240, 240, 240, 1),
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Ticket AS to AM:"),
                Text("{"),
                Text(
                  "       3: " +
                      (testProtocolInstances[selectedProtocolInstance]
                                  .tickets[index]
                                  .payloadSAMtoCAM
                                  .number3 ==
                              null
                          ? " "
                          : testProtocolInstances[selectedProtocolInstance]
                              .tickets[index]
                              .payloadSAMtoCAM
                              .number3),
                ),
                Text(
                  "       6: " +
                      (testProtocolInstances[selectedProtocolInstance]
                                  .tickets[index]
                                  .payloadSAMtoCAM
                                  .number6 ==
                              null
                          ? " "
                          : testProtocolInstances[selectedProtocolInstance]
                              .tickets[index]
                              .payloadSAMtoCAM
                              .number6),
                ),
                Text(
                  "       7: " +
                      (testProtocolInstances[selectedProtocolInstance]
                                  .tickets[index]
                                  .payloadSAMtoCAM
                                  .number7 ==
                              null
                          ? " "
                          : testProtocolInstances[selectedProtocolInstance]
                              .tickets[index]
                              .payloadSAMtoCAM
                              .number7),
                ),
                Text(
                  "       8: " +
                      (testProtocolInstances[selectedProtocolInstance]
                                  .tickets[index]
                                  .payloadSAMtoCAM
                                  .number8 ==
                              null
                          ? " "
                          : testProtocolInstances[selectedProtocolInstance]
                              .tickets[index]
                              .payloadSAMtoCAM
                              .number8),
                ),
                Text(
                  "       9: " +
                      (testProtocolInstances[selectedProtocolInstance]
                                  .tickets[index]
                                  .payloadSAMtoCAM
                                  .number9 ==
                              null
                          ? " "
                          : testProtocolInstances[selectedProtocolInstance]
                              .tickets[index]
                              .payloadSAMtoCAM
                              .number9),
                ),
                Text(
                  "       17: " +
                      (testProtocolInstances[selectedProtocolInstance]
                                  .tickets[index]
                                  .payloadSAMtoCAM
                                  .number17 ==
                              null
                          ? " "
                          : testProtocolInstances[selectedProtocolInstance]
                              .tickets[index]
                              .payloadSAMtoCAM
                              .number17),
                ),
                Text("}"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ticket from AM to C which is used in above expansionTile
  Widget _ticketCAMtoC(int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, top: 10),
      child: InkWell(
        hoverColor: Color(0x00000000),
        splashFactory: NoSplash.splashFactory,
        onTap: () {
          /// TODO: onTap jump to message where ticket got exchanged
        },
        child: Container(
          height: 195,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: CustomTheme.darkMode
                ? Color.fromRGBO(84, 100, 106, 1)
                : Color.fromRGBO(240, 240, 240, 1),
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Ticket AM to C:"),
                Text("{"),
                Text(
                  "       3: " +
                      (testProtocolInstances[selectedProtocolInstance]
                                  .tickets[index]
                                  .payloadSAMtoCAM
                                  .number3 ==
                              null
                          ? " "
                          : testProtocolInstances[selectedProtocolInstance]
                              .tickets[index]
                              .payloadSAMtoCAM
                              .number3),
                ),
                Text(
                  "       6: " +
                      (testProtocolInstances[selectedProtocolInstance]
                                  .tickets[index]
                                  .payloadSAMtoCAM
                                  .number6 ==
                              null
                          ? " "
                          : testProtocolInstances[selectedProtocolInstance]
                              .tickets[index]
                              .payloadSAMtoCAM
                              .number6),
                ),
                Text(
                  "       7: " +
                      (testProtocolInstances[selectedProtocolInstance]
                                  .tickets[index]
                                  .payloadSAMtoCAM
                                  .number7 ==
                              null
                          ? " "
                          : testProtocolInstances[selectedProtocolInstance]
                              .tickets[index]
                              .payloadSAMtoCAM
                              .number7),
                ),
                Text(
                  "       8: " +
                      (testProtocolInstances[selectedProtocolInstance]
                                  .tickets[index]
                                  .payloadSAMtoCAM
                                  .number8 ==
                              null
                          ? " "
                          : testProtocolInstances[selectedProtocolInstance]
                              .tickets[index]
                              .payloadSAMtoCAM
                              .number8),
                ),
                Text(
                  "       9: " +
                      (testProtocolInstances[selectedProtocolInstance]
                                  .tickets[index]
                                  .payloadSAMtoCAM
                                  .number9 ==
                              null
                          ? " "
                          : testProtocolInstances[selectedProtocolInstance]
                              .tickets[index]
                              .payloadSAMtoCAM
                              .number9),
                ),
                Text(
                  "       17: " +
                      (testProtocolInstances[selectedProtocolInstance]
                                  .tickets[index]
                                  .payloadSAMtoCAM
                                  .number17 ==
                              null
                          ? " "
                          : testProtocolInstances[selectedProtocolInstance]
                              .tickets[index]
                              .payloadSAMtoCAM
                              .number17),
                ),
                Text("}"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  ///
  /// rules from AS for C
  ///
  ///

  /// expansionTile which shows all the rules of selectedProtocolInstance form AS for C
  Widget _rulesSAMCExpansionTile() {
    return ExpansionTileCard(
      initiallyExpanded: expandedTiles[1] == 1,
      onExpansionChanged: (isOpen) {
        if (isOpen) {
          expandedTiles[1] = 1;
        } else {
          expandedTiles[1] = 0;
        }
        setState(() {
          numberOfExpandedTiles = expandedTiles.reduce((a, b) => a + b);
        });
      },
      baseColor: CustomTheme.darkMode
          ? Color.fromRGBO(105, 125, 133, 1)
          : Color.fromRGBO(210, 210, 210, 1),
      expandedColor: CustomTheme.darkMode
          ? Color.fromRGBO(105, 125, 133, 1)
          : Color.fromRGBO(210, 210, 210, 1),
      title: Text(
        "rulesFromSAMforC".tr().toString(),
        style: Theme.of(context).textTheme.bodyText1,
      ),
      subtitle: Text(
        "rulesFromSAMforC1".tr().toString(),
        style: Theme.of(context).textTheme.bodyText2,
      ),
      children: <Widget>[
        Divider(
          thickness: 1,
          height: 1,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: AnimatedContainer(
              height: _giveHeightOfExpansionTile(1),
              duration: const Duration(milliseconds: 300),
              child: Scrollbar(
                isAlwaysShown: true,
                thickness: 10,
                showTrackOnHover: true,
                controller: scrollControllerRulesSAMC,
                child: AnimatedList(
                  key: rulesSAMCListKey,
                  controller: scrollControllerRulesSAMC,
                  initialItemCount:
                      testProtocolInstances[selectedProtocolInstance]
                          .rulesSAMC
                          .methods
                          .length,
                  itemBuilder: (context, index, animation) {
                    return AutoScrollTag(
                      key: ValueKey(index),
                      controller: scrollControllerRulesSAMC,
                      index: index,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(-1, 0),
                          end: Offset(0, 0),
                        ).animate(animation),
                        child: _ruleSAMC(index),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// rule form AS for C which is used in above expansionTile
  Widget _ruleSAMC(int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, top: 10),
      child: InkWell(
        hoverColor: Color(0x00000000),
        splashFactory: NoSplash.splashFactory,
        onTap: () {
          _changeTappedRule(testProtocolInstances[selectedProtocolInstance]
              .rulesSAMC
              .methods[index]);
          _scrollToRuleCAMC(testProtocolInstances[selectedProtocolInstance]
              .rulesSAMC
              .methods[index]);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: _tappedRule ==
                    testProtocolInstances[selectedProtocolInstance]
                        .rulesSAMC
                        .methods[index]
                ? Border.all(
                    color: Theme.of(context).accentColor,
                    width: 2,
                  )
                : null,
            color: CustomTheme.darkMode
                ? Color.fromRGBO(84, 100, 106, 1)
                : Color.fromRGBO(240, 240, 240, 1),
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  testProtocolInstances[selectedProtocolInstance]
                      .rulesSAMC
                      .methods[index],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 8, bottom: 5),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: testProtocolInstances[selectedProtocolInstance]
                        .rulesSAMC
                        .resources[index]
                        .length,
                    itemBuilder: (context, index2) {
                      return Text(
                        testProtocolInstances[selectedProtocolInstance]
                            .rulesSAMC
                            .resources[index][index2],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  ///
  /// rules from AM for C
  ///
  ///

  /// expansionTile which shows all the rules of selectedProtocolInstance form AM for C
  Widget _rulesCAMCExpansionTile() {
    return ExpansionTileCard(
      initiallyExpanded: expandedTiles[2] == 1,
      onExpansionChanged: (isOpen) {
        if (isOpen) {
          expandedTiles[2] = 1;
        } else {
          expandedTiles[2] = 0;
        }
        setState(() {
          numberOfExpandedTiles = expandedTiles.reduce((a, b) => a + b);
        });
      },
      baseColor: CustomTheme.darkMode
          ? Color.fromRGBO(105, 125, 133, 1)
          : Color.fromRGBO(210, 210, 210, 1),
      expandedColor: CustomTheme.darkMode
          ? Color.fromRGBO(105, 125, 133, 1)
          : Color.fromRGBO(210, 210, 210, 1),
      title: Text(
        "rulesFromCAMforC".tr().toString(),
        style: Theme.of(context).textTheme.bodyText1,
      ),
      subtitle: Text(
        "rulesFromCAMforC1".tr().toString(),
        style: Theme.of(context).textTheme.bodyText2,
      ),
      children: <Widget>[
        Divider(
          thickness: 1,
          height: 1,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: AnimatedContainer(
              height: _giveHeightOfExpansionTile(2),
              duration: const Duration(milliseconds: 300),
              child: Scrollbar(
                isAlwaysShown: true,
                thickness: 10,
                showTrackOnHover: true,
                controller: scrollControllerRulesCAMC,
                child: AnimatedList(
                  key: rulesCAMCListKey,
                  controller: scrollControllerRulesCAMC,
                  initialItemCount:
                      testProtocolInstances[selectedProtocolInstance]
                          .rulesCAMC
                          .methods
                          .length,
                  itemBuilder: (context, index, animation) {
                    return AutoScrollTag(
                      key: ValueKey(index),
                      controller: scrollControllerRulesCAMC,
                      index: index,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(-1, 0),
                          end: Offset(0, 0),
                        ).animate(animation),
                        child: _ruleCAMC(index),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// rule form AM for C which is used in above expansionTile
  Widget _ruleCAMC(int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, top: 10),
      child: InkWell(
        hoverColor: Color(0x00000000),
        splashFactory: NoSplash.splashFactory,
        onTap: () {
          _changeTappedRule(testProtocolInstances[selectedProtocolInstance]
              .rulesCAMC
              .methods[index]);
          _scrollToRuleSAMC(testProtocolInstances[selectedProtocolInstance]
              .rulesCAMC
              .methods[index]);

          /// TODO: onTap jump to message where ticket got exchanged and where other rules is post/get etc...
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: _tappedRule ==
                    testProtocolInstances[selectedProtocolInstance]
                        .rulesCAMC
                        .methods[index]
                ? Border.all(
                    color: Theme.of(context).accentColor,
                    width: 2,
                  )
                : null,
            color: CustomTheme.darkMode
                ? Color.fromRGBO(84, 100, 106, 1)
                : Color.fromRGBO(240, 240, 240, 1),
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  testProtocolInstances[selectedProtocolInstance]
                      .rulesCAMC
                      .methods[index],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 8, bottom: 5),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: testProtocolInstances[selectedProtocolInstance]
                        .rulesCAMC
                        .resources[index]
                        .length,
                    itemBuilder: (context, index2) {
                      return Text(
                        testProtocolInstances[selectedProtocolInstance]
                            .rulesCAMC
                            .resources[index][index2],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// gives height of expansion tiles given how many are expanded to fill tabWindow
  double _giveHeightOfExpansionTile(int expansionTileIndex) {
    if (expandedTiles[expansionTileIndex] == 0 || numberOfExpandedTiles == 3) {
      return MediaQuery.of(context).size.height * 0.175;
    } else if (numberOfExpandedTiles == 2) {
      return MediaQuery.of(context).size.height * 0.275;
    } else {
      return MediaQuery.of(context).size.height * 0.573;
    }
  }
}
