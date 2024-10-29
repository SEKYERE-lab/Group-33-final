import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class LibraryScreen extends StatelessWidget {
  final bool isLecturer;
  const LibraryScreen({super.key, required this.isLecturer});

  // Add this list of files
  final List<String> files = const ['File 1', 'File 2', 'File 3', 'File 4'];

  // Add this method to handle file upload
  Future<void> _uploadFile(File file) async {
    final url = Uri.parse('YOUR_UPLOAD_URL_HERE');
    var request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    await request.send();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const Text('Available Files:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: files.length,
                  itemBuilder: (context, index) => _buildFileItem(files[index], context),
                ),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: isLecturer
          ? FloatingActionButton(
              child: const Icon(Icons.upload_file),
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles();
                if (result != null) {
                  File file = File(result.files.single.path!);
                  await _uploadFile(file);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Uploaded file: ${result.files.single.name}')),
                  );
                }
              },
            )
          : null,
    );
  }

  Widget _buildFileItem(String fileName, BuildContext context) {
    return ListTile(
      title: Text(fileName),
      trailing: IconButton(
        icon: const Icon(Icons.download),
        onPressed: () async {
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          try {
            final url = Uri.parse('YOUR_DOWNLOAD_URL_HERE/$fileName');
            final response = await http.get(url);
            final dir = await getApplicationDocumentsDirectory();
            final file = File('${dir.path}/$fileName');
            await file.writeAsBytes(response.bodyBytes);
            if (context.mounted) {
              scaffoldMessenger.showSnackBar(
                SnackBar(content: Text('Downloaded $fileName')),
              );
            }
          } catch (e) {
            if (context.mounted) {
              scaffoldMessenger.showSnackBar(
                SnackBar(content: Text('Error downloading $fileName: $e')),
              );
            }
          }
        },
      ),
    );
  }
}
