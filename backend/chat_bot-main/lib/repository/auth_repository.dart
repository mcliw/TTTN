import 'package:smart_home/data/local/app_provider.dart';
import 'package:smart_home/data/remote/auth_api.dart';
import 'package:smart_home/models/user.dart';

class AuthRepository {
  final AuthApi authApi;
  final AppProvider appProvider;

  AuthRepository(this.authApi, this.appProvider);

  Future<User> register(Map<String, dynamic> params) async {
    final response = await authApi.register(params);
    return User.fromJson(response['user']);
  }

  bool get hasAccessToken => appProvider.hasAccessToken;

  String? get refreshToken => appProvider.refreshToken;

  Future<void> updateToken(Map<String, dynamic> response) async {
    await appProvider.setAccessToken(response['access_token']);
    await appProvider.setRefreshToken(response['refresh_token']);
  }

  // Future<User> authToken() async {
  //   // final resp = await authApi.authToken(refreshToken!);
  //   // await updateToken(resp);
  //   // return User.fromJson(resp['user']);
  // }

  Future<void> logout() async {
    await appProvider.setAccessToken(null);
    await appProvider.setRefreshToken(null);
  }
}
