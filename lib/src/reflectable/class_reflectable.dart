import 'package:reflectable/reflectable.dart';

class ClassReflectable extends Reflectable {
  const ClassReflectable()
      : super(
            invokingCapability,
            declarationsCapability,
            newInstanceCapability,
            admitSubtypeCapability,
            correspondingSetterQuantifyCapability,
            declarationsCapability,
            delegateCapability,
            instanceInvokeCapability,
            metadataCapability,
            libraryDependenciesCapability);
}

const reflector = ClassReflectable();
