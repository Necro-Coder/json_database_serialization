import 'dart:convert';

import 'package:reflectable/reflectable.dart';
import '../errors_control/errors_control.dart';
import '../reflectable/class_reflectable.dart';

@reflector
mixin class SerializableModel {
  Future<dynamic> fromJson(Map<String, dynamic> json, Object obj) async {
    ClassMirror classMirror =
        reflector.reflectType(obj.runtimeType) as ClassMirror;

    Map<Symbol, dynamic> namedArguments = {};
    for (var data in json.keys) {
      namedArguments.addAll({Symbol(data): json[data]});
    }

    Object newObject = classMirror.newInstance('all', [], namedArguments);

    return newObject;
  }

  Future<dynamic> fromRawJson(String str, Object obj) async =>
      await fromJson(json.decode(str), obj);

  Map<String, dynamic> toJson<O>() {
    Map<String, dynamic> json = {};
    InstanceMirror instance = reflector.reflect(this);

    List<String> classProperties = getProperties<O>();

    for (var property in classProperties) {
      json.addAll({property: instance.invokeGetter(property)});
    }

    return json;
  }

  List<String> getProperties<O>({Type? classType}) {
    List<String> classProperties = [];
    ClassMirror classMirror;
    if (O == dynamic && classType != null) {
      classMirror = reflector.reflectType(classType) as ClassMirror;
    } else if (O == dynamic && classType == null) {
      throw NullException(
          'Either the type parameter O or classType must be declared.');
    } else {
      classMirror = reflector.reflectType(O) as ClassMirror;
    }

    Map<String, MethodMirror> members = classMirror.instanceMembers;
    for (var member in members.keys) {
      if (members[member]!.isGetter) {
        classProperties.add(member);
      }
    }
    List<String> deleteCodes = ['hashCode', 'runtimeType'];

    classProperties.removeWhere(
      (element) => deleteCodes.contains(element),
    );

    return classProperties;
  }
}
