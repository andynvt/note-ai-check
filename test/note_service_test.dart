import 'package:flutter_test/flutter_test.dart';
import 'package:notes/models/note_model.dart';
import 'package:notes/services/note_service.dart';
import 'package:hive/hive.dart';
import 'dart:io';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final testDir = Directory('./test/hive_testing');
  if (!testDir.existsSync()) {
    testDir.createSync(recursive: true);
  }
  Hive.init(testDir.path);
  Hive.registerAdapter(NoteModelAdapter());
  final box = await Hive.openBox<NoteModel>('notes_service_test');

  group('NoteService', () {
    late NoteService service;
    setUp(() {
      service = NoteService(noteBox: box, mockApi: true);
    });

    tearDown(() async {
      await box.clear();
    });

    test('Add and get note', () async {
      final note = NoteModel(id: '1', title: 'Test', content: 'Content', backgroundColor: 0xFFFFFFFF, imagePath: null, createdDate: DateTime.now(), updatedDate: DateTime.now());
      await service.addNote(note);
      final notes = service.getNotes();
      expect(notes.any((n) => n.id == '1'), true);
    });

    test('Update note', () async {
      final note = NoteModel(id: '2', title: 'Test2', content: 'Content2', backgroundColor: 0xFFFFFFFF, imagePath: null, createdDate: DateTime.now(), updatedDate: DateTime.now());
      await service.addNote(note);
      final updated = NoteModel(
        id: note.id,
        title: 'Updated',
        content: note.content,
        backgroundColor: note.backgroundColor,
        imagePath: note.imagePath,
        createdDate: note.createdDate,
        updatedDate: DateTime.now(),
      );
      await service.updateNote(updated);
      expect(service.getNotes().first.title, 'Updated');
    });

    test('Delete note', () async {
      final note = NoteModel(id: '3', title: 'Test3', content: 'Content3', backgroundColor: 0xFFFFFFFF, imagePath: null, createdDate: DateTime.now(), updatedDate: DateTime.now());
      await service.addNote(note);
      await service.deleteNote(note.id);
      expect(service.getNotes().any((n) => n.id == note.id), false);
    });
  });

  tearDownAll(() async {
    try {
      await box.close();
      await box.deleteFromDisk();
    } catch (_) {}
  });
}
