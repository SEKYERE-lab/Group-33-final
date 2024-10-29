import 'package:flutter/material.dart';
import 'package:my_app/models/Chat.dart';
import 'package:my_app/providers/user_provider.dart';
import 'package:my_app/screens/messages/message_screen.dart';
import 'package:my_app/screens/signinOrSignUp/signin_or_signup_screen.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background image (unchanged)
            Image.asset(
              "assets/images/welcome_image.jpg",
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            // Animated gradient overlay
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            // Animated content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "UENR SLIC\nMESSAGING APP",
                            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Where education meets innovation.\nLet every conversation count.",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 48),
                          FutureBuilder<dynamic>(
                            future: context.read<UserProvider>().checkedLoggedInUser(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                if (snapshot.data != null) {
                                  _navigateToMessagesScreen(context);
                                  return const SizedBox.shrink();
                                } else {
                                  return _buildGetStartedButton(context);
                                }
                              }
                              return const Center(child: CircularProgressIndicator());
                            },
                          ),
                          const SizedBox(height: 48),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGetStartedButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SigninOrSignupScreen(),
          ),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Theme.of(context).primaryColor, backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          "Continue",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _navigateToMessagesScreen(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 1),
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => MessagesScreen(
                chat: Chat(
                  id: "1",
                  name: "Default Chat",
                  lastMessage: "Welcome back!",
                  timestamp: DateTime.now(),
                  image: "assets/images/user.png",
                  isRead: false,
                  isActive: true,
                ),
              ),
            ),
            (route) => false,
          );
        });
      },
    );
  }
}
