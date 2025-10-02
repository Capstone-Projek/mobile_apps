import 'dart:developer';

import 'package:mobile_apps/core/service/api/api_service.dart';
import 'package:mobile_apps/presentation/static/auth/user/my_workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == MyWorkmanager.periodic.taskName) {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString("MY_REFRESH_TOKEN");

      if (refreshToken != null) {
        final api = ApiService();
        try {
          final newAccessToken = await api.refreshToken(refreshToken);
          if (newAccessToken != null) {
            await prefs.setString("MY_ACCESS_TOKEN", newAccessToken);
            log("Access Token berhasil diperbarui");
          } else {
            log("Access Token gagal diperbarui");
          }
        } catch (e) {
          log("Access Token gagal diperbarui karena $e");
        }
      }
    }

    return Future.value(true);
  });
}

class WorkmanagerService {
  final Workmanager _workmanager;

  WorkmanagerService([Workmanager? workmanager])
    : _workmanager = workmanager ??= Workmanager();

  Future<void> init() async {
    await _workmanager.initialize(callbackDispatcher, isInDebugMode: true);
  }

  Future<void> runPeriodicTask() async {
    await _workmanager.registerPeriodicTask(
      MyWorkmanager.periodic.uniqueName,
      MyWorkmanager.periodic.taskName,
      frequency: const Duration(minutes: 15),
      initialDelay: Duration.zero,
      constraints: Constraints(networkType: NetworkType.connected,),
    );
  }

  Future<void> cancelAllTask() async {
    await _workmanager.cancelAll();
  }
}
