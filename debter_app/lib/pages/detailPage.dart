import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:google_fonts/google_fonts.dart';

class DetailPage extends StatefulWidget {
  final String title;
  final dynamic content; // Delta JSON content
  final int index;

  const DetailPage({
    super.key,
    required this.title,
    required this.content,
    required this.index,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late quill.QuillController _controller;

  @override
  void initState() {
    super.initState();
    final delta = quill.Document.fromJson(
      widget.content,
    ); // Initialize with content
    _controller = quill.QuillController(
      readOnly: true,
      document: delta,
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title, // Display the title of the note
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: quill.QuillEditor.basic(controller: _controller)),
          ],
        ),
      ),
    );
  }
}
