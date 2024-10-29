import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';


class ChannelsScreen extends StatefulWidget {
  const ChannelsScreen({Key? key}) : super(key: key);

  @override
  _ChannelsScreenState createState() => _ChannelsScreenState();
}

class _ChannelsScreenState extends State<ChannelsScreen> {
  final List<Map<String, dynamic>> channels = [
    {"name": "General", "members": 120, "lastActive": "2 min ago"},
    {"name": "Flutter Devs", "members": 80, "lastActive": "5 min ago"},
    // Add more channels here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Channels'),
        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Add search functionality here
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Add filter functionality here
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: ListView.builder(
          itemCount: channels.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: kPrimaryColor.withOpacity(0.1),
                  child: const Icon(Icons.view_module, color: kPrimaryColor),
                ),
                title: Text(channels[index]["name"],
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${channels[index]["members"]} members"),
                    Text("Last active: ${channels[index]["lastActive"]}"),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    // Join channel logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text("Join"),
                ),
                onTap: () {
                  // Navigate to channel details or chat screen
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add functionality to create a new channel
        },
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
