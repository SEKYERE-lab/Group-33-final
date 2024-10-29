import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';

class UserRepository {
 final String apiUrl = 'http://localhost/slic_api/users'; // Adjust this URL as needed

  Future<Either<String, bool>> signUp({
    required String username,
    required String password,
    required String email,
    required String role,
       }) async {
        try {
      final response = await http.post(
        Uri.parse('$apiUrl/sign_up'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'email': email,
          'password': password,
          'role': role,
        }),
    
    );

    if (response.statusCode == 200) {
        return right(true);
      } else {
        return left('Failed to sign up');
      }
    } catch (e) {
      return left('An error occurred');
    }
  }

Future<Either<String, bool>> confirmSignUp({
  required String username,
   required String code,
   }) async {
  try {
    final response = await http.post(
        Uri.parse('$apiUrl/confirm_sign_up'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'code': code,
        }),
      );

      if (response.statusCode == 200) {
        return right(true); // Adjust based on response
      } else {
        return left('Failed to confirm sign up');
      }
    } catch (e) {
      return left('An error occurred');
    }
  }


Future<Either<String, bool>> signIn({
  required String username,
   required String password,
    required String role,
    }) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/sign_in'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
          'role': role,
        }),
      );

      if (response.statusCode == 200) {
        return right(true); // Adjust based on response
      } else {
        return left('Failed to sign in');
      }
    } catch (e) {
      return left('An error occurred');
    }
  }


Future<bool> isUserLoggedIn() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/is_logged_in'));

      if (response.statusCode == 200) {
        return json.decode(response.body)['isLoggedIn']; // Adjust based on response
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/current_user'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<Either<String, bool>> signOut() async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/sign_out'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return right(true);
      } else {
        return left('Failed to sign out');
      }
    } catch (e) {
      return left('An error occurred');
    }
  }
}
