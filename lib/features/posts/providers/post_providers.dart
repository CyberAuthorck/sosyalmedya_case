import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sosyalmedya_case/core/repositories/post_repository.dart';
import 'package:sosyalmedya_case/core/models/post.dart';
import 'package:sosyalmedya_case/core/providers/app_providers.dart';

final postRepositoryProvider = Provider<PostRepository>(
  (ref) => PostRepository(apiClient: ref.watch(apiClientProvider)),
);

final postsProvider = FutureProvider<List<Post>>((ref) async {
  final repo = ref.watch(postRepositoryProvider);
  return repo.fetchPosts();
});

final postDetailProvider = FutureProvider.family<Post, int>((
  ref,
  postId,
) async {
  final repo = ref.watch(postRepositoryProvider);
  return repo.fetchPost(postId);
});

final userPostsProvider = FutureProvider.family<List<Post>, int>((
  ref,
  userId,
) async {
  final repo = ref.watch(postRepositoryProvider);
  return repo.fetchPostsByUser(userId);
});

final deletePostProvider = FutureProvider.family<void, int>((
  ref,
  postId,
) async {
  final repo = ref.watch(postRepositoryProvider);
  await repo.deletePost(postId);
});
