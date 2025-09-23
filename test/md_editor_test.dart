import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:md_editor/md_editor.dart';

void main() {
  testWidgets('Should return the text Hello World', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: MdEditor(content: 'Hello World')),
    );

    expect(find.widgetWithText(Markdown, "Hello World"), findsOneWidget);
  });

  testWidgets('Should show "No content" when content is empty', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: MdEditor(content: '')));
    expect(find.widgetWithText(Markdown, "No content"), findsOneWidget);
  });

  testWidgets('Should render markdown correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: MdEditor(content: '# Title\n**Bold**')),
    );
    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Bold'), findsOneWidget);
  });
}
