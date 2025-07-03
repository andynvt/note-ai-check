import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/note_service.dart';

class NoteViewModel extends ChangeNotifier {
  final NoteService _noteService;

  List<NoteModel> _notes = [];
  bool _isLoading = false;

  List<NoteModel> get notes => _notes;
  bool get isLoading => _isLoading;

  NoteViewModel({NoteService? service}) : _noteService = service ?? NoteService() {
    loadNotes();
  }

  Future<void> loadNotes() async {
    _isLoading = true;
    notifyListeners();
    _notes = _noteService.getNotes();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addNote(NoteModel note) async {
    await _noteService.addNote(note);
    await loadNotes();
  }

  Future<void> updateNote(NoteModel note) async {
    await _noteService.updateNote(note);
    await loadNotes();
  }

  Future<void> deleteNote(String id) async {
    await _noteService.deleteNote(id);
    await loadNotes();
  }

  Future<void> syncNotes() async {
    _isLoading = true;
    notifyListeners();
    await _noteService.syncNotes();
    await loadNotes();
    _isLoading = false;
    notifyListeners();
  }
}
