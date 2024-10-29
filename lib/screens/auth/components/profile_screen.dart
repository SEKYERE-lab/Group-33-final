import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _username = 'Jacob Sekyere';
  String _status = 'Available';
  String _avatarPath = 'assets/images/john.jpg';
  bool _isNetworkImage = true;
  String _phone = '+1 234 567 890';
  String _email = 'john.doe@gmail.com';
  String _location = 'New York, USA';

  final List<String> _statusOptions = ['Available', 'Busy', 'Away', 'Do Not Disturb'];

  Future<void> _changeProfilePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _avatarPath = image.path;
        _isNetworkImage = false;
      });
      // TODO: Implement image upload to server
    }
  }

  void _editField(String field, String currentValue) {
    showDialog(
      context: context,
      builder: (context) {
        String newValue = currentValue;
        return AlertDialog(
          title: Text('Edit $field'),
          content: TextField(
            onChanged: (value) {
              newValue = value;
            },
            controller: TextEditingController(text: currentValue),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  switch (field) {
                    case 'Phone':
                      _phone = newValue;
                      break;
                    case 'Email':
                      _email = newValue;
                      break;
                    case 'Location':
                      _location = newValue;
                      break;
                    case 'Username':
                      _username = newValue;
                      break;
                  }
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.primaryColor,
                      theme.primaryColor.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 20), // Add some space above the profile image
                _buildProfileImage(),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _editField('Username', _username),
                  child: Text(
                    _username,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                _buildStatusSection(theme),
                _buildInfoSection(theme),
                _buildActionButtons(theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: _changeProfilePicture,
      child: CircleAvatar(
        radius: 60,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: 56,
          backgroundImage: _getProfileImage(),
        ),
      ),
    );
  }

  ImageProvider _getProfileImage() {
    if (_isNetworkImage) {
      return AssetImage(_avatarPath);
    } else {
      return FileImage(File(_avatarPath));
    }
  }

  Widget _buildStatusSection(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            _status,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _statusOptions.map((status) => ChoiceChip(
              label: Text(status),
              selected: _status == status,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _status = status);
                }
              },
              selectedColor: theme.primaryColor.withOpacity(0.2),
              labelStyle: TextStyle(color: _status == status ? theme.primaryColor : theme.textTheme.bodyMedium?.color),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(ThemeData theme) {
    return Column(
      children: [
        _buildInfoTile(Icons.phone, _phone, 'Phone', theme),
        _buildInfoTile(Icons.email, _email, 'Email', theme),
        _buildInfoTile(Icons.location_on, _location, 'Location', theme),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String text, String field, ThemeData theme) {
    return ListTile(
      leading: Icon(icon, color: theme.primaryColor),
      title: Text(text),
      trailing: Icon(Icons.edit, color: theme.primaryColor),
      onTap: () => _editField(field, text),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () {
              // TODO: Implement privacy settings navigation
            },
            child: const Text('Privacy Settings'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.primaryColor, side: BorderSide(color: theme.primaryColor),
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () {
              // TODO: Implement logout functionality
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
