import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/note_view_model.dart';
import '../models/note_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final noteViewModel = Provider.of<NoteViewModel>(context);
    final notes = noteViewModel.notes;
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: noteViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : notes.isEmpty
          ? const Center(child: Text('No notes yet.'))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/detail', arguments: note.id);
                    },
                    child: Container(
                      decoration: BoxDecoration(color: Color(note.backgroundColor), borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Expanded(child: Text(note.content, maxLines: 4, overflow: TextOverflow.ellipsis)),
                          if (note.imagePath != null)
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Icon(Icons.image, size: 20, color: Colors.grey[700]),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/edit');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
