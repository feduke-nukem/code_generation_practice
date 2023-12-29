/// The class is blank because, in this project’s use case, you don’t need any
/// additional data in the annotation.
///
/// The global variable generateSubclass is the name of the annotation.
///
/// You’ll use this name to mark a class for a generator.
///
/// You can create annotations from any class that has a const constructor.
class SubclassAnnotation {
  const SubclassAnnotation();
}

const generateSubclass = SubclassAnnotation();
