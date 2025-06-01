import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sosyalmedya_case/core/network/api_client.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());
