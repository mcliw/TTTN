

import 'package:smart_home/data/remote/handler/api_handler.dart';

class ModuleApi {
  final ApiHandler moduleApiHandler;
  final ApiHandler apiHandler;

  ModuleApi({
    required this.moduleApiHandler,
    required this.apiHandler,
  });

  // Future<Map<String, dynamic>> getShortDeviceInfo() async {
  //   final resp = await moduleApiHandler.get(
  //     '/device_info',
  //   );
  //   return resp;
  // }

  // Future<List<dynamic>> getNearbyWiFi() async {
  //   final resp = await moduleApiHandler.get('/nearby_wifi');
  //   return resp;
  // }

  // Future<void> connectWifi(String ssid, String password, String ownerId) {
  //   return moduleApiHandler.get(
  //     '/connect',
  //     queryParameters: {
  //       'ssid': ssid,
  //       'pass': password,
  //       'owner': ownerId,
  //     },
  //   );
  // }

  // Future<List<dynamic>> getModules() async {
  //   final resp = await apiHandler.get(
  //     '/module/modules',
  //   );
  //   return resp;
  // }

  // Future<Map<String, dynamic>> moduleDetail(String moduleId) async {
  //   final resp = await apiHandler.get(
  //     '/module/$moduleId',
  //   );
  //   return resp;
  // }

  // Future<Map<String, dynamic>> updateNameNode(
  //     Map<String, dynamic> params) async {
  //   final resp = await apiHandler.put('/module/node/rename', body: params);
  //   return resp;
  // }

  // Future<List<dynamic>> getHisConnection(
  //     String? moduleId, Map<String, dynamic> params) async {
  //   final resp = await apiHandler
  //       .get('/module/$moduleId/state/history', queryParameters: params);
  //   return resp;
  // }
}
