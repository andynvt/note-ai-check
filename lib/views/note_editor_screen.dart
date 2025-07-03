// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note_model.dart';
import '../view_models/note_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:permission_handler/permission_handler.dart';

class NoteEditorScreen extends StatefulWidget {
  final String? noteId;
  const NoteEditorScreen({super.key, this.noteId});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  int _backgroundColor = 0xFFFFFFFF;
  String? _imagePath;
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    if (widget.noteId != null) {
      final note = Provider.of<NoteViewModel>(context, listen: false).notes.firstWhere((n) => n.id == widget.noteId);
      _titleController.text = note.title;
      _contentController.text = note.content;
      _backgroundColor = note.backgroundColor;
      _imagePath = note.imagePath;
      _isEdit = true;
    }
  }

  Future<void> _pickImage({bool fromCamera = false}) async {
    final status = fromCamera ? await Permission.camera.request() : await Permission.photos.request();
    if (status.isGranted) {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: fromCamera ? ImageSource.camera : ImageSource.gallery);
      if (picked != null) {
        setState(() {
          _imagePath = picked.path;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Permission denied to access ${fromCamera ? 'camera' : 'photos'}')));
    }
  }

  void _saveNote() async {
    if (_formKey.currentState!.validate()) {
      final note = NoteModel(
        id: widget.noteId ?? const Uuid().v4(),
        title: _titleController.text,
        content: _contentController.text,
        backgroundColor: _backgroundColor,
        imagePath: _imagePath,
        createdDate: DateTime.now(),
        updatedDate: DateTime.now(),
      );
      final viewModel = Provider.of<NoteViewModel>(context, listen: false);
      if (_isEdit) {
        await viewModel.updateNote(note);
      } else {
        await viewModel.addNote(note);
      }
      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Note' : 'New Note'),
        actions: [IconButton(icon: const Icon(Icons.save), onPressed: _saveNote)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value == null || value.isEmpty ? 'Enter title' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 8,
                validator: (value) => value == null || value.isEmpty ? 'Enter content' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Color:'),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () async {
                      final color = await showDialog<int>(
                        context: context,
                        builder: (context) => _ColorPickerDialog(selected: _backgroundColor),
                      );
                      if (color != null) {
                        setState(() {
                          _backgroundColor = color;
                        });
                      }
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(color: Color(_backgroundColor), border: Border.all(), borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton.icon(onPressed: () => _pickImage(fromCamera: false), icon: const Icon(Icons.image), label: const Text('Attach Image')),
                  if (_imagePath != null) ...[const SizedBox(width: 8), Image.file(File(_imagePath!), width: 40, height: 40, fit: BoxFit.cover)],
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(onPressed: () => _pickImage(fromCamera: true), icon: const Icon(Icons.camera_alt), label: const Text('Camera')),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorPickerDialog extends StatelessWidget {
  final int selected;
  const _ColorPickerDialog({required this.selected});

  @override
  Widget build(BuildContext context) {
    final colors = [0xFFFFFFFF, 0xFFFFF59D, 0xFFB2FF59, 0xFF81D4FA, 0xFFFFAB91, 0xFFD1C4E9];
    return AlertDialog(
      title: const Text('Pick a color'),
      content: Wrap(
        spacing: 8,
        children: colors.map((c) {
          return GestureDetector(
            onTap: () => Navigator.of(context).pop(c),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Color(c),
                border: Border.all(color: c == selected ? Colors.black : Colors.transparent, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
