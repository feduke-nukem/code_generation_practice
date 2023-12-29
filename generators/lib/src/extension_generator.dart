import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import 'package:annotations/annotations.dart';

import 'model_visitor.dart';

class ExtensionGenerator extends GeneratorForAnnotation<ExtensionAnnotation> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final visitor = ModelVisitor();

    element.visitChildren(visitor);

    final classBuffer = StringBuffer();

    // EX: extension GeneratedModel on Model {
    classBuffer.writeln('extension GeneratedModel on ${visitor.className} {');

    classBuffer.writeln('Map<String, dynamic> get variables => {');

    for (final field in visitor.fields.keys) {
      final variable =
          field.startsWith('_') ? field.replaceFirst('_', '') : field;

      // EX: 'name': _name,
      classBuffer.writeln("'$variable': $field,");
    }

    classBuffer.writeln('};');

    generateGettersAndSetters(visitor, classBuffer);

    classBuffer.writeln('}');

    return classBuffer.toString();
  }

  void generateGettersAndSetters(
    ModelVisitor visitor,
    StringBuffer classBuffer,
  ) {
    for (final field in visitor.fields.keys) {
      final variable =
          field.startsWith('_') ? field.replaceFirst('_', '') : field;

      // EX: String get name => variables['name'];
      classBuffer.writeln(
        "${visitor.fields[field]} get $variable => variables['$variable];",
      );

      // EX: set name(String name) => _name = name;
      classBuffer.writeln('set $variable(${visitor.fields[field]} $variable)');
      classBuffer.writeln('=> $field = $variable;');
    }
  }
}
