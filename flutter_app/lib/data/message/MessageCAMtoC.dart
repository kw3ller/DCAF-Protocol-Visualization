import 'package:flutter_app/testData/testData.dart';
import 'package:json_annotation/json_annotation.dart';
import 'PayloadSAMtoCAM.dart';

part 'MessageCAMtoC.g.dart';

/// generates code with jsonSerializable package to represent message
@JsonSerializable(explicitToJson: true)
class MessageCAMtoC implements Message {
  PayloadSAMtoCAM payloadSAMtoCAM;
  String payloadType;
  String responseCode;

  MessageCAMtoC(this.payloadSAMtoCAM, this.payloadType, this.responseCode);

  factory MessageCAMtoC.fromJson(Map<String, dynamic> data) =>
      _$MessageCAMtoCFromJson(data);

  Map<String, dynamic> toJson() => _$MessageCAMtoCToJson(this);
}
