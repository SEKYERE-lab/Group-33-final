import 'package:flutter/material.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 10, // Replace with actual group count
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage('https://picsum.photos/200?random=$index'),
            ),
            title: Text('Group ${index + 1}'),
            subtitle: Text('${index * 3 + 5} members'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to group details
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // Show dialog to create new group
          _showCreateGroupDialog(context);
        },
      ),
    );
  }

  void _showCreateGroupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create New Group'),
          content: const TextField(
            decoration: InputDecoration(hintText: "Enter group name"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Create'),
              onPressed: () {
                // Implement group creation logic
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
