import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AcademicTrackerButton extends StatelessWidget {
  final ApiService apiService;

  const AcademicTrackerButton({Key? key, required this.apiService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Academic Tracker'),
      onPressed: () async {
        try {
          await apiService.launchPortal();
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open the portal. Please try again later.')),
          );
        }
      },
    );
  }
}
