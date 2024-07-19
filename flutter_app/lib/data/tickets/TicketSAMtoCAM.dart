import 'package:flutter_app/data/message/PayloadSAMtoCAM.dart';
import 'package:flutter_app/testData/testData.dart';
import 'package:json_annotation/json_annotation.dart';
part 'TicketSAMtoCAM.g.dart';

/// generates code with jsonSerializable package to represent ticket
@JsonSerializable(explicitToJson: true)
class TicketSAMtoCAM implements Ticket {
  PayloadSAMtoCAM payloadSAMtoCAM;

  TicketSAMtoCAM(this.payloadSAMtoCAM);

  factory TicketSAMtoCAM.fromJson(Map<String, dynamic> data) =>
      _$TicketSAMtoCAMFromJson(data);

  Map<String, dynamic> toJson() => _$TicketSAMtoCAMToJson(this);
}
