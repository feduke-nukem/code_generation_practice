import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'src/subclass_generator.dart';

/// source_gen provides some pre-implemented builders that cover common use
/// cases of code generation.
///
/// In this case, you need [SharedPartBuilder], which renders part of files.
///
/// These functions return the Builder for each of the two generators.
///
/// [SharedPartBuilder] takes a list of generators as parameters
/// to generate the code.
///
/// To make each builder unique, you also need to provide an identifier.
///
/// These functions are simple and apt for this use case, but you always have
/// the power to configure the [Builder] more through [BuilderOptions]

Builder generateSubclass(BuilderOptions options) => LibraryBuilder(
      SubclassGenerator(),
      generatedExtension: '.generators.dart',
      options: options,
    );
