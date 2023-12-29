import 'package:analyzer/dart/element/visitor.dart';
import 'package:analyzer/dart/element/element.dart';

/// You create the class, [ModelVisitor], that extends [SimpleElementVisitor].
///
/// [SimpleElementVisitor] has most of the methods you need already implemented.
class ModelVisitor extends SimpleElementVisitor<void> {
  /// For this project, you need to access the class name and all the
  /// variable fields, so you add these variables to the class. fields is a map
  /// with the variable’s name as key and its datatype as value.
  ///
  /// You’ll need both to generate getters and setters.
  final fields = <String, dynamic>{};
  String className = '';
  String fileName = '';

  /// You override [visitConstructorElement] to obtain the className
  /// by accessing [ConstructorElement.returnType] of each found constructor.
  @override
  void visitConstructorElement(ConstructorElement element) {
    final returnType = element.returnType.toString();

    // elementReturnType ends with *, which you need to remove for the
    // generated code to be accurate
    className = returnType.replaceFirst('*', '');

    fileName = 'package:' +
        element.source.fullName
            .replaceFirst('/', '')
            .replaceFirst('/lib', '')
            .replaceFirst('.dart', '');
  }

  /// [visitFieldElement] fills fields with the names and datatypes of all the
  /// variables found in the target class
  @override
  void visitFieldElement(FieldElement element) {
    final type = element.type.toString();

    // Again, elementType ends with *, which you remove.
    fields[element.name] = type.replaceFirst('*', '');
  }
}
