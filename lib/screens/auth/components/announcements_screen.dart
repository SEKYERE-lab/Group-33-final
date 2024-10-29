import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_app/providers/announcement_provider.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Announcements')),
      body: Consumer<AnnouncementProvider>(
        builder: (context, announcementProvider, child) {
          if (announcementProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (announcementProvider.error != null) {
            return Center(child: Text('Error: ${announcementProvider.error}'));
          } else {
            final announcements = announcementProvider.announcements;
            return ListView.builder(
              itemCount: announcements.length,
              itemBuilder: (context, index) {
                final announcement = announcements[index];
                return ListTile(
                  title: Text(announcement.title),
                  subtitle: Text(announcement.content),
                  trailing: Text(announcement.date.toString().split(' ')[0]),
                );
              },
            );
          }
        },
      ),
    );
  }
}
