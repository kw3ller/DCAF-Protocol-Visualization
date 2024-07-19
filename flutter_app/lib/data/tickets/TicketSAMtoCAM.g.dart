// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TicketSAMtoCAM.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketSAMtoCAM _$TicketSAMtoCAMFromJson(Map<String, dynamic> json) {
  return TicketSAMtoCAM(
    json['payloadSAMtoCAM'] == null
        ? null
        : PayloadSAMtoCAM.fromJson(
            json['payloadSAMtoCAM'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$TicketSAMtoCAMToJson(TicketSAMtoCAM instance) =>
    <String, dynamic>{
      'payloadSAMtoCAM': instance.payloadSAMtoCAM?.toJson(),
    };
