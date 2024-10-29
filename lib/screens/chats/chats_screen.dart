import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:my_app/models/Chat.dart';
import 'package:my_app/screens/auth/components/announcements_screen.dart';
import 'package:my_app/screens/auth/components/contacts_screen.dart';
import 'package:my_app/screens/auth/components/groups_screen.dart';
import 'package:my_app/screens/auth/components/language_screen.dart';
import 'package:my_app/screens/auth/components/library_screen.dart';
import 'package:my_app/screens/auth/components/profile_screen.dart';
import 'package:my_app/screens/auth/components/settings_screen.dart';
import 'package:my_app/screens/calls/calls_screen.dart';
import 'package:my_app/screens/messages/message_screen.dart';
import 'package:my_app/services/api_service.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key, required bool isLecturer}) : super(key: key);

  @override
  ChatsScreenState createState() => ChatsScreenState();
}

class ChatsScreenState extends State<ChatsScreen> with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  int _selectedIndex = 0;
  late TabController _tabController;
  List<Chat> _chats = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeChats();
  }

  void _initializeChats() {
    setState(() {
      _chats = [
        Chat(
          id: "1",
          name: "Nana Takyi",
          lastMessage: "Hope you are doing well...",
          image: "assets/images/nana.jpg",
          timestamp: DateTime.now(),
          isRead: false,
          isActive: true,
        ),
        // Add more Chat objects here
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Improved AppBar with gradient
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text("Chats", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              // Removed SliverAppBar to eliminate the duplicate
              // Keeping only the AppBar defined in the Scaffold
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildChatList(),
              const CallsScreen(),
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: const Color.fromARGB(255, 100, 193, 230),
        foregroundColor: Colors.white,
        activeBackgroundColor: Colors.red,
        activeForegroundColor: Colors.white,
        buttonSize: const Size(56.0, 56.0),
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.chat),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            label: 'Contacts',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ContactsScreen()),
            ),
          ),
          SpeedDialChild(
            child: const Icon(Icons.library_books),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            label: 'Library',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LibraryScreen(isLecturer: false)),
            ),
          ),
          SpeedDialChild(
            child: const Icon(Icons.forum),
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            label: 'Forum',
            onTap: () {
              // Navigate to Forum screen
              // Replace with actual navigation when you have the ForumScreen
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const ForumScreen()),
              // );
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.announcement),
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            label: 'Announcements',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AnnouncementsScreen()),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: "Chats"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Groups"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      itemCount: _chats.length,
      itemBuilder: (context, index) {
        final chat = _chats[index];
        return Card( // Wrapped in Card for better UI
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            leading: Stack(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(chat.image),
                ),
                if (chat.isActive)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            title: Text(chat.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
              chat.lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatTimestamp(chat.timestamp),
                  style: TextStyle(
                    color: chat.isRead ? Colors.grey : Colors.blue,
                    fontSize: 12,
                  ),
                ),
                if (!chat.isRead)
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MessagesScreen(chat: chat)),
              );
            },
          ),
        );
      },
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      return "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}";
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else {
      return "${timestamp.day}/${timestamp.month}";
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Already on Chats screen
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GroupsScreen()),
        );
        break;
      case 2:
        _showProfileBottomSheet();
        break;
    }
  }

  void _showProfileBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, controller) => ListView(
          controller: controller,
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/images/user_2.png"),
            ),
            const SizedBox(height: 20),
            const Text(
              "User Name",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text("Academic Tracker"),
              onTap: () async {
                Navigator.pop(context);
                try {
                  await _apiService.launchPortal();
                } catch (e) {
                  final context = this.context; // Use the widget's context
                  if (mounted) { // Check if the widget is still mounted again
                    ScaffoldMessenger.of(context).showSnackBar( // Use the stored context
                      const SnackBar(content: Text('Could not open the portal. Please try again later.')),
                    );
                  }
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );// Navigate to Settings screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text("Language"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LanguageScreen()),
                );// Navigate to Language screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text("Help & Feedback"),
              onTap: () {
                // Navigate to Help & Feedback screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                // Implement logout functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}
