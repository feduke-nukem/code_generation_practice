import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import 'package:annotations/annotations.dart';

import 'model_visitor.dart';

/// GeneratorForAnnotation gets the generic type parameter SubclassAnnotation,
/// which is from the annotations library you created earlier.
///
/// Basically, this is where you map the generator to the
/// corresponding annotation.
class SubclassGenerator extends GeneratorForAnnotation<SubclassAnnotation> {
  /// You override [generateForAnnotatedElement], which takes an [element].
  ///
  /// In this case, that element is a class.
  ///
  /// You don’t need the other parameters in this simple case.
  ///
  /// The returned [String] contains the generated code.
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final visitor = ModelVisitor();

    // Start by visiting the class’s children.
    // Visits all the children of element in no particular order.
    element.visitChildren(visitor);

    // Then, create classname for the generated class.
    // EX: '_$Model' for 'Model'.
    final className = '_\$${visitor.className}';

    // Because you need to work with a lot of Strings,
    // using a StringBuffer is a good option.
    final classBuffer = StringBuffer();

    final fileName = visitor.fileName;

    classBuffer.writeln('import \'$fileName.dart\';');

    // This is the point where you start writing the generated code lines.
    // Create the class that extends the target class.
    classBuffer.writeln('class $className extends ${visitor.className} {');

    // Next, create the variables map that will store all of target
    // class’s variables
    classBuffer.writeln('Map<String, dynamic> variables = {};');

    // Add the constructor of the class.
    classBuffer.writeln('$className() {');

    // Assign the target class’s variables to the map.
    // [field] represents the variable’s name.
    for (final field in visitor.fields.keys) {
      final variable =
          field.startsWith('_') ? field.replaceFirst('_', '') : field;

      classBuffer.writeln('variables[\'$variable\'] = super.$field;');
      // EX: variables['name'] = super._name;
    }
    // End the constructor body.
    classBuffer.writeln('}');

    // Call generateGettersAndSetters — well, to generate the getters
    // and setters of all the variables
    generateGettersAndSetters(visitor, classBuffer);

    // Close the constructor.
    classBuffer.writeln('}');

    // Return the generated code as a single string.
    return classBuffer.toString();
  }

  void generateGettersAndSetters(
    ModelVisitor visitor,
    StringBuffer classBuffer,
  ) {
    // You loop over all variable names.
    for (final field in visitor.fields.keys) {
      // Here, you remove _ from the private variables of the base class.
      final variable =
          field.startsWith('_') ? field.replaceFirst('_', '') : field;

      // This writes the getter code.
      // visitor.fields[field] represents the variable’s datatype.
      // EX: String get name => variables['name'];
      classBuffer.writeln(
        '${visitor.fields[field]} get $variable => variables[\'$variable\'];',
      );

      // This writes the code for the setter.
      classBuffer.writeln(
        'set $variable(${visitor.fields[field]} $variable) {',
      );

      classBuffer.writeln('super.$field = $variable;');
      classBuffer.writeln('variables[\'$variable\'] = $variable;');
      classBuffer.writeln('}');
      // EX: set name(String name) {
      //       super._name = name;
      //       variables['name'] = name;
      //     }
    }
  }
}
