library hop_runner;

import 'dart:async';
import 'dart:io';
import 'package:bot/bot.dart';
import 'package:hop/hop.dart';
import 'package:hop/hop_tasks.dart';
import '../test/harness_console.dart' as test_console;

import 'tasks/dartdoc_postbuild.dart' as dartdoc;

void main() {
  // Easy to enable hop-wide logging
  // enableScriptLogListener();

  addTask('test', createUnitTestTask(test_console.testCore));

  addTask('docs', createDartDocTask(_getLibs, linkApi: true, postBuild: dartdoc.postBuild));

  //
  // Analyzer
  //
  addTask('analyze_libs', createAnalyzerTask(_getLibs));

  addTask('analyze_test_libs',
          createAnalyzerTask(['test/harness_console.dart']));

  addChainedTask('analyze_all', ['analyze_libs', 'analyze_test_libs']);

  addTask('bench', createBenchTask());

  runHop();
}

Future<List<String>> _getLibs() {
  return new Directory('lib').list()
      .where((FileSystemEntity fse) => fse is File)
      .map((File file) => file.path)
      .toList();
}
