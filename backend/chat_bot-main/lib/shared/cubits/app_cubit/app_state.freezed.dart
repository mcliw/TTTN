// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checking,
    required TResult Function() unAuthorized,
    required TResult Function(User user) authorized,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checking,
    TResult? Function()? unAuthorized,
    TResult? Function(User user)? authorized,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checking,
    TResult Function()? unAuthorized,
    TResult Function(User user)? authorized,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_AppStateChecking value) checking,
    required TResult Function(_AppStateUnAuthorized value) unAuthorized,
    required TResult Function(_AppStateAuthorized value) authorized,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_AppStateChecking value)? checking,
    TResult? Function(_AppStateUnAuthorized value)? unAuthorized,
    TResult? Function(_AppStateAuthorized value)? authorized,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_AppStateChecking value)? checking,
    TResult Function(_AppStateUnAuthorized value)? unAuthorized,
    TResult Function(_AppStateAuthorized value)? authorized,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppStateCopyWith<$Res> {
  factory $AppStateCopyWith(AppState value, $Res Function(AppState) then) =
      _$AppStateCopyWithImpl<$Res, AppState>;
}

/// @nodoc
class _$AppStateCopyWithImpl<$Res, $Val extends AppState>
    implements $AppStateCopyWith<$Res> {
  _$AppStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$AppStateCheckingImplCopyWith<$Res> {
  factory _$$AppStateCheckingImplCopyWith(_$AppStateCheckingImpl value,
          $Res Function(_$AppStateCheckingImpl) then) =
      __$$AppStateCheckingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AppStateCheckingImplCopyWithImpl<$Res>
    extends _$AppStateCopyWithImpl<$Res, _$AppStateCheckingImpl>
    implements _$$AppStateCheckingImplCopyWith<$Res> {
  __$$AppStateCheckingImplCopyWithImpl(_$AppStateCheckingImpl _value,
      $Res Function(_$AppStateCheckingImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AppStateCheckingImpl implements _AppStateChecking {
  _$AppStateCheckingImpl();

  @override
  String toString() {
    return 'AppState.checking()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AppStateCheckingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checking,
    required TResult Function() unAuthorized,
    required TResult Function(User user) authorized,
  }) {
    return checking();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checking,
    TResult? Function()? unAuthorized,
    TResult? Function(User user)? authorized,
  }) {
    return checking?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checking,
    TResult Function()? unAuthorized,
    TResult Function(User user)? authorized,
    required TResult orElse(),
  }) {
    if (checking != null) {
      return checking();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_AppStateChecking value) checking,
    required TResult Function(_AppStateUnAuthorized value) unAuthorized,
    required TResult Function(_AppStateAuthorized value) authorized,
  }) {
    return checking(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_AppStateChecking value)? checking,
    TResult? Function(_AppStateUnAuthorized value)? unAuthorized,
    TResult? Function(_AppStateAuthorized value)? authorized,
  }) {
    return checking?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_AppStateChecking value)? checking,
    TResult Function(_AppStateUnAuthorized value)? unAuthorized,
    TResult Function(_AppStateAuthorized value)? authorized,
    required TResult orElse(),
  }) {
    if (checking != null) {
      return checking(this);
    }
    return orElse();
  }
}

abstract class _AppStateChecking implements AppState {
  factory _AppStateChecking() = _$AppStateCheckingImpl;
}

