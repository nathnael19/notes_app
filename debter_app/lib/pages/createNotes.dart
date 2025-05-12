import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_quill/flutter_quill.dart';

class CreateNotes extends StatefulWidget {
  const CreateNotes({super.key});

  @override
  State<CreateNotes> createState() => _CreateNotesState();
}

class _CreateNotesState extends State<CreateNotes> {
  final titleController = TextEditingController();
  final contentController = QuillController.basic();
  String selectedCategory = "All";
  final box = Hive.box("debter");

  void saveNotes(String title, QuillController controller, String category) {
    final date = DateTime.now();
    final formattedDate = DateFormat('yMMMMEEEEd').format(date);
    final contentJson = controller.document.toDelta().toJson();

    if (title.isEmpty || controller.document.isEmpty()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all the required inputs.")),
      );
      return;
    }

    box.add({
      "title": title,
      "content": contentJson,
      "date": formattedDate,
      "category": category,
    });

    Navigator.pop(context);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Successfully Registered!")));
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
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Create Note",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveNotes(titleController.text, contentController, selectedCategory);
        },
        child: const Icon(Icons.save),
      ),
      body: SafeArea(
        child: Column(
          children: [
            QuillSimpleToolbar(
              controller: contentController,
              config: QuillSimpleToolbarConfig(multiRowsDisplay: false),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildInput("Title", titleController),
                    const SizedBox(height: 16),
                    buildCategoryDropdown(),
                    const SizedBox(height: 16),
                    buildQuillEditor(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInput(
    String label,
    TextEditingController controller, {
    bool multiline = false,
  }) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: TextField(
        controller: controller,
        keyboardType: multiline ? TextInputType.multiline : TextInputType.text,
        maxLines: multiline ? null : 1,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget buildCategoryDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: DropdownButtonFormField<String>(
        value: selectedCategory,
        decoration: InputDecoration(
          labelText: "Category",
          labelStyle: GoogleFonts.poppins(),
          border: InputBorder.none,
        ),
        items:
            ["All", "Personal", "Education"]
                .map(
                  (category) => DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  ),
                )
                .toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              selectedCategory = value;
            });
          }
        },
      ),
    );
  }

  Widget buildQuillEditor() {
    return Container(
      height: 250,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: QuillEditor.basic(
        controller: contentController,
        config: QuillEditorConfig(placeholder: "Content"),
      ),
    );
  }
}
