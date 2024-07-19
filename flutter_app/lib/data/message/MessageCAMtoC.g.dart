// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MessageCAMtoC.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageCAMtoC _$MessageCAMtoCFromJson(Map<String, dynamic> json) {
  return MessageCAMtoC(
    json['payloadSAMtoCAM'] == null
        ? null
        : PayloadSAMtoCAM.fromJson(
            json['payloadSAMtoCAM'] as Map<String, dynamic>),
    json['payloadType'] as String,
    json['responseCode'] as String,
  );
}

Map<String, dynamic> _$MessageCAMtoCToJson(MessageCAMtoC instance) =>
    <String, dynamic>{
      'payloadSAMtoCAM': instance.payloadSAMtoCAM?.toJson(),
      'payloadType': instance.payloadType,
      'responseCode': instance.responseCode,
    };
