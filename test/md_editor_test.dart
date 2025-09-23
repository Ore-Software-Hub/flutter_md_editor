import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:md_editor/md_editor.dart';

void main() {
  testWidgets('description', (WidgetTester tester) async {
    String? received;
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: MdEditor())));
  });
}
