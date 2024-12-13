import 'package:flutter/material.dart';
import 'package:flutter_note/model/note.dart';
import 'package:flutter_note/pages/editor.dart';
import 'package:flutter_note/pages/viewer.dart';
import 'package:flutter_note/shared/shared.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  bool showSearchField = false;

  @override
  void initState() {
    super.initState();
    searchNotes = notes;
  }

  void filterNotes(String value) {
    List<Note> FilteredNotes = [];
    for (var note in notes) {
      if (note.title.toLowerCase().contains(value.toLowerCase()) ||
          note.content.toLowerCase().contains(value.toLowerCase())) {
        FilteredNotes.add(note);
      }
    }
    setState(() {
      searchNotes = FilteredNotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                showSearchField = !showSearchField;
                if (!showSearchField) {
                  searchController.clear();
                  searchNotes = notes;
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (showSearchField)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  labelText: "Search Notes",
                ),
                onChanged: filterNotes,
              ),
            ),
          searchNotes.isEmpty
              ? Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage(
                            "assets/image/Notebook-amico.png",
                          ),
                          width: 200,
                          height: 200,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Create your first note!",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: searchNotes.length,
                    itemBuilder: (context, index) {
                      final note = searchNotes[index];
                      return GestureDetector(
                        onTap: () async {
                          final updatedNote = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NoteViewer(note: note),
                            ),
                          );

                          if (updatedNote != null && updatedNote is Note) {
                            setState(() {
                              searchNotes[index] = updatedNote;
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.primaries[
                                note.title.length % Colors.primaries.length],
                          ),
                          padding: const EdgeInsets.all(16.0),
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Text(
                            note.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newNote = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NoteEditor()),
          );

          if (newNote != null && newNote is Note) {
            setState(() {
              notes.add(newNote);
              searchNotes = notes;
            });
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
      ),
    );
  }
}
