import 'package:json_database_serialization/src/errors_control/database_exception.dart';
import 'package:reflectable/reflectable.dart';
import 'package:sqflite_simple_dao_backend/database/params/constants.dart';

import '../../reflectable/class_reflectable.dart';
import '../content.dart';

@reflector
class BaseDao extends ModelDao with SerializableModel {
  BaseDao();

  BaseDao.all();

  BaseDao.db() {
    _checkProperties();
  }

  static final Map<String, String> _fields = {};

  static final Iterable<String> _names = _fields.keys;

  static final List<String> _primary = [];
  static final List<String> _exception = [];

  static final List<String> _foreign = [];

  static List<String> get foreign => _foreign;

  static Map<String, String> get fields => _fields;

  static Iterable<String> get names => _names;

  static List<String> get primary => _primary;

  static List<String> get exception => _exception;

  void _checkProperties() {
    Type classType = runtimeType;
    List<String> fields = getProperties(classType: classType);

    for (var field in fields) {
      _setIgnoredFiles(field);
      _fieldConstruction(field);
      _setPrimaryKeys(field);
    }

    fields.removeWhere(
      (element) => _exception.contains(element),
    );

    for (var field in fields) {
      if (!_fields.containsKey(field)) {
        throw DatabaseException(
            'The field ($field) do not have DataType declared for the model $runtimeType');
      }
    }
  }

  void _setIgnoredFiles(String field) {
    List fieldProperties = _getMetadata(field);

    for (var fieldProperty in fieldProperties) {
      if (fieldProperty is Ignored) {
        if (!_exception.contains(field)) {
          _exception.add(field);
        }
      }
    }
  }

  void _setPrimaryKeys(String field) {
    List fieldProperties = _getMetadata(field);

    for (var fieldProperty in fieldProperties) {
      if (fieldProperty is Primary) {
        if (!_primary.contains(field) && !_exception.contains(field)) {
          _primary.add(field);
        }
      }
    }
  }

  void _fieldConstruction(String field) {
    List fieldProperties = _getMetadata(field);
    Map<String, String> auxFields = {};
    for (var fieldProperty in fieldProperties) {
      if (!_exception.contains(field)) {
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

    if (auxFields.isNotEmpty && !_fields.containsKey(auxFields.keys.first)) {
      _fields.addAll(auxFields);
    }
  }

  String _getRealType(String type) {
    String lowerType = type.toLowerCase();

    return lowerType.toUpperCase();
  }

  List _getMetadata(String field) {
    ClassMirror classMirror = reflector.reflectType(runtimeType) as ClassMirror;
    var fieldMirror = classMirror.declarations[field] as VariableMirror?;
    if (fieldMirror == null) {
      throw DatabaseException(
          'There are no declarations on the model $runtimeType');
    }
    return fieldMirror.metadata;
  }
}
