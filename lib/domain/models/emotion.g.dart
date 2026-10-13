// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emotion.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmotionAdapter extends TypeAdapter<Emotion> {
  @override
  final int typeId = 1;

  @override
  Emotion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Emotion(
      id: fields[0] as String,
      colorValue: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Emotion obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.colorValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmotionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EmotionImpl _$$EmotionImplFromJson(Map<String, dynamic> json) =>
    _$EmotionImpl(
      id: json['id'] as String,
      colorValue: (json['colorValue'] as num).toInt(),
    );

Map<String, dynamic> _$$EmotionImplToJson(_$EmotionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'colorValue': instance.colorValue,
    };
