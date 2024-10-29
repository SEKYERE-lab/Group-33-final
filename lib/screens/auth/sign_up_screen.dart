import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/screens/auth/components/sign_up_form.dart';


class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: kPrimaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Column(
            children: [
              const SizedBox(height: kDefaultPadding * 2),
              Text(
                'Create Account',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: kDefaultPadding),
              const Text(
                'Sign up to get started',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: kDefaultPadding * 2),
              const SignUpForm(),
            ],
          ),
        ),
      ),
    );
  }
}