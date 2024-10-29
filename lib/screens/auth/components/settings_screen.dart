import 'package:flutter/material.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool privateAccount = false;
  bool darkModeEnabled = false;
  double fontSize = 16.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: theme.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(theme),
            _buildSettingsSection(
              "Account",
              [
                _buildSwitchTile(
                  "Private Account",
                  "Only people you approve can see your messages.",
                  privateAccount,
                  (value) => setState(() => privateAccount = value),
                ),
                _buildListTile(
                  "Change Password",
                  "Update your account password",
                  Icons.lock,
                  () {
                    // Navigate to change password screen
                  },
                ),
              ],
            ),
            _buildSettingsSection(
              "Notifications",
              [
                _buildSwitchTile(
                  "Enable Notifications",
                  "Receive push notifications",
                  notificationsEnabled,
                  (value) => setState(() => notificationsEnabled = value),
                ),
              ],
            ),
            _buildSettingsSection(
              "Appearance",
              [
                _buildSwitchTile(
                  "Dark Mode",
                  "Toggle dark theme",
                  darkModeEnabled,
                  (value) => setState(() => darkModeEnabled = value),
                ),
                _buildSliderTile(
                  "Font Size",
                  "Adjust the app's text size",
                  fontSize,
                  (value) => setState(() => fontSize = value),
                ),
              ],
            ),
            _buildSettingsSection(
              "Privacy",
              [
                _buildListTile(
                  "Blocked Accounts",
                  "Manage blocked users",
                  Icons.block,
                  () {
                    // Navigate to blocked accounts screen
                  },
                ),
                _buildListTile(
                  "Data and Storage",
                  "Manage your data usage and storage",
                  Icons.storage,
                  () {
                    // Navigate to data and storage screen
                  },
                ),
              ],
            ),
            _buildSettingsSection(
              "Help & About",
              [
                _buildListTile(
                  "FAQ",
                  "Frequently asked questions",
                  Icons.help,
                  () {
                    // Navigate to FAQ screen
                  },
                ),
                _buildListTile(
                  "Contact Support",
                  "Get help or report a problem",
                  Icons.contact_support,
                  () {
                    // Navigate to Contact Support screen
                  },
                ),
                _buildListTile(
                  "About",
                  "App version and information",
                  Icons.info,
                  () {
                    // Show about dialog
                    showAboutDialog(
                      context: context,
                      applicationName: "UENR SLIC Messaging App",
                      applicationVersion: "1.0.0",
                      applicationIcon: Image.asset(
                        "assets/images/app_icon.png",
                        width: 50,
                        height: 50,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: theme.primaryColor.withOpacity(0.1),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage("assets/images/user_avatar.png"),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "John Doe",
                  style: theme.textTheme.titleLarge,
                ),
                Text(
                  "john.doe@example.com",
                  style: theme.textTheme.titleSmall,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: theme.primaryColor),
            onPressed: () {
              // Navigate to edit profile screen
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.primaryColor,
            ),
          ),
        ),
        ...children,
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildSwitchTile(
      String title, String subtitle, bool value, Function(bool) onChanged) {
    final theme = Theme.of(context);
    return SwitchListTile(
      activeColor: theme.primaryColor,
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildListTile(
      String title, String subtitle, IconData icon, VoidCallback onTap) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.primaryColor),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildSliderTile(
      String title, String subtitle, double value, Function(double) onChanged) {
    final theme = Theme.of(context);
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: SizedBox(
        width: 150,
        child: Slider(
          activeColor: theme.primaryColor,
          value: value,
          min: 12,
          max: 24,
          divisions: 6,
          label: value.round().toString(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
