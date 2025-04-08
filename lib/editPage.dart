import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class EditPage extends StatefulWidget {
  final String title;
  final String content;
  final String? type;
  final int index;
  const EditPage({
    super.key,
    required this.content,
    required this.index,
    required this.title,
    this.type,
  });

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final box = Hive.box("notesApp");
  @override
  Widget build(BuildContext context) {
    final edit = TextEditingController(text: widget.content);
    final date = DateTime.timestamp().toLocal();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            box.deleteAt(widget.index);
            box.add({
              "title": widget.title,
              "content": edit.text,
              "date": date,
            });
          });
          Navigator.pop(context);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Successfuly Updated!")));
          edit.clear();
        },
        child: Text("Update"),
      ),
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: edit,
              maxLines: null,
              decoration: InputDecoration(border: InputBorder.none),
            ),
          ],
        ),
      ),
    );
  }
}
