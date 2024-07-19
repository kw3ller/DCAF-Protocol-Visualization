// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MessageCAMtoSAM.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageCAMtoSAM _$MessageCAMtoSAMFromJson(Map<String, dynamic> json) {
  return MessageCAMtoSAM(
    json['method'] as String,
    json['payloadType'] as String,
    json['payloadCtoCAM'] == null
        ? null
        : PayloadCtoCAM.fromJson(json['payloadCtoCAM'] as Map<String, dynamic>),
    json['uri'] as String,
  );
}

Map<String, dynamic> _$MessageCAMtoSAMToJson(MessageCAMtoSAM instance) =>
    <String, dynamic>{
      'method': instance.method,
      'payloadType': instance.payloadType,
      'payloadCtoCAM': instance.payloadCtoCAM?.toJson(),
      'uri': instance.uri,
    };
