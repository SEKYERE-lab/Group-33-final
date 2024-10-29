
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/screens/auth/components/sign_in_screen.dart';
import 'package:my_app/screens/chats/chats_screen.dart';
import 'package:my_app/services/api_service.dart';
import 'package:my_app/shared/extentions.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String _username = ''; //Initialize variables
  String _email = '';
  String _password = '';
  String _role = 'Student'; // Default role
  bool _isLoading = false;

  void signUp(String username, String password, String email, String role) async {
    setState(() {
      _isLoading = true;
    });

    final apiService = ApiService();

    try {
      final result = await apiService.signUp(
        username: username,
        password: password,
        email: email,
        role: role,
      );

      if (result['status'] == 'success') {
        // Bypassing the verification screen and navigating to the chat screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ChatsScreen(isLecturer: false),
          ),
        );
      } else {
        context.showError(result['message'] ?? 'Sign up failed');
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(
            hintText: 'Username',
            icon: CupertinoIcons.person,
            onSaved: (value) => _username = value ?? '',
            validator: RequiredValidator(errorText: 'Username is required'),
          ),
          const SizedBox(height: kDefaultPadding),
          _buildTextField(
            hintText: 'Email',
            icon: CupertinoIcons.mail,
            keyboardType: TextInputType.emailAddress,
            onSaved: (value) => _email = value ?? '',
            validator: MultiValidator([
              RequiredValidator(errorText: 'Email is required'),
              EmailValidator(errorText: 'Enter a valid email address'),
            ]),
          ),
          const SizedBox(height: kDefaultPadding),
          _buildTextField(
            hintText: 'Password',
            icon: CupertinoIcons.lock,
            obscureText: true,
            onSaved: (value) => _password = value ?? '',
            validator: MultiValidator([
              RequiredValidator(errorText: 'Password is required'),
              MinLengthValidator(6, errorText: 'Password must be at least 6 characters long'),
            ]),
          ),
          const SizedBox(height: kDefaultPadding),
          _buildRoleDropdown(),
          const SizedBox(height: kDefaultPadding * 1.5),
          _buildSignUpButton(),
          const SizedBox(height: kDefaultPadding),
          _buildSignInLink(),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    required Function(String?) onSaved,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 37, 211, 241)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      onSaved: onSaved,
      validator: validator,
    );
  }

  Widget _buildRoleDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: _role,
          decoration: const InputDecoration(
            prefixIcon: Icon(CupertinoIcons.person_2, color: Color.fromARGB(255, 72, 201, 252)),
            border: InputBorder.none,
          ),
          items: ['Student', 'Lecturer', 'Administrator'].map((role) {
            return DropdownMenuItem<String>(value: role, child: Text(role));
          }).toList(),
          onChanged: (role) => setState(() => _role = role ?? 'Student'),
          onSaved: (role) => _role = role ?? 'Student',
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleSignUp,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 15, 166, 253),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: _isLoading
          ? const CupertinoActivityIndicator(color: Colors.white)
          : const Text('Sign Up', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSignInLink() {
    return TextButton(
      onPressed: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      ),
      child: const Text.rich(
        TextSpan(
          text: 'Already have an account? ',
          children: [TextSpan(text: 'Sign In', style: TextStyle(fontWeight: FontWeight.bold))],
        ),
        style: TextStyle(color: Color.fromARGB(255, 22, 198, 230)),
      ),
    );
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      signUp(_username, _password, _email, _role);
    }
  }

  // ... existing signUp and _showError methods ...
}

