import 'package:flutter_app/testData/testData.dart';
import 'package:json_annotation/json_annotation.dart';
part 'PayloadSAMtoCAM.g.dart';

/// generates code with jsonSerializable package to represent payload
@JsonSerializable()
class PayloadSAMtoCAM implements Message {
  String number3;
  String number6;
  String number7;
  String number8;
  String number9;
  String number17;

  PayloadSAMtoCAM(this.number3, this.number6, this.number7, this.number9,
      this.number8, this.number17);

  factory PayloadSAMtoCAM.fromJson(Map<String, dynamic> data) =>
      _$PayloadSAMtoCAMFromJson(data);

  Map<String, dynamic> toJson() => _$PayloadSAMtoCAMToJson(this);
}
