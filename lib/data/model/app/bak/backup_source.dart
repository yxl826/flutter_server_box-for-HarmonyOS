import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';

/// Abstract interface for backup content sources
abstract class BackupSource {
  /// Get content from this source for restore
  Future<String?> getContent();

  /// Save content to this source for backup
  Future<void> saveContent(String filePath);

  /// Display name for this source
  String get displayName;

  /// Icon for this source
  IconData get icon;
}

/// File-based backup source
class FileBackupSource implements BackupSource {
  @override
  Future<String?> getContent() async {
    return await Pfs.pickFileString();
  }

  @override
  Future<void> saveContent(String filePath) async {
    await Pfs.sharePaths(paths: [filePath]);
  }

  @override
  String get displayName => libL10n.file;

  @override
  IconData get icon => Icons.file_open;
}
