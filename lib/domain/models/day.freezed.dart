// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'day.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Day {
  DateTime get date => throw _privateConstructorUsedError;
  String? get moodId => throw _privateConstructorUsedError;
  int? get energy => throw _privateConstructorUsedError;
  int? get pleasantness => throw _privateConstructorUsedError;
  int? get shapeRounding => throw _privateConstructorUsedError;
  int? get shapeRayDepth => throw _privateConstructorUsedError;
  int? get shapeTwist => throw _privateConstructorUsedError;
  int? get shapeVariance => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DayCopyWith<Day> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DayCopyWith<$Res> {
  factory $DayCopyWith(Day value, $Res Function(Day) then) =
      _$DayCopyWithImpl<$Res, Day>;
  @useResult
  $Res call(
      {DateTime date,
      String? moodId,
      int? energy,
      int? pleasantness,
      int? shapeRounding,
      int? shapeRayDepth,
      int? shapeTwist,
      int? shapeVariance});
}

/// @nodoc
class _$DayCopyWithImpl<$Res, $Val extends Day> implements $DayCopyWith<$Res> {
  _$DayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? moodId = freezed,
    Object? energy = freezed,
    Object? pleasantness = freezed,
    Object? shapeRounding = freezed,
    Object? shapeRayDepth = freezed,
    Object? shapeTwist = freezed,
    Object? shapeVariance = freezed,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      moodId: freezed == moodId
          ? _value.moodId
          : moodId // ignore: cast_nullable_to_non_nullable
              as String?,
      energy: freezed == energy
          ? _value.energy
          : energy // ignore: cast_nullable_to_non_nullable
              as int?,
      pleasantness: freezed == pleasantness
          ? _value.pleasantness
          : pleasantness // ignore: cast_nullable_to_non_nullable
              as int?,
      shapeRounding: freezed == shapeRounding
          ? _value.shapeRounding
          : shapeRounding // ignore: cast_nullable_to_non_nullable
              as int?,
      shapeRayDepth: freezed == shapeRayDepth
          ? _value.shapeRayDepth
          : shapeRayDepth // ignore: cast_nullable_to_non_nullable
              as int?,
      shapeTwist: freezed == shapeTwist
          ? _value.shapeTwist
          : shapeTwist // ignore: cast_nullable_to_non_nullable
              as int?,
      shapeVariance: freezed == shapeVariance
          ? _value.shapeVariance
          : shapeVariance // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DayImplCopyWith<$Res> implements $DayCopyWith<$Res> {
  factory _$$DayImplCopyWith(_$DayImpl value, $Res Function(_$DayImpl) then) =
      __$$DayImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime date,
      String? moodId,
      int? energy,
      int? pleasantness,
      int? shapeRounding,
      int? shapeRayDepth,
      int? shapeTwist,
      int? shapeVariance});
}

/// @nodoc
class __$$DayImplCopyWithImpl<$Res> extends _$DayCopyWithImpl<$Res, _$DayImpl>
    implements _$$DayImplCopyWith<$Res> {
  __$$DayImplCopyWithImpl(_$DayImpl _value, $Res Function(_$DayImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? moodId = freezed,
    Object? energy = freezed,
    Object? pleasantness = freezed,
    Object? shapeRounding = freezed,
    Object? shapeRayDepth = freezed,
    Object? shapeTwist = freezed,
    Object? shapeVariance = freezed,
  }) {
    return _then(_$DayImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      moodId: freezed == moodId
          ? _value.moodId
          : moodId // ignore: cast_nullable_to_non_nullable
              as String?,
      energy: freezed == energy
          ? _value.energy
          : energy // ignore: cast_nullable_to_non_nullable
              as int?,
      pleasantness: freezed == pleasantness
          ? _value.pleasantness
          : pleasantness // ignore: cast_nullable_to_non_nullable
              as int?,
      shapeRounding: freezed == shapeRounding
          ? _value.shapeRounding
          : shapeRounding // ignore: cast_nullable_to_non_nullable
              as int?,
      shapeRayDepth: freezed == shapeRayDepth
          ? _value.shapeRayDepth
          : shapeRayDepth // ignore: cast_nullable_to_non_nullable
              as int?,
      shapeTwist: freezed == shapeTwist
          ? _value.shapeTwist
          : shapeTwist // ignore: cast_nullable_to_non_nullable
              as int?,
      shapeVariance: freezed == shapeVariance
          ? _value.shapeVariance
          : shapeVariance // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$DayImpl implements _Day {
  const _$DayImpl(
      {required this.date,
      required this.moodId,
      this.energy,
      this.pleasantness,
      this.shapeRounding,
      this.shapeRayDepth,
      this.shapeTwist,
      this.shapeVariance});

  @override
  final DateTime date;
  @override
  final String? moodId;
  @override
  final int? energy;
  @override
  final int? pleasantness;
  @override
  final int? shapeRounding;
  @override
  final int? shapeRayDepth;
  @override
  final int? shapeTwist;
  @override
  final int? shapeVariance;

  @override
  String toString() {
    return 'Day(date: $date, moodId: $moodId, energy: $energy, pleasantness: $pleasantness, shapeRounding: $shapeRounding, shapeRayDepth: $shapeRayDepth, shapeTwist: $shapeTwist, shapeVariance: $shapeVariance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DayImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.moodId, moodId) || other.moodId == moodId) &&
            (identical(other.energy, energy) || other.energy == energy) &&
            (identical(other.pleasantness, pleasantness) ||
                other.pleasantness == pleasantness) &&
            (identical(other.shapeRounding, shapeRounding) ||
                other.shapeRounding == shapeRounding) &&
            (identical(other.shapeRayDepth, shapeRayDepth) ||
                other.shapeRayDepth == shapeRayDepth) &&
            (identical(other.shapeTwist, shapeTwist) ||
                other.shapeTwist == shapeTwist) &&
            (identical(other.shapeVariance, shapeVariance) ||
                other.shapeVariance == shapeVariance));
  }

  @override
  int get hashCode => Object.hash(runtimeType, date, moodId, energy,
      pleasantness, shapeRounding, shapeRayDepth, shapeTwist, shapeVariance);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DayImplCopyWith<_$DayImpl> get copyWith =>
      __$$DayImplCopyWithImpl<_$DayImpl>(this, _$identity);
}

abstract class _Day implements Day {
  const factory _Day(
      {required final DateTime date,
      required final String? moodId,
      final int? energy,
      final int? pleasantness,
      final int? shapeRounding,
      final int? shapeRayDepth,
      final int? shapeTwist,
      final int? shapeVariance}) = _$DayImpl;

  @override
  DateTime get date;
  @override
  String? get moodId;
  @override
  int? get energy;
  @override
  int? get pleasantness;
  @override
  int? get shapeRounding;
  @override
  int? get shapeRayDepth;
  @override
  int? get shapeTwist;
  @override
  int? get shapeVariance;
  @override
  @JsonKey(ignore: true)
  _$$DayImplCopyWith<_$DayImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
