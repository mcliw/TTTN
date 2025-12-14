// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'socket_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SocketState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() connecting,
    required TResult Function() connected,
    required TResult Function() disconnected,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? connecting,
    TResult? Function()? connected,
    TResult? Function()? disconnected,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? connecting,
    TResult Function()? connected,
    TResult Function()? disconnected,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SocketConnectingState value) connecting,
    required TResult Function(_SocketConnectedState value) connected,
    required TResult Function(_SocketDisconnectedState value) disconnected,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SocketConnectingState value)? connecting,
    TResult? Function(_SocketConnectedState value)? connected,
    TResult? Function(_SocketDisconnectedState value)? disconnected,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SocketConnectingState value)? connecting,
    TResult Function(_SocketConnectedState value)? connected,
    TResult Function(_SocketDisconnectedState value)? disconnected,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SocketStateCopyWith<$Res> {
  factory $SocketStateCopyWith(
          SocketState value, $Res Function(SocketState) then) =
      _$SocketStateCopyWithImpl<$Res, SocketState>;
}

/// @nodoc
class _$SocketStateCopyWithImpl<$Res, $Val extends SocketState>
    implements $SocketStateCopyWith<$Res> {
  _$SocketStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SocketState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SocketConnectingStateImplCopyWith<$Res> {
  factory _$$SocketConnectingStateImplCopyWith(
          _$SocketConnectingStateImpl value,
          $Res Function(_$SocketConnectingStateImpl) then) =
      __$$SocketConnectingStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SocketConnectingStateImplCopyWithImpl<$Res>
    extends _$SocketStateCopyWithImpl<$Res, _$SocketConnectingStateImpl>
    implements _$$SocketConnectingStateImplCopyWith<$Res> {
  __$$SocketConnectingStateImplCopyWithImpl(_$SocketConnectingStateImpl _value,
      $Res Function(_$SocketConnectingStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of SocketState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SocketConnectingStateImpl implements _SocketConnectingState {
  _$SocketConnectingStateImpl();

  @override
  String toString() {
    return 'SocketState.connecting()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocketConnectingStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() connecting,
    required TResult Function() connected,
    required TResult Function() disconnected,
  }) {
    return connecting();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? connecting,
    TResult? Function()? connected,
    TResult? Function()? disconnected,
  }) {
    return connecting?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? connecting,
    TResult Function()? connected,
    TResult Function()? disconnected,
    required TResult orElse(),
  }) {
    if (connecting != null) {
      return connecting();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SocketConnectingState value) connecting,
    required TResult Function(_SocketConnectedState value) connected,
    required TResult Function(_SocketDisconnectedState value) disconnected,
  }) {
    return connecting(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SocketConnectingState value)? connecting,
    TResult? Function(_SocketConnectedState value)? connected,
    TResult? Function(_SocketDisconnectedState value)? disconnected,
  }) {
    return connecting?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SocketConnectingState value)? connecting,
    TResult Function(_SocketConnectedState value)? connected,
    TResult Function(_SocketDisconnectedState value)? disconnected,
    required TResult orElse(),
  }) {
    if (connecting != null) {
      return connecting(this);
    }
    return orElse();
  }
}

abstract class _SocketConnectingState implements SocketState {
  factory _SocketConnectingState() = _$SocketConnectingStateImpl;
}

/// @nodoc
abstract class _$$SocketConnectedStateImplCopyWith<$Res> {
  factory _$$SocketConnectedStateImplCopyWith(_$SocketConnectedStateImpl value,
          $Res Function(_$SocketConnectedStateImpl) then) =
      __$$SocketConnectedStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SocketConnectedStateImplCopyWithImpl<$Res>
    extends _$SocketStateCopyWithImpl<$Res, _$SocketConnectedStateImpl>
    implements _$$SocketConnectedStateImplCopyWith<$Res> {
  __$$SocketConnectedStateImplCopyWithImpl(_$SocketConnectedStateImpl _value,
      $Res Function(_$SocketConnectedStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of SocketState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SocketConnectedStateImpl implements _SocketConnectedState {
  _$SocketConnectedStateImpl();

  @override
  String toString() {
    return 'SocketState.connected()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocketConnectedStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() connecting,
    required TResult Function() connected,
    required TResult Function() disconnected,
  }) {
    return connected();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? connecting,
    TResult? Function()? connected,
    TResult? Function()? disconnected,
  }) {
    return connected?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? connecting,
    TResult Function()? connected,
    TResult Function()? disconnected,
    required TResult orElse(),
  }) {
    if (connected != null) {
      return connected();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SocketConnectingState value) connecting,
    required TResult Function(_SocketConnectedState value) connected,
    required TResult Function(_SocketDisconnectedState value) disconnected,
  }) {
    return connected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SocketConnectingState value)? connecting,
    TResult? Function(_SocketConnectedState value)? connected,
    TResult? Function(_SocketDisconnectedState value)? disconnected,
  }) {
    return connected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SocketConnectingState value)? connecting,
    TResult Function(_SocketConnectedState value)? connected,
    TResult Function(_SocketDisconnectedState value)? disconnected,
    required TResult orElse(),
  }) {
    if (connected != null) {
      return connected(this);
    }
    return orElse();
  }
}

abstract class _SocketConnectedState implements SocketState {
  factory _SocketConnectedState() = _$SocketConnectedStateImpl;
}

/// @nodoc
abstract class _$$SocketDisconnectedStateImplCopyWith<$Res> {
  factory _$$SocketDisconnectedStateImplCopyWith(
          _$SocketDisconnectedStateImpl value,
          $Res Function(_$SocketDisconnectedStateImpl) then) =
      __$$SocketDisconnectedStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SocketDisconnectedStateImplCopyWithImpl<$Res>
    extends _$SocketStateCopyWithImpl<$Res, _$SocketDisconnectedStateImpl>
    implements _$$SocketDisconnectedStateImplCopyWith<$Res> {
  __$$SocketDisconnectedStateImplCopyWithImpl(
      _$SocketDisconnectedStateImpl _value,
      $Res Function(_$SocketDisconnectedStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of SocketState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SocketDisconnectedStateImpl implements _SocketDisconnectedState {
  _$SocketDisconnectedStateImpl();

  @override
  String toString() {
    return 'SocketState.disconnected()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocketDisconnectedStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() connecting,
    required TResult Function() connected,
    required TResult Function() disconnected,
  }) {
    return disconnected();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? connecting,
    TResult? Function()? connected,
    TResult? Function()? disconnected,
  }) {
    return disconnected?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? connecting,
    TResult Function()? connected,
    TResult Function()? disconnected,
    required TResult orElse(),
  }) {
    if (disconnected != null) {
      return disconnected();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SocketConnectingState value) connecting,
    required TResult Function(_SocketConnectedState value) connected,
    required TResult Function(_SocketDisconnectedState value) disconnected,
  }) {
    return disconnected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SocketConnectingState value)? connecting,
    TResult? Function(_SocketConnectedState value)? connected,
    TResult? Function(_SocketDisconnectedState value)? disconnected,
  }) {
    return disconnected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SocketConnectingState value)? connecting,
    TResult Function(_SocketConnectedState value)? connected,
    TResult Function(_SocketDisconnectedState value)? disconnected,
    required TResult orElse(),
  }) {
    if (disconnected != null) {
      return disconnected(this);
    }
    return orElse();
  }
}

abstract class _SocketDisconnectedState implements SocketState {
  factory _SocketDisconnectedState() = _$SocketDisconnectedStateImpl;
}
