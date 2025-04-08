import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class CreateNotes extends StatefulWidget {
  const CreateNotes({super.key});

  @override
  State<CreateNotes> createState() => _CreateNotesState();
}

class _CreateNotesState extends State<CreateNotes> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  var box = Hive.box("notesApp");

  void saveNotes(String title, String content) {
    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please fill all the required inputs and try again later",
          ),
        ),
      );
    } else {
      // box.add({"title": title, "content": content});
      box.add({"title": title, "content": content, "date": DateTime.now().day});
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Successfuly Registered!")));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    titleController.clear();
    contentController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveNotes(titleController.text, contentController.text);

          print(box.values.toList());
        },
        backgroundColor: Colors.grey.shade300.withAlpha(225),
        child: Icon(Icons.save),
      ),
      appBar: AppBar(title: Text("Create Note")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                label: Text("Title"),
                border: InputBorder.none,
              ),
            ),

            TextField(
              controller: contentController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                label: Text("Content"),
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
