import 'dart:io';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:path_provider/path_provider.dart' as paths;
import 'package:path/path.dart' as p;

import 'database.dart';

Database constructDb({bool logStatements = false}) {
  if (Platform.isIOS || Platform.isAndroid) {
    final executor = LazyDatabase(() async {
      return FlutterQueryExecutor.inDatabaseFolder(path: "db.sqlite", logStatements: logStatements);
    });
    return Database(executor);
  }
  return Database(VmDatabase.memory(logStatements: logStatements));
}
