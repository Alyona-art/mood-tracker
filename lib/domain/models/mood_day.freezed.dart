// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mood_day.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MoodDay _$MoodDayFromJson(Map<String, dynamic> json) {
  return _MoodDay.fromJson(json);
}

/// @nodoc
mixin _$MoodDay {
  @HiveField(0)
  DateTime get date => throw _privateConstructorUsedError;
  @HiveField(1)
  String get audioPath => throw _privateConstructorUsedError;
  @HiveField(2)
  String get text => throw _privateConstructorUsedError;
  @HiveField(3)
  String get emotion => throw _privateConstructorUsedError;
  @HiveField(4)
  int? get energy => throw _privateConstructorUsedError;
  @HiveField(5)
  int? get pleasantness => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MoodDayCopyWith<MoodDay> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MoodDayCopyWith<$Res> {
  factory $MoodDayCopyWith(MoodDay value, $Res Function(MoodDay) then) =
      _$MoodDayCopyWithImpl<$Res, MoodDay>;
  @useResult
  $Res call(
      {@HiveField(0) DateTime date,
      @HiveField(1) String audioPath,
      @HiveField(2) String text,
      @HiveField(3) String emotion,
      @HiveField(4) int? energy,
      @HiveField(5) int? pleasantness});
}

/// @nodoc
class _$MoodDayCopyWithImpl<$Res, $Val extends MoodDay>
    implements $MoodDayCopyWith<$Res> {
  _$MoodDayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? audioPath = null,
    Object? text = null,
    Object? emotion = null,
    Object? energy = freezed,
    Object? pleasantness = freezed,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      audioPath: null == audioPath
          ? _value.audioPath
          : audioPath // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      emotion: null == emotion
          ? _value.emotion
          : emotion // ignore: cast_nullable_to_non_nullable
              as String,
      energy: freezed == energy
          ? _value.energy
          : energy // ignore: cast_nullable_to_non_nullable
              as int?,
      pleasantness: freezed == pleasantness
          ? _value.pleasantness
          : pleasantness // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MoodDayImplCopyWith<$Res> implements $MoodDayCopyWith<$Res> {
  factory _$$MoodDayImplCopyWith(
          _$MoodDayImpl value, $Res Function(_$MoodDayImpl) then) =
      __$$MoodDayImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) DateTime date,
      @HiveField(1) String audioPath,
      @HiveField(2) String text,
      @HiveField(3) String emotion,
      @HiveField(4) int? energy,
      @HiveField(5) int? pleasantness});
}

/// @nodoc
class __$$MoodDayImplCopyWithImpl<$Res>
    extends _$MoodDayCopyWithImpl<$Res, _$MoodDayImpl>
    implements _$$MoodDayImplCopyWith<$Res> {
  __$$MoodDayImplCopyWithImpl(
      _$MoodDayImpl _value, $Res Function(_$MoodDayImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? audioPath = null,
    Object? text = null,
    Object? emotion = null,
    Object? energy = freezed,
    Object? pleasantness = freezed,
  }) {
    return _then(_$MoodDayImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      audioPath: null == audioPath
          ? _value.audioPath
          : audioPath // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      emotion: null == emotion
          ? _value.emotion
          : emotion // ignore: cast_nullable_to_non_nullable
              as String,
      energy: freezed == energy
          ? _value.energy
          : energy // ignore: cast_nullable_to_non_nullable
              as int?,
      pleasantness: freezed == pleasantness
          ? _value.pleasantness
          : pleasantness // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MoodDayImpl implements _MoodDay {
  const _$MoodDayImpl(
      {@HiveField(0) required this.date,
      @HiveField(1) required this.audioPath,
      @HiveField(2) required this.text,
      @HiveField(3) required this.emotion,
      @HiveField(4) this.energy,
      @HiveField(5) this.pleasantness});

  factory _$MoodDayImpl.fromJson(Map<String, dynamic> json) =>
      _$$MoodDayImplFromJson(json);

  @override
  @HiveField(0)
  final DateTime date;
  @override
  @HiveField(1)
  final String audioPath;
  @override
  @HiveField(2)
  final String text;
  @override
  @HiveField(3)
  final String emotion;
  @override
  @HiveField(4)
  final int? energy;
  @override
  @HiveField(5)
  final int? pleasantness;

  @override
  String toString() {
    return 'MoodDay(date: $date, audioPath: $audioPath, text: $text, emotion: $emotion, energy: $energy, pleasantness: $pleasantness)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MoodDayImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.audioPath, audioPath) ||
                other.audioPath == audioPath) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.emotion, emotion) || other.emotion == emotion) &&
            (identical(other.energy, energy) || other.energy == energy) &&
            (identical(other.pleasantness, pleasantness) ||
                other.pleasantness == pleasantness));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, date, audioPath, text, emotion, energy, pleasantness);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MoodDayImplCopyWith<_$MoodDayImpl> get copyWith =>
      __$$MoodDayImplCopyWithImpl<_$MoodDayImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MoodDayImplToJson(
      this,
    );
  }
}

abstract class _MoodDay implements MoodDay {
  const factory _MoodDay(
      {@HiveField(0) required final DateTime date,
      @HiveField(1) required final String audioPath,
      @HiveField(2) required final String text,
      @HiveField(3) required final String emotion,
      @HiveField(4) final int? energy,
      @HiveField(5) final int? pleasantness}) = _$MoodDayImpl;

  factory _MoodDay.fromJson(Map<String, dynamic> json) = _$MoodDayImpl.fromJson;

  @override
  @HiveField(0)
  DateTime get date;
  @override
  @HiveField(1)
  String get audioPath;
  @override
  @HiveField(2)
  String get text;
  @override
  @HiveField(3)
  String get emotion;
  @override
  @HiveField(4)
  int? get energy;
  @override
  @HiveField(5)
  int? get pleasantness;
  @override
  @JsonKey(ignore: true)
  _$$MoodDayImplCopyWith<_$MoodDayImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
