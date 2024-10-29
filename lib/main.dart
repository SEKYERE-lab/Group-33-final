import 'package:my_app/providers/announcement_provider.dart';
import 'package:my_app/providers/message_provider.dart';
import 'package:my_app/providers/reminder_provider.dart';
import 'package:my_app/providers/user_provider.dart';
import 'package:my_app/screens/Homescreens/admin_home_screen.dart';
import 'package:my_app/screens/Homescreens/lecturer_home_screen.dart';
import 'package:my_app/screens/Homescreens/student_home_screen.dart';
import 'package:my_app/screens/auth/components/announcements_screen.dart';
import 'package:my_app/screens/auth/components/library_screen.dart';
import 'package:my_app/screens/auth/components/reminder_screen.dart';
import 'package:my_app/screens/chats/chats_screen.dart';
import 'package:my_app/screens/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();

  // Initialize local notifications
  initializeNotifications();



  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReminderProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => MessageProvider()),
        ChangeNotifierProvider(create: (context) => AnnouncementProvider()), // Add this line
      ],
      child: const MyApp(),
    ),
  );
}

void initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // Add this line
      title: 'UENR IS HOME',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/student_home': (context) => const StudentHomeScreen(),
        '/lecturer_home': (context) => const LecturerHomeScreen(),
        '/admin_home': (context) => const AdminHomeScreen(),
        '/chats': (context) => const ChatsScreen(isLecturer: false),
        '/library': (context) => const LibraryScreen(isLecturer: false),
        '/announcements': (context) => const AnnouncementsScreen(),
      },
    );
  }
}


 
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SLIC Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ReminderScreen()),
            );
          },
          child: const Text('Go to Reminders'),
        ),
      ),
    );
  }
}

