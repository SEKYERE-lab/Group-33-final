// screens/reminder_screen.dart
import 'package:flutter/material.dart';
import 'package:my_app/models/reminder.dart';
import 'package:my_app/providers/reminder_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reminderProvider = Provider.of<ReminderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: reminderProvider.reminders.length,
              itemBuilder: (context, index) {
                final reminder = reminderProvider.reminders[index];
                return ListTile(
                  title: Text(reminder.title),
                  subtitle: Text(reminder.dateTime.toString()),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      reminderProvider.removeReminder(reminder.id);
                    },
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final newReminder = Reminder(
                id: const Uuid().v4(),
                title: 'New Reminder',
                dateTime: DateTime.now().add(const Duration(seconds: 10)),
              );
              reminderProvider.addReminder(newReminder);
            },
            child: const Text('Add Reminder'),
          ),
        ],
      ),
    );
  }
}
