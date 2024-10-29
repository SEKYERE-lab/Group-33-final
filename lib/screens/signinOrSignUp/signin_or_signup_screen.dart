import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/screens/auth/components/sign_up_screen.dart';
import 'package:my_app/screens/chats/chats_screen.dart';

class SigninOrSignupScreen extends StatefulWidget {
  const SigninOrSignupScreen({Key? key}) : super(key: key);

  @override
  _SigninOrSignupScreenState createState() => _SigninOrSignupScreenState();
}

class _SigninOrSignupScreenState extends State<SigninOrSignupScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  late Animation<double> _titleAnimation;
  late Animation<double> _subtitleAnimation;
  late Animation<double> _button1Animation;
  late Animation<double> _button2Animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.2, curve: Curves.easeOut)),
    );

    _titleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.4, curve: Curves.easeOut)),
    );

    _subtitleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.4, 0.6, curve: Curves.easeOut)),
    );

    _button1Animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.6, 0.8, curve: Curves.easeOut)),
    );

    _button2Animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.8, 1.0, curve: Curves.easeOut)),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor.withOpacity(0.1),
                Theme.of(context).primaryColor.withOpacity(0.2),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Column(
              children: [
                const Spacer(flex: 2),
                _buildAnimatedLogo(),
                const SizedBox(height: kDefaultPadding * 2),
                _buildAnimatedTitle(),
                const SizedBox(height: kDefaultPadding),
                _buildAnimatedSubtitle(),
                const Spacer(flex: 2),
                _buildAnimatedButton(
                  animation: _button1Animation,
                  text: "Sign In",
                  onPressed: () => _navigateTo(context, const ChatsScreen(isLecturer: false)),
                  isPrimary: true,
                ),
                const SizedBox(height: kDefaultPadding),
                _buildAnimatedButton(
                  animation: _button2Animation,
                  text: "Sign Up",
                  onPressed: () => _navigateTo(context, const SignUpScreen()),
                  isPrimary: false,
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return FadeTransition(
      opacity: _logoAnimation,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(_logoAnimation),
        child: SvgPicture.asset(
          Theme.of(context).brightness == Brightness.light
              ? "assets/images/Logo_light.svg"
              : "assets/images/Logo_dark.svg",
          height: 100,
        ),
      ),
    );
  }

  Widget _buildAnimatedTitle() {
    return FadeTransition(
      opacity: _titleAnimation,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(_titleAnimation),
        child: Text(
          "Welcome to SLIC",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildAnimatedSubtitle() {
    return FadeTransition(
      opacity: _subtitleAnimation,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(_subtitleAnimation),
        child: Text(
          "Connect with friends and start chatting",
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.64),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildAnimatedButton({
    required Animation<double> animation,
    required String text,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(animation),
        child: TweenAnimationBuilder(
          duration: const Duration(milliseconds: 200),
          tween: Tween<double>(begin: 1, end: 1),
          builder: (context, double value, child) {
            return Transform.scale(
              scale: value,
              child: child,
            );
          },
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Add a subtle scale animation when pressed
                setState(() {});
                Future.delayed(const Duration(milliseconds: 100), () {
                  setState(() {});
                  onPressed();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isPrimary ? const Color.fromARGB(255, 57, 152, 241) : Colors.white,
                foregroundColor: isPrimary ? Colors.white : const Color.fromARGB(255, 57, 143, 241),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: isPrimary ? BorderSide.none : const BorderSide(color: Color.fromARGB(255, 67, 163, 228)),
                ),
                elevation: 0,
              ),
              child: Text(
                text,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
