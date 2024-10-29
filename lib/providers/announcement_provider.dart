import 'package:flutter/foundation.dart';
import 'package:my_app/models/announcement.dart';

class AnnouncementProvider with ChangeNotifier {
  final List<Announcement> _announcements = [];
  bool _isLoading = false;
  String? _error;

  List<Announcement> get announcements => _announcements;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchAnnouncements() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Fetch announcements from your API or data source
      // For example:
      // _announcements = await YourApiService.getAnnouncements();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
