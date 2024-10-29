import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/constants.dart';
import 'package:my_app/screens/auth/components/logo_with_title.dart';
import 'package:my_app/screens/chats/chats_screen.dart';
import 'package:my_app/shared/extentions.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key, required this.username})
      : super(key: key);

  final String username;

  @override
  VerificationScreenState createState() => VerificationScreenState();
  
}

class VerificationScreenState extends State<VerificationScreen> {
  final _formkey = GlobalKey<FormState>();
  late String _otpCode;
  late bool _isLoading;
  
  @override
  void initState() {
    super.initState();
    _isLoading = false;
  }

  Future<bool> verifyOTP(String username, String code) async {
    const url = 'http://localhost/slic_api/verify_otp.php'; // Update with your XAMPP API URL
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'otp': code}),
      );
      if (response.statusCode == 200) {
        // Assuming the API returns a JSON with a success field
        final responseData = jsonDecode(response.body);
        return responseData['success'] == true;
      } else {
        return false;
      }
    } catch (error) {
      print("Error verifying OTP: $error");
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LogoWithTitle(
        title: 'Verification',
        subText: "Verification code has been sent to your mail",
        children: [
           const SizedBox(height: kDefaultPadding),
          Form(
            key: _formkey,
            child: TextFormField(
              onSaved: (otpCode) {
                _otpCode = otpCode!;
              },
               validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the OTP code';
                }
                return null;
               },
       keyboardType: TextInputType.number,
              textInputAction: TextInputAction.send,
              decoration: const InputDecoration(hintText: "Enter OTP"),
            ),
          ),
          
          const SizedBox(height: kDefaultPadding),
          ElevatedButton(
            onPressed: () async {
              if (_formkey.currentState!.validate()) {
                _formkey.currentState!.save();
                setState(() {
                  _isLoading = true;
                });

                bool isVerified = await verifyOTP(widget.username, _otpCode);

                setState(() {
                  _isLoading = false;
                });

                if (isVerified) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  const ChatsScreen(isLecturer: false),
  ),
  (route) => false,
);
                } else {
                  context.showError("Invalid OTP. Please try again.");
                }
              }
            },
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Validate"),
          ),
        ],
      ),
    );
  }
} 