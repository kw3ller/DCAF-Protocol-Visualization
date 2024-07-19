// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TicketCAMtoC.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketCAMtoC _$TicketCAMtoCFromJson(Map<String, dynamic> json) {
  return TicketCAMtoC(
    json['payloadSAMtoCAM'] == null
        ? null
        : PayloadSAMtoCAM.fromJson(
            json['payloadSAMtoCAM'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$TicketCAMtoCToJson(TicketCAMtoC instance) =>
    <String, dynamic>{
      'payloadSAMtoCAM': instance.payloadSAMtoCAM?.toJson(),
    };
