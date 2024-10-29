import 'package:flutter/material.dart';

class Contact {
  final String name;
  final String avatar;
  final String status;
  final bool isOnline;

  Contact({required this.name, required this.avatar, required this.status, required this.isOnline});
}

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Contact> contacts = [
    Contact(name: "John Doe", avatar: "assets/images/john.jpg", status: "Hey there! I'm using this app.", isOnline: true),
    Contact(name: "Jane Smith", avatar: "assets/images/jane.jpg", status: "Busy", isOnline: false),
    Contact(name: "Alice Johnson", avatar: "assets/images/alice.jpg", status: "Available", isOnline: true),
    // Add more contacts as needed
  ];

  List<Contact> filteredContacts = [];

  @override
  void initState() {
    super.initState();
    filteredContacts = contacts;
  }

  void _filterContacts(String query) {
    setState(() {
      filteredContacts = contacts
          .where((contact) => contact.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
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
                  setState(() {
                    contacts.add(Contact(
                      name: name,
                      avatar: "assets/images/default_avatar.jpg",
                      status: "Hey there! I'm using this app.",
                      isOnline: false,
                    ));
                    filteredContacts = contacts;
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"),
        backgroundColor: const Color.fromARGB(255, 100, 193, 230),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ContactSearchDelegate(contacts),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredContacts.length,
        itemBuilder: (context, index) {
          final contact = filteredContacts[index];
          return ListTile(
            leading: Stack(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(contact.avatar),
                ),
                if (contact.isOnline)
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
            title: Text(contact.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(contact.status, maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.chat, color: Color.fromARGB(255, 100, 193, 230)),
                  onPressed: () {
                    // TODO: Implement chat functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Start chat with ${contact.name}')),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.call, color: Color.fromARGB(255, 100, 193, 230)),
                  onPressed: () {
                    // TODO: Implement call functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Call ${contact.name}')),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddContactDialog,
        backgroundColor: const Color.fromARGB(255, 100, 193, 230),
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }
}

class ContactSearchDelegate extends SearchDelegate<String> {
  final List<Contact> contacts;

  ContactSearchDelegate(this.contacts);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? contacts
        : contacts.where((contact) => contact.name.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final contact = suggestionList[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(contact.avatar),
          ),
          title: Text(contact.name),
          subtitle: Text(contact.status, maxLines: 1, overflow: TextOverflow.ellipsis),
          onTap: () {
            close(context, contact.name);
          },
        );
      },
    );
  }
}
