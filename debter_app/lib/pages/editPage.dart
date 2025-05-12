import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class EditPage extends StatefulWidget {
  final int index;
  final String title;
  final List content; // JSON content from Hive

  const EditPage({
    super.key,
    required this.index,
    required this.title,
    required this.content,
  });

  @override
  State<EditPage> createState() => _EditRichNotePageState();
}

class _EditRichNotePageState extends State<EditPage> {
  late QuillController contentController;
  late TextEditingController titleController;
  bool isTitleEditable = false;
  final box = Hive.box("debter");

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    contentController = QuillController(
      document: Document.fromJson(widget.content),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  void updateNote() {
    final formattedDate = DateFormat('yMMMMEEEEd').format(DateTime.now());
    box.putAt(widget.index, {
      "title": titleController.text,
      "content": contentController.document.toDelta().toJson(),
      "date": formattedDate,
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Successfully updated!")));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: updateNote,
        child: const Icon(Icons.save),
      ),
      appBar: AppBar(
        elevation: 0,
        title:
            isTitleEditable
                ? TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Title',
                  ),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  onSubmitted: (_) {
                    setState(() {
                      isTitleEditable = false;
                    });
                  },
                )
                : GestureDetector(
                  onTap: () {
                    setState(() {
                      isTitleEditable = true;
                    });
                  },
                  child: Text(
                    titleController.text,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            Expanded(
              child: QuillEditor.basic(
                controller: contentController,
                config: const QuillEditorConfig(
                  placeholder: "Edit content here...",
                ),
              ),
            ),
            QuillSimpleToolbar(
              controller: contentController,
              config: const QuillSimpleToolbarConfig(multiRowsDisplay: false),
            ),
          ],
        ),
      ),
    );
  }
}
