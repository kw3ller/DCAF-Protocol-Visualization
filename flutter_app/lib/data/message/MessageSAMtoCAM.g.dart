// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MessageSAMtoCAM.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageSAMtoCAM _$MessageSAMtoCAMFromJson(Map<String, dynamic> json) {
  return MessageSAMtoCAM(
    json['payloadSAMtoCAM'] == null
        ? null
        : PayloadSAMtoCAM.fromJson(
            json['payloadSAMtoCAM'] as Map<String, dynamic>),
    json['payloadType'] as String,
    json['responseCode'] as String,
  );
}

Map<String, dynamic> _$MessageSAMtoCAMToJson(MessageSAMtoCAM instance) =>
    <String, dynamic>{
      'payloadSAMtoCAM': instance.payloadSAMtoCAM?.toJson(),
      'payloadType': instance.payloadType,
      'responseCode': instance.responseCode,
    };