/// @nodoc
abstract class _$$AppStateUnAuthorizedImplCopyWith<$Res> {
  factory _$$AppStateUnAuthorizedImplCopyWith(_$AppStateUnAuthorizedImpl value,
          $Res Function(_$AppStateUnAuthorizedImpl) then) =
      __$$AppStateUnAuthorizedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AppStateUnAuthorizedImplCopyWithImpl<$Res>
    extends _$AppStateCopyWithImpl<$Res, _$AppStateUnAuthorizedImpl>
    implements _$$AppStateUnAuthorizedImplCopyWith<$Res> {
  __$$AppStateUnAuthorizedImplCopyWithImpl(_$AppStateUnAuthorizedImpl _value,
      $Res Function(_$AppStateUnAuthorizedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AppStateUnAuthorizedImpl implements _AppStateUnAuthorized {
  _$AppStateUnAuthorizedImpl();

  @override
  String toString() {
    return 'AppState.unAuthorized()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppStateUnAuthorizedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checking,
    required TResult Function() unAuthorized,
    required TResult Function(User user) authorized,
  }) {
    return unAuthorized();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checking,
    TResult? Function()? unAuthorized,
    TResult? Function(User user)? authorized,
  }) {
    return unAuthorized?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checking,
    TResult Function()? unAuthorized,
    TResult Function(User user)? authorized,
    required TResult orElse(),
  }) {
    if (unAuthorized != null) {
      return unAuthorized();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_AppStateChecking value) checking,
    required TResult Function(_AppStateUnAuthorized value) unAuthorized,
    required TResult Function(_AppStateAuthorized value) authorized,
  }) {
    return unAuthorized(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_AppStateChecking value)? checking,
    TResult? Function(_AppStateUnAuthorized value)? unAuthorized,
    TResult? Function(_AppStateAuthorized value)? authorized,
  }) {
    return unAuthorized?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_AppStateChecking value)? checking,
    TResult Function(_AppStateUnAuthorized value)? unAuthorized,
    TResult Function(_AppStateAuthorized value)? authorized,
    required TResult orElse(),
  }) {
    if (unAuthorized != null) {
      return unAuthorized(this);
    }
    return orElse();
  }
}

abstract class _AppStateUnAuthorized implements AppState {
  factory _AppStateUnAuthorized() = _$AppStateUnAuthorizedImpl;
}

/// @nodoc
abstract class _$$AppStateAuthorizedImplCopyWith<$Res> {
  factory _$$AppStateAuthorizedImplCopyWith(_$AppStateAuthorizedImpl value,
          $Res Function(_$AppStateAuthorizedImpl) then) =
      __$$AppStateAuthorizedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({User user});

  $UserCopyWith<$Res> get user;
}

/// @nodoc
class __$$AppStateAuthorizedImplCopyWithImpl<$Res>
    extends _$AppStateCopyWithImpl<$Res, _$AppStateAuthorizedImpl>
    implements _$$AppStateAuthorizedImplCopyWith<$Res> {
  __$$AppStateAuthorizedImplCopyWithImpl(_$AppStateAuthorizedImpl _value,
      $Res Function(_$AppStateAuthorizedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
  }) {
    return _then(_$AppStateAuthorizedImpl(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
    ));
  }

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get user {
    return $UserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value));
    });
  }
}

/// @nodoc

class _$AppStateAuthorizedImpl implements _AppStateAuthorized {
  _$AppStateAuthorizedImpl({required this.user});

  @override
  final User user;

  @override
  String toString() {
    return 'AppState.authorized(user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppStateAuthorizedImpl &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user);

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppStateAuthorizedImplCopyWith<_$AppStateAuthorizedImpl> get copyWith =>
      __$$AppStateAuthorizedImplCopyWithImpl<_$AppStateAuthorizedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checking,
    required TResult Function() unAuthorized,
    required TResult Function(User user) authorized,
  }) {
    return authorized(user);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checking,
    TResult? Function()? unAuthorized,
    TResult? Function(User user)? authorized,
  }) {
    return authorized?.call(user);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checking,
    TResult Function()? unAuthorized,
    TResult Function(User user)? authorized,
    required TResult orElse(),
  }) {
    if (authorized != null) {
      return authorized(user);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_AppStateChecking value) checking,
    required TResult Function(_AppStateUnAuthorized value) unAuthorized,
    required TResult Function(_AppStateAuthorized value) authorized,
  }) {
    return authorized(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_AppStateChecking value)? checking,
    TResult? Function(_AppStateUnAuthorized value)? unAuthorized,
    TResult? Function(_AppStateAuthorized value)? authorized,
  }) {
    return authorized?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_AppStateChecking value)? checking,
    TResult Function(_AppStateUnAuthorized value)? unAuthorized,
    TResult Function(_AppStateAuthorized value)? authorized,
    required TResult orElse(),
  }) {
    if (authorized != null) {
      return authorized(this);
    }
    return orElse();
  }
}

abstract class _AppStateAuthorized implements AppState {
  factory _AppStateAuthorized({required final User user}) =
      _$AppStateAuthorizedImpl;

  User get user;

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppStateAuthorizedImplCopyWith<_$AppStateAuthorizedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
