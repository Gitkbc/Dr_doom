import 'package:flutter/material.dart';

class NewsTile extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;

  const NewsTile({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8.0),
        leading: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error);
                },
              )
            : const Icon(Icons.image_not_supported),
        title: Text(title),
        subtitle: Text(description),
      ),
    );
  }
}