import 'dart:io';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/source/line_info.dart';

Future<void> main() async {
  var directory = Directory.current.path;
  print('Processing all .dart files in directory $directory');
  var includedPaths = [directory];
  var collection = AnalysisContextCollection(includedPaths: includedPaths);
  // The files returned this way will include all of the files in all of the
  // directories, including those that are not '.dart' files, except for those
  // files that have explicitly been excluded or that are in directories that
  // have been explicitly excluded. If you're only interested in analyzing .dart
  // files, then you would need to manually filter out other files.
  for (var context in collection.contexts) {
    var session = context.currentSession;
    var exampleFile =
        await session.getUnitElement('$directory/lib/lsif_dart.dart');
    exampleFile.element.accept(ParameterCounter());
  }
}

AstNode toAstNode(Element element) {
  var session = element.session;
  var parsedLib = session.getParsedLibraryByElement(element.library);
  var declaration = parsedLib.getElementDeclaration(element);
  if (declaration != null) {
    return declaration.node;
  } else {
    return null;
  }
}

CharacterLocation toLineCol(Element element, offset) {
  // Use AnalysisContext.getContents instead. RVT cheaps out here because using AnalysisContext.getContents needs context to be passed, which is in main, and RVT doesn't want to deal with classes and states right now.
  // See https://www.crossdart.info/p/analyzer/0.27.4-alpha.4/src/generated/source.dart.html#line-444
  var source = element.source;
  if (source != null) {
    var contents = source.contents.data.toString();
    var lineInfo = LineInfo.fromContent(contents);
    return lineInfo.getLocation(offset);
  }
  return null;
}

class ParameterCounter extends GeneralizingElementVisitor<void> {
  int visitedCount = 0;

  @override
  void visitElement(Element element) {
    print('Visiting: $element');

    // location components of this element object
    var location = element.location.components;
    print('Location: $location');

    // getting the AST node let's us access range information
    var node = toAstNode(element);
    if (node != null) {
      var rangeOffsetStart = node.offset;
      var rangeOffsetEnd = rangeOffsetStart + node.length;
      print('range_offsets: {start: $rangeOffsetStart, end: $rangeOffsetEnd}');

      var rangeLocationStart = toLineCol(element, rangeOffsetStart);
      var rangeLocationEnd = toLineCol(element, rangeOffsetEnd);
      print('range_line_column: {start line: ' +
          rangeLocationStart.lineNumber.toString() +
          ', start column: ' +
          rangeLocationStart.columnNumber.toString() +
          '}, {end line: ' +
          rangeLocationEnd.lineNumber.toString() +
          ', end column: ' +
          rangeLocationEnd.columnNumber.toString() +
          '}');
    }

    // runtime type exists for all kinds of elements
    var runtimeType = element.runtimeType;
    print('Type: $runtimeType');

    visitedCount += 1;
    print(visitedCount);

    super.visitElement(element);
    print('');
  }

  @override
  void visitVariableElement(VariableElement element) {
    super.visitElement(element);
    print('\tVisiting VariableElement: $element');
    // The static DartType exists for VariableElement, and accessed with .type
    // Not all elements have a static .type member.
    var type = element.type;
    print('\tStatic VariableElement Type: $type');
  }
}
