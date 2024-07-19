// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MessageCtoCAM.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageCtoCAM _$MessageCtoCAMFromJson(Map<String, dynamic> json) {
  return MessageCtoCAM(
    json['method'] as String,
    json['payloadType'] as String,
    json['payloadCtoCAM'] == null
        ? null
        : PayloadCtoCAM.fromJson(json['payloadCtoCAM'] as Map<String, dynamic>),
    json['uri'] as String,
  );
}

Map<String, dynamic> _$MessageCtoCAMToJson(MessageCtoCAM instance) =>
    <String, dynamic>{
      'method': instance.method,
      'payloadType': instance.payloadType,
      'payloadCtoCAM': instance.payloadCtoCAM?.toJson(),
      'uri': instance.uri,
    };
