import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/createNotes.dart';
import 'package:notes_app/detailPage.dart';
import 'package:notes_app/drawer.dart';
import 'package:notes_app/editPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  var box = Hive.box("notesApp");

  void deleteNote(index) {
    setState(() {
      box.deleteAt(index);
    });
  }

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
            );
          },
          backgroundColor: Colors.grey.shade300.withAlpha(225),
          child: Icon(Icons.add),
        ),
        drawer: MyDrawer(),
        appBar: AppBar(
          title: Text("Debter", style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: TabBar(
            tabs: [Text("All"), Text("Education"), Text("Personal")],
          ),
        ),
        body: TabBarView(
          children: [
            myBody(),
            Center(
              child: Column(
                children: [
                  SizedBox(height: 7),
                  searchMethod(context),
                  Text("data"),
                ],
              ),
            ),
            Center(
              child: Column(
                children: [
                  SizedBox(height: 7),
                  searchMethod(context),
                  Text("dfsfs"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ValueListenableBuilder<Box<dynamic>> myBody() {
    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, box, _) {
        if (box.isEmpty) {
          return Center(child: Text("No notes yet"));
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              searchMethod(context),
              SizedBox(height: 7),
              Expanded(
                child: GridView.builder(
                  itemCount: box.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, index) {
                    final li = box.getAt(index);
                    final title = li["title"].toString();
                    final content = li["content"].toString();
                    final date = li["date"].toString();
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (contex) => DetailPage(
                                  title: title,
                                  content: content,
                                  index: index,
                                ),
                          ),
                        );
                      },
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Colors.grey.shade300.withAlpha(
                                220,
                              ),
                              title: Text(
                                "Are you Sure You want to delete it?",
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    deleteNote(index);
                                    Navigator.pop(context);
                                  },
                                  child: Text("Yes"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("No"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade300.withAlpha(65),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(title),
                                Text(
                                  content,
                                  maxLines: 2,
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      date,
                                      maxLines: 1,
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => EditPage(
                                                  content: content,
                                                  index: index,
                                                  title: title,
                                                ),
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.edit),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
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

  Container searchMethod(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.grey.shade300.withAlpha(75),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Search",
              suffix: IconButton(
                onPressed: () {
                  setState(() {
                    searchController.clear();
                  });
                },
                icon: Icon(Icons.clear_all),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
