# Markdown Editor

A simple and customizable Markdown text editor for Flutter.

## Features

- Live preview of Markdown
- Customizable toolbar
- Easy integration

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
    md_editor: ^latest_version
```

Run `flutter pub get` to install.

## Usage

Import the package:

```dart
import 'package:md_editor/md_editor.dart';
```

Use the editor widget in your app:


> [!IMPORTANT]
> if `editable` is set true, you must provide `onTextChanged` function.

```dart
MdEditor(
    content: '# Hello Markdown!',
    editable: true,
    onTextChanged: (text) { 
        // Handle text changes
    },
)
```

## Example

```dart
import 'package:flutter/material.dart';
import 'package:md_editor/md_editor.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            home: Scaffold(
                appBar: AppBar(title: Text('Markdown Editor')),
                body: MdEditor(
                    content: '# Markdown Editor'
                ),
            ),
        );
    }
}
```

## Documentation

See the [API reference](https://pub.dev/packages/md_editor) for more details.

## License

This project is licensed under the MIT License.