import 'package:flutter_app/data/message/MessageCtoCAM.dart';
import 'package:flutter_app/data/message/MessageCAMtoSAM.dart';
import 'package:flutter_app/data/message/MessageSAMtoCAM.dart';
import 'package:flutter_app/data/message/MessageCAMtoC.dart';
import 'package:flutter_app/data/message/PayloadCtoCAM.dart';
import 'package:flutter_app/data/message/PayloadSAMtoCAM.dart';
import 'package:flutter_app/data/tickets/TicketSAMtoCAM.dart';
import 'package:flutter_app/data/tickets/TicketCAMtoC.dart';

/// TODO: This is just for testing and should be deleted later!!!

/// this TestData Was Just for testing purposes and does not hold any valuable information

List testDataList = [mCtoCAM, mCAMtoSAM, mSAMtoCAM, mCAMtoC];

List testTicketList = [ticketSAMtoCAM, ticketCAMtoC];

class Message {}

/// First Message C to its CAM
PayloadCtoCAM payloadCtoCAM1 =
    new PayloadCtoCAM("number1", "number5", "number9");

MessageCtoCAM mCtoCAM =
    new MessageCtoCAM('POST', "payloadType1", payloadCtoCAM1, 'uri1');
MessageCtoCAM mCtoCAM2 =
    new MessageCtoCAM('GET', "payloadType2", payloadCtoCAM1, 'uri2');

/// second Message CAM to SAM

MessageCAMtoSAM mCAMtoSAM =
    new MessageCAMtoSAM('POST', "payloadType1", payloadCtoCAM1, 'uri1');

/// third Message SAM to CAM

PayloadSAMtoCAM payloadSAMtoCAM1 = new PayloadSAMtoCAM(
    "number3", "number6", "number7", "number9", "number8", "number17");

MessageSAMtoCAM mSAMtoCAM =
    new MessageSAMtoCAM(payloadSAMtoCAM1, 'payloadType1', 'responseCode1');

/// fourth Message CAM to C

MessageCAMtoC mCAMtoC =
    new MessageCAMtoC(payloadSAMtoCAM1, 'payloadType1', 'responseCode1');

///
///
/// Here start the tickets
///
///

class Ticket {}

/// ticket for testing SAM to CAM

TicketSAMtoCAM ticketSAMtoCAM = new TicketSAMtoCAM(payloadSAMtoCAM1);

// class TicketSAMtoCAM implements Ticket {
//   String SAI;
//   String TS;
//   String L;
//   String G;
//   String V;
//
//   TicketSAMtoCAM(this.SAI, this.TS, this.L, this.G, this.V);
// }

/// ticket for testing CAM to C

TicketCAMtoC ticketCAMtoC = new TicketCAMtoC(payloadSAMtoCAM1);

TicketCAMtoC ticketCAMtoC2 = new TicketCAMtoC(payloadSAMtoCAM1);

///
///
/// Here start the rules
///
///
///

/// testRules from SAM for C

RulesSAMC testRulesSAMC = new RulesSAMC([
  'POST',
  'GET'
], [
  ["lamp1/turnOn", "lamp1/turnOff"],
  ["temp/outside", "temp/inside", "weather/sunshine", "weather/rain"]
]);

class RulesSAMC {
  List<String> methods;
  List<List<String>> resources;

  RulesSAMC(this.methods, this.resources);
}

/// testRules from CAM for C

RulesCAMC testRulesCAMC = new RulesCAMC([
  'POST',
  'GET'
], [
  [
    "lamp1/turnOn",
    "lamp1/turnOff",
    "temp/regulate",
    "window/open",
    "window/close"
  ],
  ["temp/outside", "temp/inside", "weather/sunshine", "weather/rain"]
]);

class RulesCAMC {
  List<String> methods;
  List<List<String>> resources;

  RulesCAMC(this.methods, this.resources);
}

/// TODO: make a List of "real" instances and test
/// testInstances from DCAF-Protocol

/// just testData for testing with individual instances of the protocol

ProtocolInstance protocolInstance0 =
    new ProtocolInstance([], [], testRulesSAMC, testRulesCAMC);

ProtocolInstance protocolInstance1 = new ProtocolInstance(
    [mCtoCAM, mSAMtoCAM], [ticketSAMtoCAM], testRulesSAMC, testRulesCAMC);

ProtocolInstance protocolInstance2 =
    new ProtocolInstance([], [ticketSAMtoCAM], testRulesSAMC, testRulesCAMC);

ProtocolInstance protocolInstance3 = new ProtocolInstance(
    [mCAMtoSAM, mSAMtoCAM, mCAMtoC, mSAMtoCAM, mCAMtoSAM],
    [ticketSAMtoCAM, ticketCAMtoC, ticketCAMtoC],
    testRulesSAMC,
    testRulesCAMC);

ProtocolInstance protocolInstance5 = new ProtocolInstance(
    [mSAMtoCAM, mCAMtoSAM],
    [ticketSAMtoCAM, ticketCAMtoC, ticketCAMtoC],
    testRulesSAMC,
    testRulesCAMC);

ProtocolInstance protocolInstance6 = new ProtocolInstance(
    [mCAMtoC, mSAMtoCAM, mCAMtoSAM],
    [ticketSAMtoCAM, ticketCAMtoC, ticketCAMtoC],
    testRulesSAMC,
    testRulesCAMC);

ProtocolInstance protocolInstance7 = new ProtocolInstance(
    [mCtoCAM, mCtoCAM, mCAMtoSAM, mSAMtoCAM, mCAMtoC, mSAMtoCAM, mCAMtoSAM],
    [ticketSAMtoCAM, ticketCAMtoC, ticketCAMtoC],
    testRulesSAMC,
    testRulesCAMC);

/// For testing inserting new Instance
ProtocolInstance protocolInstance4 = new ProtocolInstance(
    [mCtoCAM, mCAMtoSAM, mSAMtoCAM, mCAMtoC, mSAMtoCAM, mSAMtoCAM, mSAMtoCAM],
    [ticketSAMtoCAM, ticketCAMtoC, ticketSAMtoCAM],
    testRulesSAMC,
    testRulesCAMC);

// List testProtocolInstances = [
//   protocolInstance0,
//   protocolInstance1,
//   protocolInstance2,
//   protocolInstance3,
//   protocolInstance5,
//   protocolInstance6,
//   protocolInstance7
// ];

/// is the list of protocolInstances that gets used -> only number 0 should be in it
List testProtocolInstances = [
  protocolInstance0,
  // protocolInstance1,
  // protocolInstance2,
  // protocolInstance3,
  // protocolInstance5,
  // protocolInstance6
];

class ProtocolInstance {
  List<Message> messages;

  List<Ticket> tickets;

  RulesSAMC rulesSAMC;
  RulesCAMC rulesCAMC;

  ProtocolInstance(this.messages, this.tickets, this.rulesSAMC, this.rulesCAMC);

  void addNewMessage(Message newMessage) {
    this.messages.add(newMessage);
  }

  void addNewTicket(Ticket newTicket) {
    tickets.add(newTicket);
  }

  addNewRuleSAMC(String newMethod, List<String> newResources) {
    this.rulesSAMC.methods.add(newMethod);
    this.rulesSAMC.resources.add(newResources);
  }

  addNewRuleCAMC(String newMethod, List<String> newResources) {
    this.rulesCAMC.methods.add(newMethod);
    this.rulesCAMC.resources.add(newResources);
  }
}
