import 'package:flutter/material.dart';
import 'package:flutter_app/stuff/themes.dart';
import 'package:flutter_app/widgets/protocolInstances.dart';
import 'package:flutter_app/widgets/ticketsAndRules.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

/// indicates which protocolInstance is selected to be shown currently
int selectedProtocolInstance = 0;

/// is used to only animate new Item when its tab is actually selected
int activeTabBarIndex = 0;

/// the tab panel on the right of main site with ticketsAndRules and protocolInstances
class RulesAndTicket extends StatefulWidget {
  @override
  _RulesAndTicketState createState() => _RulesAndTicketState();
}

class _RulesAndTicketState extends State<RulesAndTicket> {
  @override
  void initState() {
    super.initState();
    print("rulesAndTicket initialized");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height - 90,
        decoration: BoxDecoration(
          color: CustomTheme.darkMode
              ? Color.fromRGBO(84, 100, 106, 1)
              : Color.fromRGBO(240, 240, 240, 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              DefaultTabController(
                length: 2,
                initialIndex: activeTabBarIndex,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 0.5),
                        ),
                      ),
                      child: TabBar(
                        onTap: (tabbedIndex) {
                          activeTabBarIndex = tabbedIndex;
                          print("tabbar has been tapped index:" +
                              tabbedIndex.toString());
                        },
                        tabs: [
                          Tab(
                            child: Text(
                              'ticketsAndRules'.tr().toString(),
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .color),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'protocolInstances'.tr().toString(),
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .color),
                            ),
                          ),
                        ],
                        indicator: MaterialIndicator(
                          color: CustomTheme.darkTheme.accentColor,
                          height: 5,
                          topLeftRadius: 8,
                          topRightRadius: 8,
                          horizontalPadding: 50,
                          tabPosition: TabPosition.bottom,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height - 170,
                      child: TabBarView(
                        children: <Widget>[
                          SingleChildScrollView(
                            child: TicketsAndRules(),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                ProtocolInstances(
                                  streamControllerNewMatZero.stream,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
