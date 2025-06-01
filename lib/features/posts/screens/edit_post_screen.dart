import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sosyalmedya_case/core/models/post.dart';
import 'package:sosyalmedya_case/core/models/user.dart';
import 'package:sosyalmedya_case/features/posts/providers/post_providers.dart';
import 'package:sosyalmedya_case/features/users/providers/user_providers.dart';
import 'package:go_router/go_router.dart';

class EditPostScreen extends ConsumerStatefulWidget {
  final Post? post;
  const EditPostScreen({super.key, this.post});

  @override
  ConsumerState<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends ConsumerState<EditPostScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  User? _selectedUser;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post?.title ?? '');
    _bodyController = TextEditingController(text: widget.post?.body ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post == null ? "Yeni Gönderi" : "Gönderiyi Düzenle"),
      ),
      body: usersAsync.when(
        data: (users) {
          if (widget.post != null && _selectedUser == null) {
            _selectedUser = users.firstWhere(
              (u) => u.id == widget.post!.userId,
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<User>(
                    value: _selectedUser,
                    items: users
                        .map(
                          (u) => DropdownMenuItem(
                            value: u,
                            child: Text('${u.name} (@${u.username})'),
                          ),
                        )
                        .toList(),
                    decoration: const InputDecoration(labelText: "Kullanıcı"),
                    onChanged: (u) => setState(() => _selectedUser = u),
                    validator: (u) => u == null ? 'Kullanıcı seçin' : null,
                  ),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Başlık'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Başlık boş olamaz' : null,
                  ),
                  TextFormField(
                    controller: _bodyController,
                    decoration: const InputDecoration(labelText: 'İçerik'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'İçerik boş olamaz' : null,
                    minLines: 3,
                    maxLines: 10,
                  ),
                  const SizedBox(height: 24),
                  _sending
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (!_formKey.currentState!.validate()) return;
                              setState(() => _sending = true);
                              try {
                                if (widget.post == null) {
                                  await ref
                                      .read(postRepositoryProvider)
                                      .createPost(
                                        Post(
                                          userId: _selectedUser!.id,
                                          id: 0,
                                          title: _titleController.text,
                                          body: _bodyController.text,
                                        ),
                                      );
                                  if (context.mounted) {
                                    context.pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Gönderi eklendi!'),
                                      ),
                                    );
                                  }
                                } else {
                                  await ref
                                      .read(postRepositoryProvider)
                                      .updatePost(
                                        Post(
                                          userId: _selectedUser!.id,
                                          id: widget.post!.id,
                                          title: _titleController.text,
                                          body: _bodyController.text,
                                        ),
                                      );
                                  if (context.mounted) {
                                    context.pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Gönderi güncellendi!'),
                                      ),
                                    );
                                  }
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Hata: $e')),
                                );
                              } finally {
                                setState(() => _sending = false);
                              }
                            },
                            child: Text(
                              widget.post == null ? "Gönderi Ekle" : "Güncelle",
                            ),
                          ),
                        ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Kullanıcılar yüklenemedi: $e')),
      ),
    );
  }
}
