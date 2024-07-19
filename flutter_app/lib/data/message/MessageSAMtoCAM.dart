import 'package:flutter_app/testData/testData.dart';
import 'package:json_annotation/json_annotation.dart';
import 'PayloadSAMtoCAM.dart';

part 'MessageSAMtoCAM.g.dart';

/// generates code with jsonSerializable package to represent message
@JsonSerializable(explicitToJson: true)
class MessageSAMtoCAM implements Message {
  PayloadSAMtoCAM payloadSAMtoCAM;
  String payloadType;
  String responseCode;

  MessageSAMtoCAM(this.payloadSAMtoCAM, this.payloadType, this.responseCode);

  factory MessageSAMtoCAM.fromJson(Map<String, dynamic> data) =>
      _$MessageSAMtoCAMFromJson(data);

  Map<String, dynamic> toJson() => _$MessageSAMtoCAMToJson(this);
}
