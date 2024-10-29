import 'package:flutter/material.dart';
import 'dart:async';

class Call {
  final String name;
  final String time;
  final bool isIncoming;
  final bool isMissed;
  final bool isVideoCall;
  final String avatar;

  Call({
    required this.name,
    required this.time,
    required this.isIncoming,
    required this.isMissed,
    required this.isVideoCall,
    required this.avatar,
  });
}

class CallsScreen extends StatefulWidget {
  const CallsScreen({Key? key}) : super(key: key);

  @override
  _CallsScreenState createState() => _CallsScreenState();
}

class _CallsScreenState extends State<CallsScreen> {
  List<Call> calls = [
    Call(name: "John Doe", time: "10:30 AM", isIncoming: true, isMissed: false, isVideoCall: false, avatar: "assets/images/john.jpg"),
    Call(name: "Jane Smith", time: "Yesterday", isIncoming: false, isMissed: false, isVideoCall: true, avatar: "assets/images/jane.jpg"),
    Call(name: "Alice Johnson", time: "Yesterday", isIncoming: true, isMissed: true, isVideoCall: false, avatar: "assets/images/alice.jpg"),
  ];

  void _addNewCall(Call call) {
    setState(() {
      calls.insert(0, call);
    });
  }

  void _showAddContactDialog() {
    String name = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Contact'),
          content: TextField(
            onChanged: (value) {
              name = value;
            },
            decoration: const InputDecoration(hintText: "Enter contact name"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (name.isNotEmpty) {
                  _addNewCall(Call(
                    name: name,
                    time: 'Just now',
                    isIncoming: false,
                    isMissed: false,
                    isVideoCall: false,
                    avatar: "assets/images/default_avatar.jpg",
                  ));
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _simulateCall(Call call) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Calling ${call.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(call.avatar),
              ),
              const SizedBox(height: 20),
              Text(call.isVideoCall ? 'Video Call in progress...' : 'Voice Call in progress...'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('End Call'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    // Simulate call duration
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pop();
      _addNewCall(Call(
        name: call.name,
        time: 'Just now',
        isIncoming: false,
        isMissed: false,
        isVideoCall: call.isVideoCall,
        avatar: call.avatar,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calls"),
        backgroundColor: const Color.fromARGB(255, 100, 193, 230),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: _showAddContactDialog,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: calls.length,
        itemBuilder: (context, index) {
          final call = calls[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(call.avatar),
            ),
            title: Text(call.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Row(
              children: [
                Icon(
                  call.isIncoming ? Icons.call_received : Icons.call_made,
                  size: 16,
                  color: call.isMissed ? Colors.red : Colors.green,
                ),
                const SizedBox(width: 6),
                Text(call.time),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(call.isVideoCall ? Icons.videocam : Icons.call, color: const Color.fromARGB(255, 100, 193, 230)),
                  onPressed: () => _simulateCall(call),
                ),
                IconButton(
                  icon: Icon(call.isVideoCall ? Icons.call : Icons.videocam, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      calls[index] = Call(
                        name: call.name,
                        time: call.time,
                        isIncoming: call.isIncoming,
                        isMissed: call.isMissed,
                        isVideoCall: !call.isVideoCall,
                        avatar: call.avatar,
                      );
                    });
                  },
                ),
              ],
            ),
            onTap: () => _simulateCall(call),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddContactDialog,
        backgroundColor: const Color.fromARGB(255, 100, 193, 230),
        child: const Icon(Icons.add_call, color: Colors.white),
      ),
    );
  }
}