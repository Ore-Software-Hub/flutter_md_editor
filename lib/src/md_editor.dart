import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

enum MarkdownStyle { bold, italic, title }

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

  final String content;
  final bool editable;
  final String Function(String content)? onTextChanged;

  @override
  State<MdEditor> createState() => _MdEditorState();
}

class _MdEditorState extends State<MdEditor> {
  TextEditingController textController = TextEditingController();

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

  void applyStyle(MarkdownStyle style) {
    var selection = textController.selection;
    int cursorPosition = selection.base.offset;

    String baseText = textController.text;
    String selected = selection.textInside(textController.text);

    switch (style) {
      case MarkdownStyle.bold:
        if (selected.isEmpty) {
          if (baseText.isEmpty) {
            textController.text = "****";
            textController.selection = TextSelection.collapsed(offset: 2);
          } else {
            String newString =
                "${selection.textBefore(baseText)}****${selection.textAfter(baseText)}";
            textController.text = newString;
            textController.selection = TextSelection.collapsed(
              offset: cursorPosition + 2,
            );
          }
        } else {
          String newText = "**$selected**";
          String newString =
              "${selection.textBefore(baseText)}$newText${selection.textAfter(baseText)}";
          textController.text = newString;
        }
        break;

      case MarkdownStyle.italic:
        if (selected.isEmpty) {
          if (baseText.isEmpty) {
            textController.text = "**";
            textController.selection = TextSelection.collapsed(offset: 1);
          } else {
            String newString =
                "${selection.textBefore(baseText)}**${selection.textAfter(baseText)}";
            textController.text = newString;
            textController.selection = TextSelection.collapsed(
              offset: cursorPosition + 1,
            );
          }
        } else {
          String newText = "*$selected*";
          String newString =
              "${selection.textBefore(baseText)}$newText${selection.textAfter(baseText)}";
          textController.text = newString;
        }
        break;

      case MarkdownStyle.title:
        if (selected.isEmpty) {
          if (baseText.isEmpty) {
            textController.text = "# ";
            textController.selection = TextSelection.collapsed(offset: 2);
          } else {
            String newString =
                "${selection.textBefore(baseText)}# ${selection.textAfter(baseText)}";
            textController.text = newString;
            textController.selection = TextSelection.collapsed(
              offset: cursorPosition + 2,
            );
          }
        } else {
          String newText = "# $selected";
          String newString =
              "${selection.textBefore(baseText)}$newText${selection.textAfter(baseText)}";
          textController.text = newString;
        }
        break;
    }
  }

  ButtonStyle buttonStyle() {
    return ButtonStyle(
      iconColor: WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Mostra o Markdown
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

        // Mostra a edição
        if (isEditing)
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      style: buttonStyle(),
                      tooltip: 'Save',
                      onPressed: () {
                        setState(() {
                          isEditing = false;
                        });
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
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Digite aqui...",
                    ),
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 100),
      ],
    );
  }
}
