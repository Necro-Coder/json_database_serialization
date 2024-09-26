library json_database_serialization;

import 'dart:io';

import 'package:json_database_serialization/src/content/database/parameters.dart';
import 'package:reflectable/mirrors.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';
import 'package:sqflite_simple_dao_backend/database/params/append.dart';

export 'src/json_database_serialization.dart';
export 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';

Future<void> init(
    {List<Type> databaseModels = const []}) async {

  Append.dbParameters(param: 'tables', value: databaseModels);
  Parameters();
  if (databaseModels.isNotEmpty) {

    for (var model in databaseModels) {
      ClassMirror classMirror =
          reflector.reflectType(model) as ClassMirror;
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
