import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sosyalmedya_case/features/posts/providers/post_providers.dart';
import 'package:sosyalmedya_case/features/posts/widgets/post_list_item.dart';
import 'package:sosyalmedya_case/features/users/providers/user_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postsProvider);
    final usersAsync = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gönderiler'),
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            tooltip: "Kullanıcılar",
            onPressed: () {
              context.push('/users');
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Yeni Gönderi",
            onPressed: () {
              context.push('/posts/new');
            },
          ),
        ],
      ),
      body: postsAsync.when(
        data: (posts) {
          return usersAsync.when(
            data: (users) {
              final userMap = {for (var u in users) u.id: u.username};

              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  final userName = userMap[post.userId];
                  return PostListItem(post: post, userName: userName);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) =>
                Center(child: Text('Kullanıcılar yüklenemedi: $error')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Gönderiler yüklenemedi: $error')),
      ),
    );
  }
}
