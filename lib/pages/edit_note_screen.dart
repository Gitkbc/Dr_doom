import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; 


class EditNoteScreen extends StatefulWidget {
  final String noteId; 
  final String initialTitle;
  final String initialNote;

  const EditNoteScreen({
    super.key,
    required this.noteId,
    required this.initialTitle,
    required this.initialNote,
  });

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.initialTitle;
    noteController.text = widget.initialNote;
  }

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> _updateNote() async {
    final userId = FirebaseAuth.instance.currentUser?.uid; 
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('notes').doc(widget.noteId).update({
        'title': titleController.text,
        'note': noteController.text,
        'userId': userId, 
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note updated successfully!')),
      );
      Navigator.pop(context); // Return to the previous screen
    } catch (e) {
      print("Error updating note: $e"); // Print the error for debugging
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update note: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Note"),
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
                onPressed: _updateNote,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text("Update Data"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
