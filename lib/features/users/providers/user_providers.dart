import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sosyalmedya_case/core/repositories/user_repository.dart';
import 'package:sosyalmedya_case/core/models/user.dart';
import 'package:sosyalmedya_case/core/providers/app_providers.dart';

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepository(apiClient: ref.watch(apiClientProvider)),
);

final usersProvider = FutureProvider<List<User>>((ref) async {
  final repo = ref.watch(userRepositoryProvider);
  return repo.fetchUsers();
});

final userDetailProvider = FutureProvider.family<User, int>((
  ref,
  userId,
) async {
  final repo = ref.watch(userRepositoryProvider);
  return repo.fetchUser(userId);
});
