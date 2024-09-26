import 'package:json_database_serialization/src/errors_control/database_exception.dart';
import 'package:reflectable/reflectable.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';
import 'package:sqflite_simple_dao_backend/database/database/sql_builder.dart';
import 'package:sqflite_simple_dao_backend/database/params/constants.dart';

import '../content.dart';

@reflector
class BaseDao extends ModelDao with SerializableModel {
  BaseDao();

  BaseDao.all();

  BaseDao.db() {
    _checkProperties();
  }

  int? id;

  DateTime? createdAt;
  DateTime? updatedAt;

  final Map<String, String> fields = {};

  final List<String> names = [];

  final List<String> primary = [];
  final List<String> exception = [];

  final List<String> foreign = [];

  List<String> propertiesExceptions = [
    'id', 'createdAt', 'updatedAt',
    'fields', 'names', 'primary', 'foreign', 'exception', 'propertiesExceptions'
  ];

  Future<dynamic> selectAll<O>() async {
    SqlBuilder sqlBuilder =
        SqlBuilder().querySelect().queryFrom(table: getTableName(this));

    return await select<O>(sqlBuilder: sqlBuilder, model: this) as O;
  }

  @override
  Future<int> insert() async {
    try {
      List all = await selectAll();

      id = all.last.id + 1;
    } catch(e) {
      id = 0;
    }
    return super.insert();
  }

  void _checkProperties() {
    Type classType = runtimeType;
    List<String> classFields = getProperties(classType: classType);
    names.addAll(fields.keys);

    for (var field in classFields) {
      _setIgnoredFiles(field);
      _fieldConstruction(field);
      _setPrimaryKeys(field);
    }

    fields.addAll({
      'id': Constants.integer,
      'createdAt': Constants.datetime,
      'updatedAt': Constants.datetime
    });

    primary.add('id');

    classFields.removeWhere(
      (element) => exception.contains(element) ||propertiesExceptions.contains(element),
    );

    for (var field in classFields) {
      if (!fields.containsKey(field)) {
        throw DatabaseException(
            'The field ($field) do not have DataType declared for the model $runtimeType');
      }
    }
  }

  void _setIgnoredFiles(String field) {
    List fieldProperties = _getMetadata(field);

    for (var fieldProperty in fieldProperties) {
      if (fieldProperty is Ignored) {
        if (!exception.contains(field)) {
          exception.add(field);
        }
      }
    }
  }

  void _setPrimaryKeys(String field) {
    List fieldProperties = _getMetadata(field);

    for (var fieldProperty in fieldProperties) {
      if (fieldProperty is Primary) {
        if (!primary.contains(field) && !exception.contains(field)) {
          primary.add(field);
        }
      }
    }
  }

  void _fieldConstruction(String field) {
    List fieldProperties = _getMetadata(field);
    Map<String, String> auxFields = {};
    for (var fieldProperty in fieldProperties) {
      if (!exception.contains(field)) {
        if (fieldProperty is DataType) {
          DataType property = fieldProperty;
          String type = property.type;

          auxFields = {field: _getRealType(type)};
        }

        if (fieldProperty is AutoIncrement) {
          auxFields = {field: Constants.integer};
        }
      }
    }

    if (auxFields.isNotEmpty && !fields.containsKey(auxFields.keys.first)) {
      fields.addAll(auxFields);
    }
  }

  String _getRealType(String type) {
    String lowerType = type.toLowerCase();

    return lowerType.toUpperCase();
  }

  List _getMetadata(String field) {
    if (!propertiesExceptions.contains(field)) {
      ClassMirror classMirror =
          reflector.reflectType(runtimeType) as ClassMirror;
      var fieldMirror = classMirror.declarations[field] as VariableMirror?;
      if (fieldMirror == null) {
        throw DatabaseException(
            'There are no declarations on the model $runtimeType for the field $field');
      }
      return fieldMirror.metadata;
    }

    return [];
  }
}
