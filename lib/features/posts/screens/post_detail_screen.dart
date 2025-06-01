import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sosyalmedya_case/features/posts/providers/post_providers.dart';
import 'package:sosyalmedya_case/features/users/providers/user_providers.dart';
import 'package:sosyalmedya_case/features/comments/providers/comment_providers.dart';
import 'package:sosyalmedya_case/features/comments/widgets/comment_list_item.dart';

class PostDetailScreen extends ConsumerWidget {
  final int postId;
  const PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsync = ref.watch(postDetailProvider(postId));
    final commentsAsync = ref.watch(commentsForPostProvider(postId));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gönderi Detay"),
        actions: [
          postAsync.maybeWhen(
            data: (post) => IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                context.push('/posts/$postId/edit', extra: post);
              },
            ),
            orElse: () => Container(),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Gönderiyi sil"),
                  content: const Text(
                    "Bu gönderiyi silmek istediğine emin misin?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("İptal"),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Sil"),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                await ref.read(deletePostProvider(postId).future);
                if (!context.mounted) return; // Güvenli kontrol
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Gönderi silindi.")),
                );
              }
            },
          ),
        ],
      ),
      body: postAsync.when(
        data: (post) {
          final userAsync = ref.watch(userDetailProvider(post.userId));
          return userAsync.when(
            data: (user) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      Text(post.body),
                      const Divider(height: 32),
                      Text(
                        'Gönderen:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text('${user.name} (@${user.username})'),
                      Text(user.email),
                      const Divider(height: 32),
                      Text(
                        'Yorumlar',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      commentsAsync.when(
                        data: (comments) => Column(
                          children: [
                            ...comments.map((c) => CommentListItem(comment: c)),
                            _CommentForm(postId: postId), // Yorum ekleme formu
                          ],
                        ),
                        loading: () => const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                        error: (e, s) => Text('Yorumlar yüklenemedi: $e'),
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) =>
                Center(child: Text('Kullanıcı bilgisi yüklenemedi: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Gönderi bulunamadı: $e')),
      ),
    );
  }
}

class _CommentForm extends ConsumerStatefulWidget {
  final int postId;
  const _CommentForm({required this.postId});

  @override
  ConsumerState<_CommentForm> createState() => _CommentFormState();
}

class _CommentFormState extends ConsumerState<_CommentForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _sending = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Yorum Ekle',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Ad'),
                validator: (v) => v == null || v.isEmpty ? 'Ad zorunlu' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => v == null || !v.contains('@')
                    ? 'Geçerli bir email girin'
                    : null,
              ),
              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(labelText: 'Yorum'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Yorum boş olamaz' : null,
                minLines: 2,
                maxLines: 5,
              ),
              const SizedBox(height: 12),
              _sending
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          setState(() => _sending = true);
                          try {
                            await ref.read(
                              addCommentProvider((
                                postId: widget.postId,
                                name: _nameController.text,
                                email: _emailController.text,
                                body: _bodyController.text,
                              )).future,
                            );
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Yorum gönderildi!'),
                              ),
                            );
                            _nameController.clear();
                            _emailController.clear();
                            _bodyController.clear();
                          } catch (e) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text('Hata: $e')));
                          } finally {
                            if (mounted) setState(() => _sending = false);
                          }
                        },
                        child: const Text('Gönder'),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
