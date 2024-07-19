import 'package:flutter_app/data/message/PayloadCtoCAM.dart';
import 'package:flutter_app/testData/testData.dart';
import 'package:json_annotation/json_annotation.dart';
part 'MessageCtoCAM.g.dart';

/// generates code with jsonSerializable package to represent message
@JsonSerializable(explicitToJson: true)
class MessageCtoCAM implements Message {
  String method;
  String payloadType;
  PayloadCtoCAM payloadCtoCAM;
  String uri;

  MessageCtoCAM(this.method, this.payloadType, this.payloadCtoCAM, this.uri);

  factory MessageCtoCAM.fromJson(Map<String, dynamic> data) =>
      _$MessageCtoCAMFromJson(data);

  Map<String, dynamic> toJson() => _$MessageCtoCAMToJson(this);
}
