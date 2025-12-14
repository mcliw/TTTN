import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_home/models/user.dart';


part 'app_state.freezed.dart';

@freezed
class AppState with _$AppState {
  factory AppState.checking() = _AppStateChecking;
  factory AppState.unAuthorized() = _AppStateUnAuthorized;
  factory AppState.authorized({required User user}) = _AppStateAuthorized;
}
