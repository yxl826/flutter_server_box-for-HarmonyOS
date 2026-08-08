import 'dart:async';

import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/services.dart';
import 'package:server_box/core/utils/server.dart';
import 'package:server_box/data/model/server/server_private_info.dart';
import 'package:server_box/data/res/build_data.dart';
import 'package:server_box/data/res/store.dart';
import 'package:server_box/data/ssh/persistent_shell.dart';

/// Headless core service, driven by the ArkUI (HarmonyOS) frontend.
///
/// The ArkUI layer renders every UI and talks to this service through the
/// `serverbox/core` [MethodChannel]. All persistence (Hive) and SSH logic
/// lives in Flutter.
abstract final class ServerBoxCore {
  static const channel = MethodChannel('serverbox/core');

  static final Map<String, PersistentShell> _shells = {};

  static void register() {
    channel.setMethodCallHandler((call) async {
      try {
        return await _handle(call);
      } catch (e, s) {
        Loggers.app.warning('ServerBoxCore error', e, s);
        return {'ok': false, 'error': e.toString()};
      }
    });
  }

  static Future<Object?> _handle(MethodCall call) async {
    switch (call.method) {
      case 'ping':
        return {
          'ok': true,
          'engine': 'flutter',
          'app': BuildData.name,
          'build': BuildData.build,
        };
      case 'getServers':
        final servers = Stores.server
            .fetch()
            .map((e) => e.toJson())
            .toList();
        return {'ok': true, 'servers': servers};
      case 'saveServer':
        final map = Map<String, dynamic>.from(call.arguments as Map);
        final spi = Spi.fromJson(map);
        Stores.server.put(spi);
        return {'ok': true, 'server': spi.toJson()};
      case 'deleteServer':
        final id = call.arguments as String;
        await _shells.remove(id)?.close();
        Stores.server.delete(id);
        return {'ok': true};
      case 'sshRun':
        final args = Map<String, dynamic>.from(call.arguments as Map);
        final id = args['id'] as String;
        final command = args['command'] as String;
        final timeoutMs = args['timeoutMs'] as int?;
        final shell = await _getShell(id);
        final result = await shell.run(
          command,
          timeout: timeoutMs == null ? null : Duration(milliseconds: timeoutMs),
        );
        return {'ok': true, 'output': result.output, 'exitCode': result.exitCode};
      case 'sshDisconnect':
        final id = call.arguments as String;
        await _shells.remove(id)?.close();
        return {'ok': true};
      default:
        throw UnsupportedError('Unknown method: ${call.method}');
    }
  }

  static Future<PersistentShell> _getShell(String id) async {
    final cached = _shells[id];
    if (cached != null) return cached;

    final spi = Stores.server.get<Spi>(id);
    if (spi == null) {
      throw Exception('Server not found: $id');
    }

    final client = await genClient(
      spi,
      // Headless mode: auto-accept the host key.
      onHostKeyPrompt: (info) async => true,
    );
    await client.authenticated;

    final shell = PersistentShell(client);
    _shells[id] = shell;
    return shell;
  }
}
