import 'package:annotations/annotations.dart';

part 'generated/person.generators.dart';

@generateSubclass
class Person {
  String _name = 'Fedor';
  int _age = 20;
}
