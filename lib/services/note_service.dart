import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import '../models/note_model.dart';

class NoteService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://mockapi.io/notes'; // Replace with your mock API
  final Box<NoteModel> _noteBox = Hive.box<NoteModel>('notes');

  // Local Hive operations
  List<NoteModel> getNotes() {
    return _noteBox.values.toList();
  }

  NoteModel? getNoteById(String id) {
    try {
      return _noteBox.values.firstWhere((note) => note.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> addNote(NoteModel note) async {
    await _noteBox.put(note.id, note);
    // Optionally sync with API
    await createNoteApi(note);
  }

  Future<void> updateNote(NoteModel note) async {
    await _noteBox.put(note.id, note);
    await updateNoteApi(note);
  }

  Future<void> deleteNote(String id) async {
    await _noteBox.delete(id);
    await deleteNoteApi(id);
  }

  // Mock API operations
  Future<List<NoteModel>> fetchNotesApi() async {
    // Simulate API call
    final response = await _dio.get('$_baseUrl');
    // TODO: Parse response and return list of NoteModel
    return [];
  }

  Future<NoteModel?> fetchNoteByIdApi(String id) async {
    final response = await _dio.get('$_baseUrl/$id');
    // TODO: Parse response and return NoteModel
    return null;
  }

  Future<void> createNoteApi(NoteModel note) async {
    await _dio.post('$_baseUrl', data: note.toJson());
  }

  Future<void> updateNoteApi(NoteModel note) async {
    await _dio.put('$_baseUrl/${note.id}', data: note.toJson());
  }

  Future<void> deleteNoteApi(String id) async {
    await _dio.delete('$_baseUrl/$id');
  }

  // Sync local notes with API
  Future<void> syncNotes() async {
    // Example: fetch from API and update local Hive
    final apiNotes = await fetchNotesApi();
    for (var note in apiNotes) {
      await _noteBox.put(note.id, note);
    }
  }
}

extension NoteModelJson on NoteModel {
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'backgroundColor': backgroundColor,
    'imagePath': imagePath,
    'createdDate': createdDate.toIso8601String(),
    'updatedDate': updatedDate.toIso8601String(),
  };
}
