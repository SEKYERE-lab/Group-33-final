import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_app/repositories/user_repository.dart';

class UserProvider with ChangeNotifier {
  final _userRepository = UserRepository();

  bool _isLoading = false;
  dynamic _currentUser;

  bool get isLoading => _isLoading;
  dynamic get currentUser => _currentUser;

  void _setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<Either<String, bool>> signUp({
    required String username,
    required String password,
    required String email,
    required String userType,
  }) async {
    _setIsLoading(true);
    final response = await _userRepository.signUp(
      username: username,
      email: email,
      password: password,
      role: userType,
    );
    _setIsLoading(false);

    // If sign-up is successful, navigate to the desired screen
  if (response.isRight()) {
    _currentUser = await _userRepository.getCurrentUser();
  }
  
    return response;
  }

  Future<Either<String, bool>> signIn({
    required String username,
    required String password,
    required String userType,
  }) async {
    _setIsLoading(true);
    final response = await _userRepository.signIn(
      username: username,
      password: password,
      role: userType,
    );
    if (response.isRight()) {
      _currentUser = await _userRepository.getCurrentUser(); // Update this as needed
    }
    _setIsLoading(false);
    return response;
  }

  Future<dynamic> checkedLoggedInUser() async {
    final authSession = await _userRepository.isUserLoggedIn();

    if (authSession) {
      _currentUser = await _userRepository.getCurrentUser();
      return _currentUser;
    }
    return null;
  }

  Future<Either<String, bool>> signOut() async {
    _setIsLoading(true);
    try {
      await _userRepository.signOut();
      _currentUser = null;
      _setIsLoading(false);
      return right(true);
    } catch (e) {
      _setIsLoading(false);
      return left('Failed to sign out');
    }
  }

  // Added confirmSignUp method for OTP verification
  Future<Either<String, bool>> confirmSignUp({
    required String username,
    required String code,
  }) async {
    const url = 'http://localhost/slic_api/verify_otp.php';

    try {
      _setIsLoading(true);

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'otp_code': code}),
      );

      final responseData = json.decode(response.body);
      _setIsLoading(false);

      if (responseData['success']) {
        return right(true); // Verification successful
      } else {
        return left(responseData['message']); // Verification failed with a message
      }
    } catch (error) {
      _setIsLoading(false);
      return left(error.toString()); // Return the error as a failure
    }
  }
}
