import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sosyalmedya_case/core/repositories/comment_repository.dart';
import 'package:sosyalmedya_case/core/models/comment.dart';
import 'package:sosyalmedya_case/core/providers/app_providers.dart';

final commentRepositoryProvider = Provider<CommentRepository>(
  (ref) => CommentRepository(apiClient: ref.watch(apiClientProvider)),
);

final commentsForPostProvider = FutureProvider.family<List<Comment>, int>((
  ref,
  postId,
) async {
  final repo = ref.watch(commentRepositoryProvider);
  return repo.fetchCommentsForPost(postId);
});

final addCommentProvider =
    FutureProvider.family<
      void,
      ({int postId, String name, String email, String body})
    >((ref, args) async {
      final repo = ref.watch(commentRepositoryProvider);
      await repo.createComment(
        Comment(
          postId: args.postId,
          id: 0, // JSONPlaceholder'da önemsiz sonuçta fake
          name: args.name,
          email: args.email,
          body: args.body,
        ),
      );
    });
