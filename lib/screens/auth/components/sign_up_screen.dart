import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/screens/auth/components/sign_up_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Column(
                  children: [
                    SizedBox(height: constraints.maxHeight * 0.08),
                    // Logo
                    SvgPicture.asset(
                      Theme.of(context).brightness == Brightness.dark
                          ? "assets/images/Logo_dark.svg"
                          : "assets/images/Logo_light.svg",
                      height: 120,
                    ),
                    SizedBox(height: constraints.maxHeight * 0.06),
                    // Welcome text
                    Text(
                      'Create an Account',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.02),
                    Text(
                      'Sign up to get started!',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.06),
                    // Sign up form
                    const SignUpForm(),
                    SizedBox(height: constraints.maxHeight * 0.04),
                    // Terms and conditions
                    Text(
                      'By signing up, you agree to our Terms and Privacy Policy',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}