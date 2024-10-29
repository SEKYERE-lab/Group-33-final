import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/screens/auth/components/sign_in_form.dart';


class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        backgroundColor: const Color.fromARGB(255, 82, 153, 247),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Column(
            children: [
              const SizedBox(height: kDefaultPadding * 2),
              Text(
                'Welcome Back',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: kDefaultPadding),
              const Text(
                'Sign in with your email and password',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: kDefaultPadding * 2),
              const SignInForm(),
            ],
          ),
        ),
      ),
    );
  }
}
