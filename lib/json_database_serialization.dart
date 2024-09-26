library json_database_serialization;

import 'dart:io';

import 'package:json_database_serialization/src/content/database/parameters.dart';
import 'package:json_database_serialization/src/json_database_serialization.dart';
import 'package:reflectable/mirrors.dart';

import 'src/helpers/command_executor.dart';

export 'src/json_database_serialization.dart';

Future<void> init(
    {required String fullPath,
    List<Object> databaseModels = const []}) async {
  Parameters();
  _reflectableInitialization(fullPath);
  if (databaseModels.isNotEmpty) {
    for (var model in databaseModels) {
      ClassMirror classMirror =
          reflector.reflectType(model.runtimeType) as ClassMirror;
      classMirror.newInstance('db', []);
    }
  }
}

void _reflectableInitialization(String path) async {
  var directory = Directory.current;

  File file = File('$path/prueba.dart');
  await file.create(recursive: true);

  print(directory);
}
