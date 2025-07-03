import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/note_view_model.dart';
import 'dart:io';

class DetailScreen extends StatelessWidget {
  final String noteId;
  const DetailScreen({super.key, required this.noteId});

  @override
  Widget build(BuildContext context) {
    final note = Provider.of<NoteViewModel>(context).notes.firstWhere((n) => n.id == noteId);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushNamed('/edit', arguments: note.id);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final navigator = Navigator.of(context);
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Note'),
                  content: const Text('Are you sure you want to delete this note?'),
                  actions: [
                    TextButton(onPressed: () => navigator.pop(false), child: const Text('Cancel')),
                    TextButton(onPressed: () => navigator.pop(true), child: const Text('Delete')),
                  ],
                ),
              );
              if (!context.mounted) return;
              if (confirm == true) {
                await Provider.of<NoteViewModel>(context, listen: false).deleteNote(note.id);
                if (navigator.canPop()) navigator.pop();
              }
            },
          ),
        ],
      ),
      body: Container(
        color: Color(note.backgroundColor),
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(note.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (note.imagePath != null) Image.file(File(note.imagePath!), height: 180, fit: BoxFit.cover),
            const SizedBox(height: 12),
            Text(note.content, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            Text('Created: ${note.createdDate}'),
            Text('Updated: ${note.updatedDate}'),
          ],
        ),
      ),
    );
  }
}
