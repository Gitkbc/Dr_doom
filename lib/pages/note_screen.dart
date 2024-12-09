import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; 

class NoteScreen extends StatefulWidget {
  final String? noteId; 
  final String? initialTitle;
  final String? initialNote;

  const NoteScreen({
    super.key,
    this.noteId, 
    this.initialTitle,
    this.initialNote, 
  });

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.initialTitle ?? '';
    noteController.text = widget.initialNote ?? '';
  }

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> _saveOrUpdateNote() async {
    final userId = FirebaseAuth.instance.currentUser?.uid; 
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    try {
      final noteData = {
        'title': titleController.text,
        'note': noteController.text,
        'userId': userId,
      };

      if (widget.noteId != null) {
        
        await FirebaseFirestore.instance.collection('notes').doc(widget.noteId).update(noteData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note updated successfully!')),
        );
      } else {
      
        await FirebaseFirestore.instance.collection('notes').add(noteData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note saved successfully!')),
        );
      }

      Navigator.pop(context); 
    } catch (e) {
      print("Error saving/updating note: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save/update note: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.noteId != null ? "Edit Note" : "Add Patient Data"),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Patient Name",
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: noteController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Patient Data",
                ),
                maxLines: 8,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveOrUpdateNote,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: Text(widget.noteId != null ? "Update Data" : "Save Data"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
