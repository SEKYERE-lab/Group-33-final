import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/screens/auth/components/forgot_password_screen.dart';
import 'package:my_app/screens/chats/chats_screen.dart';
import 'package:my_app/services/api_service.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  String _userType = 'Student';
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextField(
            hintText: 'Username',
            icon: CupertinoIcons.person,
            onSaved: (value) => _username = value ?? '',
          ),
          const SizedBox(height: kDefaultPadding),
          _buildTextField(
            hintText: 'Password',
            icon: CupertinoIcons.lock,
            obscureText: _obscurePassword,
            onSaved: (value) => _password = value ?? '',
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                color: Colors.grey,
              ),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
          const SizedBox(height: kDefaultPadding),
          _buildUserTypeDropdown(),
          const SizedBox(height: kDefaultPadding * 1.5),
          _buildSignInButton(),
          const SizedBox(height: kDefaultPadding),
          _buildForgotPasswordButton(),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    required Function(String?) onSaved,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 32, 164, 216)),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      obscureText: obscureText,
      onSaved: onSaved,
      validator: (value) => value?.isEmpty ?? true ? '$hintText is required' : null,
    );
  }

  Widget _buildUserTypeDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: _userType,
          decoration: const InputDecoration(
            prefixIcon: Icon(CupertinoIcons.person_2, color: Color.fromARGB(255, 25, 171, 216)),
            border: InputBorder.none,
          ),
          items: ['Student', 'Lecturer', 'Administrator'].map((String role) {
            return DropdownMenuItem<String>(value: role, child: Text(role));
          }).toList(),
          onChanged: (value) => setState(() => _userType = value!),
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleSignIn,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 44, 139, 218),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: _isLoading
          ? const CupertinoActivityIndicator(color: Colors.white)
          : const Text('Sign In', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildForgotPasswordButton() {
    return TextButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
      ),
      child: Text(
        'Forgot Password?',
        style: TextStyle(color: const Color.fromARGB(255, 51, 163, 228).withOpacity(0.8)),
      ),
    );
  }

  void _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);
      try {
        final apiService = ApiService();
        final success = await apiService.signIn(
          email: _username, // Changed from username to email
          password: _password,
          role: _userType,
        );
        if (success['status'] == true) {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const ChatsScreen(isLecturer: true)),
            );
          }
        } else {
          _showError('Invalid credentials. Please try again.');
        }
      } catch (e) {
        _showError('An error occurred. Please try again later.');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  // ... existing signUp and _showError methods ...
}
