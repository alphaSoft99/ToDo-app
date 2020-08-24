import 'dart:io';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:path_provider/path_provider.dart' as paths;
import 'package:path/path.dart' as p;

import '../database.dart';

Database constructDb({bool logStatements = false}) {
  //TODO check other platforms
  if (Platform.isIOS || Platform.isAndroid) {
    final executor = LazyDatabase(() async {
      final dataDir = await paths.getApplicationDocumentsDirectory();
      final dbFile = File(p.join(dataDir.path, 'db.sqlite'));
      return FlutterQueryExecutor.inDatabaseFolder(path: "db.sqlite", logStatements: logStatements);
    });
    return Database(executor);
  }
  /*if (Platform.isMacOS || Platform.isLinux) {
    final file = File('db.sqlite');
    return Database(VmDatabase(file, logStatements: logStatements));
  }*/
  // if (Platform.isWindows) {
  //   final file = File('db.sqlite');
  //   return Database(VMDatabase(file, logStatements: logStatements));
  // }
  return Database(VmDatabase.memory(logStatements: logStatements));
}
