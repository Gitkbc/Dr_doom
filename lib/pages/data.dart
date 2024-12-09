// data_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DataScreen extends StatelessWidget {
  const DataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
     
      stream: FirebaseFirestore.instance.collection('notes').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No notes available'));
        }

      
        final notes = snapshot.data!.docs;

        return ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final noteData = notes[index];
            final String title = noteData['title'];
            final String note = noteData['note'];

            return Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(note),
                onTap: () {
                 
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoteDetailScreen(
                        title: title,
                        note: note,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class NoteDetailScreen extends StatelessWidget {
  final String title;
  final String note;

  const NoteDetailScreen({required this.title, required this.note, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(note),
      ),
    );
  }
}
