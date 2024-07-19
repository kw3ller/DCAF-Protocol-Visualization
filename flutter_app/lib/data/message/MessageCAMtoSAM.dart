import 'package:flutter_app/data/message/PayloadCtoCAM.dart';
import 'package:flutter_app/testData/testData.dart';
import 'package:json_annotation/json_annotation.dart';
part 'MessageCAMtoSAM.g.dart';

/// generates code with jsonSerializable package to represent message
@JsonSerializable(explicitToJson: true)
class MessageCAMtoSAM implements Message {
  String method;
  String payloadType;
  PayloadCtoCAM payloadCtoCAM;
  String uri;

  MessageCAMtoSAM(this.method, this.payloadType, this.payloadCtoCAM, this.uri);

  factory MessageCAMtoSAM.fromJson(Map<String, dynamic> data) =>
      _$MessageCAMtoSAMFromJson(data);

  Map<String, dynamic> toJson() => _$MessageCAMtoSAMToJson(this);
}
