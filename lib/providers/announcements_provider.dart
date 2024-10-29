import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/models/announcement.dart';
import 'package:my_app/services/api_service.dart'; // Add this import

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final announcementProvider = FutureProvider<List<Announcement>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.getAnnouncements();
});
