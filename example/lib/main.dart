import 'package:flutter/material.dart';
import 'package:md_editor/md_editor.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Markdown Editor', home: const HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Markdown Editor')),
        body: MdEditor(content: '# Markdown Editor'),
      ),
    );
  }
}
