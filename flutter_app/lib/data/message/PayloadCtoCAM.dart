import 'package:flutter_app/testData/testData.dart';
import 'package:json_annotation/json_annotation.dart';
part 'PayloadCtoCAM.g.dart';

/// generates code with jsonSerializable package to represent payload
@JsonSerializable()
class PayloadCtoCAM implements Message {
  String number1;
  String number5;
  String number9;

  PayloadCtoCAM(this.number1, this.number5, this.number9);

  factory PayloadCtoCAM.fromJson(Map<String, dynamic> data) =>
      _$PayloadCtoCAMFromJson(data);

  Map<String, dynamic> toJson() => _$PayloadCtoCAMToJson(this);
}
