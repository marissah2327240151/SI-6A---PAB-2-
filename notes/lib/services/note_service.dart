import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

class NoteService {
  final CollectionReference _notesCollection =
      FirebaseFirestore.instance.collection('notes');

  /// Get all notes as a stream (real-time updates), ordered by createdAt descending
  Stream<List<Note>> getNotes() {
    return _notesCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList();
    });
  }

  /// Add a new note to Firestore
  Future<void> addNote(Note note) async {
    await _notesCollection.add(note.toMap());
  }

  /// Update an existing note in Firestore
  Future<void> updateNote(Note note) async {
    await _notesCollection.doc(note.id).update(note.toMap());
  }

  /// Delete a note from Firestore
  Future<void> deleteNote(String id) async {
    await _notesCollection.doc(id).delete();
  }
}
