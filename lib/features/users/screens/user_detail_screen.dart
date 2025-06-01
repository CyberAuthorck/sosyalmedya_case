import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sosyalmedya_case/features/users/providers/user_providers.dart';
import 'package:sosyalmedya_case/features/posts/providers/post_providers.dart';

class UserDetailScreen extends ConsumerWidget {
  final int userId;
  const UserDetailScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userDetailProvider(userId));
    final userPostsAsync = ref.watch(userPostsProvider(userId));

    return Scaffold(
      appBar: AppBar(title: const Text("Kullanıcı Detayı")),
      body: userAsync.when(
        data: (user) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.name, style: Theme.of(context).textTheme.titleLarge),
              Text(
                '@${user.username} • ${user.email}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              Text(
                "Gönderileri",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: userPostsAsync.when(
                  data: (posts) => posts.isEmpty
                      ? const Text("Bu kullanıcının gönderisi yok.")
                      : ListView.separated(
                          itemCount: posts.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            final post = posts[index];
                            return ListTile(
                              title: Text(post.title),
                              subtitle: Text(
                                post.body,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              ),
                              onTap: () {
                                context.push('/posts/${post.id}');
                              },
                            );
                          },
                        ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, s) => Text('Gönderiler yüklenemedi: $e'),
                ),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Kullanıcı yüklenemedi: $e')),
      ),
    );
  }
}
