import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class LecturerHomeScreen extends StatelessWidget {
  const LecturerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lecturer Home')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/chats'),
            child: const Text('Chat'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/library'),
            child: const Text('Library'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles();
              if (result != null) {
                await _uploadFile(result.files.single);
              }
            },
            child: const Text('Upload File to Library'),
          ),
        ],
      ),
    );
  }

  Future<void> _uploadFile(PlatformFile file) async {
    var uri = Uri.parse('YOUR_UPLOAD_URL');
    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', file.path!));
    
    var response = await request.send();
    if (response.statusCode == 200) {
      print('File uploaded successfully');
    } else {
      print('File upload failed');
    }
  }
}
