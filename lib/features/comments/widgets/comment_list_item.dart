import 'package:flutter/material.dart';
import 'package:sosyalmedya_case/core/models/comment.dart';

class CommentListItem extends StatelessWidget {
  final Comment comment;
  const CommentListItem({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(
          comment.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(comment.body),
            const SizedBox(height: 4),
            Text(comment.email, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
