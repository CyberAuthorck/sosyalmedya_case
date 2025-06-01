import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sosyalmedya_case/features/posts/screens/home_screen.dart';
import 'package:sosyalmedya_case/features/posts/screens/post_detail_screen.dart';
import 'package:sosyalmedya_case/features/posts/screens/edit_post_screen.dart';
import 'package:sosyalmedya_case/core/models/post.dart';
import 'package:sosyalmedya_case/features/users/screens/user_list_screen.dart';
import 'package:sosyalmedya_case/features/users/screens/user_detail_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/posts/new',
      builder: (context, state) => const EditPostScreen(),
    ),
    GoRoute(
      path: '/posts/:id',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '');
        if (id == null) {
          return const Scaffold(
            body: Center(child: Text('Geçersiz gönderi ID')),
          );
        }
        return PostDetailScreen(postId: id);
      },
    ),
    GoRoute(
      path: '/posts/:id/edit',
      builder: (context, state) {
        final post = state.extra as Post?;
        if (post == null) {
          return const Scaffold(
            body: Center(child: Text('Gönderi bulunamadı')),
          );
        }
        return EditPostScreen(post: post);
      },
    ),
    GoRoute(
      path: '/users',
      builder: (context, state) => const UserListScreen(),
    ),
    GoRoute(
      path: '/users/:id',
      builder: (context, state) {
        final userId = int.tryParse(state.pathParameters['id'] ?? '');
        if (userId == null) {
          return const Scaffold(
            body: Center(child: Text('Kullanıcı bulunamadı')),
          );
        }
        return UserDetailScreen(userId: userId);
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Sosyal Medya Case',
      routerConfig: _router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
    );
  }
}
/// Developed by Muhammed Ali Aytek
/// June 2025 - Flutter Case Project