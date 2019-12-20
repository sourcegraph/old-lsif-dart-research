import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';

Future<void> main() async {
  var includedPaths = ['/Users/chrismwendt/github.com/sourcegraph/lsif-dart'];
  var collection = AnalysisContextCollection(includedPaths: includedPaths);
  // The files returned this way will include all of the files in all of the
  // directories, including those that are not '.dart' files, except for those
  // files that have explicitly been excluded or that are in directories that
  // have been explicitly excluded. If you're only interested in analyzing .dart
  // files, then you would need to manually filter out other files.
  for (var context in collection.contexts) {
    var session = context.currentSession;
    print(session.declaredVariables);
    var x = await session.getUnitElement('/Users/chrismwendt/github.com/sourcegraph/lsif-dart/lib/lsif_dart.dart');
    x.element.accept(ParameterCounter());
  }
}
class ParameterCounter extends GeneralizingElementVisitor<void> {
  int count = 0;

  @override
  void visitLocalVariableElement(LocalVariableElement element) {
    super.visitLocalVariableElement(element);
    count += element.declaration.location;
    print(count);
  }
}