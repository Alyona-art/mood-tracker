// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood_day.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MoodDayAdapter extends TypeAdapter<MoodDay> {
  @override
  final int typeId = 0;

  @override
  MoodDay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MoodDay(
      date: fields[0] as DateTime,
      audioPath: fields[1] as String,
      text: fields[2] as String,
      emotion: fields[3] as String,
      energy: fields[4] as int?,
      pleasantness: fields[5] as int?,
      shapeRounding: fields[6] as int?,
      shapeRayDepth: fields[7] as int?,
      shapeTwist: fields[8] as int?,
      shapeVariance: fields[9] as int?,
      adviceSuggestion: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MoodDay obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.audioPath)
      ..writeByte(2)
      ..write(obj.text)
      ..writeByte(3)
      ..write(obj.emotion)
      ..writeByte(4)
      ..write(obj.energy)
      ..writeByte(5)
      ..write(obj.pleasantness)
      ..writeByte(6)
      ..write(obj.shapeRounding)
      ..writeByte(7)
      ..write(obj.shapeRayDepth)
      ..writeByte(8)
      ..write(obj.shapeTwist)
      ..writeByte(9)
      ..write(obj.shapeVariance)
      ..writeByte(11)
      ..write(obj.adviceSuggestion);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoodDayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MoodDayImpl _$$MoodDayImplFromJson(Map<String, dynamic> json) =>
    _$MoodDayImpl(
      date: DateTime.parse(json['date'] as String),
      audioPath: json['audioPath'] as String,
      text: json['text'] as String,
      emotion: json['emotion'] as String,
      energy: (json['energy'] as num?)?.toInt(),
      pleasantness: (json['pleasantness'] as num?)?.toInt(),
      shapeRounding: (json['shapeRounding'] as num?)?.toInt(),
      shapeRayDepth: (json['shapeRayDepth'] as num?)?.toInt(),
      shapeTwist: (json['shapeTwist'] as num?)?.toInt(),
      shapeVariance: (json['shapeVariance'] as num?)?.toInt(),
      adviceSuggestion: json['adviceSuggestion'] as String?,
    );

Map<String, dynamic> _$$MoodDayImplToJson(_$MoodDayImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'audioPath': instance.audioPath,
      'text': instance.text,
      'emotion': instance.emotion,
      'energy': instance.energy,
      'pleasantness': instance.pleasantness,
      'shapeRounding': instance.shapeRounding,
      'shapeRayDepth': instance.shapeRayDepth,
      'shapeTwist': instance.shapeTwist,
      'shapeVariance': instance.shapeVariance,
      'adviceSuggestion': instance.adviceSuggestion,
    };
