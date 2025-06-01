import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sosyalmedya_case/core/models/post.dart';

class PostListItem extends StatelessWidget {
  final Post post;
  final String? userName;

  const PostListItem({super.key, required this.post, this.userName});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(post.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: userName != null
            ? Text(
                userName!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            : null,
        onTap: () {
          context.push('/posts/${post.id}');
        },
      ),
    );
  }
}
