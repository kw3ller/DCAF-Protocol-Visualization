import 'package:flutter_app/data/message/PayloadSAMtoCAM.dart';
import 'package:flutter_app/testData/testData.dart';
import 'package:json_annotation/json_annotation.dart';
part 'TicketCAMtoC.g.dart';

/// generates code with jsonSerializable package to represent ticket
@JsonSerializable(explicitToJson: true)
class TicketCAMtoC implements Ticket {
  PayloadSAMtoCAM payloadSAMtoCAM;

  TicketCAMtoC(this.payloadSAMtoCAM);

  factory TicketCAMtoC.fromJson(Map<String, dynamic> data) =>
      _$TicketCAMtoCFromJson(data);

  Map<String, dynamic> toJson() => _$TicketCAMtoCToJson(this);
}
