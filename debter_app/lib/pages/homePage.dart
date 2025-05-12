import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/pages/createNotes.dart';
import 'package:notes_app/pages/detailPage.dart';
import 'package:notes_app/pages/editPage.dart';
import 'package:notes_app/utils/drawer.dart';
import 'package:flutter_quill/flutter_quill.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  var box = Hive.box("debter");

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateNotes()),
            ).then((_) => setState(() {}));
          },
          child: Icon(Icons.add, color: Colors.white),
        ),
        drawer: MyDrawer(),
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "Debter",
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          bottom: const TabBar(
            tabs: [Text("All"), Text("Education"), Text("Personal")],
          ),
        ),
        body: TabBarView(
          children: [
            notesTab("all"),
            notesTab("education"),
            notesTab("personal"),
          ],
        ),
      ),
    );
  }

  Widget notesTab(String categoryFilter) {
    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, Box box, _) {
        final allNotes = box.values.toList();
        final filteredNotes =
            allNotes.where((note) {
              final category = note["category"]?.toString().toLowerCase();
              final title = note["title"]?.toString().toLowerCase() ?? "";
              final query = searchController.text.toLowerCase();

              final categoryMatch =
                  categoryFilter == "all" || category == categoryFilter;
              final searchMatch = query.isEmpty || title.contains(query);

              return categoryMatch && searchMatch;
            }).toList();

        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              buildSearchBar(),
              const SizedBox(height: 10),
              filteredNotes.isEmpty
                  ? Expanded(
                    child: Center(
                      child: Text(
                        "No matching notes found.",
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                    ),
                  )
                  : Expanded(
                    child: GridView.builder(
                      itemCount: filteredNotes.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.9,
                          ),
                      itemBuilder: (context, index) {
                        final note = filteredNotes[index];
                        final title = note["title"];
                        final content = note["content"];
                        final date = note["date"];
                        final originalIndex = box.values.toList().indexOf(note);

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => DetailPage(
                                      title: title,
                                      content: content,
                                      index: originalIndex,
                                    ),
                              ),
                            ).then((_) => setState(() {}));
                          },
                          onLongPress: () => showDeleteDialog(originalIndex),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: Text(
                                    getPlainTextFromDelta(content),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(fontSize: 13),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      date,
                                      style: GoogleFonts.poppins(fontSize: 8),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) => EditPage(
                                                  content: content,
                                                  title: title,
                                                  index: originalIndex,
                                                ),
                                          ),
                                        ).then((_) => setState(() {}));
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        size: 18,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }

  Widget buildSearchBar() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: searchController,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          icon: Icon(Icons.search),
          hintText: "Search notes...",
          hintStyle: GoogleFonts.poppins(fontSize: 14),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              searchController.clear();
              setState(() {});
            },
          ),
        ),
      ),
    );
  }

  void showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(
              "Delete this note?",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            content: Text(
              "This action cannot be undone.",
              style: GoogleFonts.poppins(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel", style: GoogleFonts.poppins()),
              ),
              ElevatedButton(
                onPressed: () {
                  box.deleteAt(index);
                  Navigator.pop(context);
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
                child: Text("Delete", style: GoogleFonts.poppins()),
              ),
            ],
          ),
    );
  }

  String getPlainTextFromDelta(dynamic jsonDelta) {
    try {
      if (jsonDelta is String) {
        jsonDelta = jsonDecode(jsonDelta);
      }
      final doc = Document.fromJson(List<Map<String, dynamic>>.from(jsonDelta));
      return doc.toPlainText().trim();
    } catch (e) {
      return "";
    }
  }
}
