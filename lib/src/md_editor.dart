import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// An enumeration of the markdown styles that can be applied.
enum MarkdownStyle {
  /// Applies bold style, using `**text**`.
  bold,

  /// Applies italic style, using `*text*`.
  italic,

  /// Applies a title style (H1), using `# text`.
  title,
}

/// A versatile markdown editor widget that allows for both viewing and editing
/// of markdown content.
///
/// This widget can be used as a simple markdown viewer when `editable` is
/// false, or as a full-featured markdown editor with a toolbar when `editable`
/// is true. The editor provides buttons to apply bold, italic, and title
/// styles to the text.
class MdEditor extends StatefulWidget {
  const MdEditor({
    super.key,
    required this.content,
    this.onTextChanged,
    this.editable = false,
  }) : assert(
         editable == false || onTextChanged != null,
         'If "editable" is true, "onTextChanged" is required.',
       );

  /// The initial markdown content to be displayed and edited.
  final String content;

  /// A boolean that determines whether the content can be edited.
  ///
  /// If `true`, a toolbar and a text field will be shown.
  /// If `false`, only the markdown content will be displayed.
  final bool editable;

  /// A callback function that is triggered when the text changes.
  ///
  /// This function receives the updated content string.
  ///
  /// Note: This parameter is required if `editable` is true, as enforced by the `assert`.
  final void Function(String content)? onTextChanged;

  /// Creates an `MdEditor` widget.
  ///
  /// The `content` is the initial markdown string.
  ///
  /// The `editable` flag controls the editing mode. If set to `true`, the
  /// `onTextChanged` callback must also be provided.

  @override
  State<MdEditor> createState() => _MdEditorState();
}

class _MdEditorState extends State<MdEditor> {
  final TextEditingController textController = TextEditingController();

  bool isEditing = false;
  bool editable = false;

  @override
  void initState() {
    textController.text = widget.content;
    editable = widget.editable;
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  /// Applies the specified markdown style to the selected text or at the current
  /// cursor position.
  ///
  /// If text is selected and the style is already applied, it will be removed.
  /// Otherwise, the style will be applied.
  /// If no text is selected, the style markers are inserted at the cursor position
  /// and the cursor is placed in the middle, ready for typing.
  ///
  /// @param style The `MarkdownStyle` to apply (e.g., `MarkdownStyle.bold`).
  void applyStyle(MarkdownStyle style) {
    var selection = textController.selection;
    int cursorPosition = selection.base.offset;

    String baseText = textController.text;
    String selected = selection.textInside(baseText);

    if (selected.isEmpty) {
      // If no text is selected, insert the markdown markers.
      String newText;
      int newCursorOffset;
      switch (style) {
        case MarkdownStyle.bold:
          newText = "** **";
          newCursorOffset = 2;
          break;
        case MarkdownStyle.italic:
          newText = "* *";
          newCursorOffset = 1;
          break;
        case MarkdownStyle.title:
          newText = "# ";
          newCursorOffset = 2;
          break;
      }
      String newString =
          "${selection.textBefore(baseText)}$newText${selection.textAfter(baseText)}";
      textController.text = newString;
      textController.selection = TextSelection.collapsed(
        offset: cursorPosition + newCursorOffset,
      );
    } else {
      // If text is selected, check if style is already applied.
      String newText = selected;
      bool styleApplied = false;
      String prefix = "";
      String suffix = "";

      switch (style) {
        case MarkdownStyle.bold:
          prefix = "**";
          suffix = "**";
          if (selection.textBefore(baseText).endsWith(prefix) &&
              selection.textAfter(baseText).startsWith(suffix)) {
            styleApplied = true;
          }
          break;
        case MarkdownStyle.italic:
          prefix = "*";
          suffix = "*";
          if (selection.textBefore(baseText).endsWith(prefix) &&
              selection.textAfter(baseText).startsWith(suffix)) {
            styleApplied = true;
          }
          break;
        case MarkdownStyle.title:
          prefix = "# ";
          suffix = ""; // No suffix for titles
          if (selection.textBefore(baseText).endsWith(prefix)) {
            styleApplied = true;
          }
          break;
      }

      String newString;
      if (styleApplied) {
        // Unapply the style
        String textBefore = selection.textBefore(baseText);
        String textAfter = selection.textAfter(baseText);

        // Remove prefix
        if (textBefore.endsWith(prefix)) {
          textBefore = textBefore.substring(
            0,
            textBefore.length - prefix.length,
          );
        }

        // Remove suffix
        if (textAfter.startsWith(suffix)) {
          textAfter = textAfter.substring(suffix.length);
        }

        newString = "$textBefore$selected$textAfter";
        textController.text = newString;
      } else {
        // Apply the style
        newText = "$prefix$selected$suffix";
        newString =
            "${selection.textBefore(baseText)}$newText${selection.textAfter(baseText)}";
        textController.text = newString;
      }
    }
  }

  /// Returns a `ButtonStyle` to ensure consistent styling for the toolbar icons.
  ButtonStyle buttonStyle() {
    return ButtonStyle(
      iconColor: WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Displays the markdown content when not in editing mode.
        if (!isEditing)
          Expanded(
            child: Markdown(
              data: textController.text.isEmpty
                  ? 'No content'
                  : textController.text,
              selectable: editable,
              onTapText: () {
                setState(() {
                  isEditing = true;
                });
              },
            ),
          ),

        /// Displays the text field and the editing toolbar when in editing mode.
        if (isEditing)
          Expanded(
            child: Column(
              children: [
                /// Toolbar for markdown style buttons.
                Row(
                  children: [
                    IconButton(
                      style: buttonStyle(),
                      tooltip: 'Save',
                      onPressed: () {
                        setState(() {
                          isEditing = false;
                        });
                        widget.onTextChanged!(textController.text);
                      },
                      icon: PhosphorIcon(PhosphorIconsBold.floppyDisk),
                    ),
                    IconButton(
                      style: buttonStyle(),
                      tooltip: 'Bold',
                      onPressed: () {
                        applyStyle(MarkdownStyle.bold);
                      },
                      icon: PhosphorIcon(PhosphorIconsBold.textB),
                    ),
                    IconButton(
                      style: buttonStyle(),
                      tooltip: 'Italic',
                      onPressed: () {
                        applyStyle(MarkdownStyle.italic);
                      },
                      icon: PhosphorIcon(PhosphorIconsBold.textItalic),
                    ),
                    IconButton(
                      style: buttonStyle(),
                      tooltip: 'Title',
                      onPressed: () {
                        applyStyle(MarkdownStyle.title);
                      },
                      icon: PhosphorIcon(PhosphorIconsBold.textH),
                    ),
                  ],
                ),
                Expanded(
                  child: TextField(
                    controller: textController,
                    expands: true,
                    minLines: null,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Type here...",
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
