import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/models/Message.dart';
import 'package:my_app/providers/message_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart' as emoji_picker;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:logging/logging.dart' as logging;
import 'package:http/http.dart' as http;

final log = logging.Logger('ChatInputField');

class ChatInputField extends StatefulWidget {
  const ChatInputField({Key? key}) : super(key: key);

  @override
  ChatInputFieldState createState() => ChatInputFieldState();
}

class ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final Uuid uuid = const Uuid();
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();

  bool _showSendButton = false;
  bool _showEmojiPicker = false;
  bool _isRecording = false;
  String? _recordingPath;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    _loadDraft();
    _initializeRecorder();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _recorder.closeRecorder();
    super.dispose();
  }
  Future<void> _initializeRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw Exception('Microphone permission not granted');
    }
    await _recorder.openRecorder();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      setState(() {
        _showEmojiPicker = false;
      });
    }
  }

  void _onTextChanged(String text) {
    setState(() {
      _showSendButton = text.isNotEmpty;
    });
    _saveDraft(text);
  }

  Future<void> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final draft = prefs.getString('messageDraft');
    if (draft != null) {
      setState(() {
        _controller.text = draft;
        _showSendButton = draft.isNotEmpty;
      });
    }
  }

  Future<void> _saveDraft(String text) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('messageDraft', text);
  }

  Future<void> _clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('messageDraft');
  }

  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<String?> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  void _handleSend() async {
    final messageProvider = context.read<MessageProvider>();
    final text = _controller.text.trim();

    if (text.isNotEmpty) {
      final userId = await _getUserId();
      final username = await _getUsername();

      if (userId != null && username != null) {
        final message = Message(
          id: uuid.v4(),
          userId: userId,
          username: username,
          message: text,
          type: 'text',
          createdAt: DateTime.now(),
        );

        messageProvider.sendMessage(message).then((errorMessage) {
          if (errorMessage != null) {
            // Capture the context before any potential async gap
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            // Use addPostFrameCallback to ensure the SnackBar is shown after the current build phase
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                scaffoldMessenger.showSnackBar(
                  SnackBar(content: Text(errorMessage)),
                );
              }
            });
          } else {
            _controller.clear();
            _onTextChanged('');
            _clearDraft();
          }
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to send message. User information not found.')),
          );
        }
      }
    }
  }

  Future<void> _handleAttachment() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      File imageFile = File(image.path);
      await sendImage(imageFile);
      log.info('Image sent: ${imageFile.path}');
    }
  }

  Future<void> _handleVoiceRecording() async {
    if (!_isRecording) {
      _recordingPath = await getTemporaryDirectory().then((dir) => '${dir.path}/audio.aac');
      await _recorder.startRecorder(toFile: _recordingPath);
    } else {
      await _recorder.stopRecorder();
      if (_recordingPath != null) {
        final voiceFile = File(_recordingPath!);
        await sendVoiceMessage(voiceFile);
        log.info('Voice message sent: $_recordingPath');
      } else {
        log.warning('Recording path is null');
      }
    }
    setState(() {
      _isRecording = !_isRecording;
    });
  }

  void _toggleEmojiPicker() {
    setState(() {
      _showEmojiPicker = !_showEmojiPicker;
      if (_showEmojiPicker) {
        FocusScope.of(context).unfocus();
      } else {
        FocusScope.of(context).requestFocus(_focusNode);
      }
    });
  }

  void _onEmojiSelected(Emoji emoji) {
    _controller.text += emoji.emoji;
    _onTextChanged(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding,
            vertical: kDefaultPadding / 2,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, -4),
                blurRadius: 32,
                color: const Color.fromARGB(255, 35, 181, 218).withOpacity(0.08),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                _buildAttachmentButton(),
                const SizedBox(width: kDefaultPadding),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 32, 169, 233).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            _showEmojiPicker ? Icons.keyboard : Icons.sentiment_satisfied_alt_outlined,
                            color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.64),
                          ),
                          onPressed: _toggleEmojiPicker,
                        ),
                        const SizedBox(width: kDefaultPadding / 4),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            focusNode: _focusNode,
                            onChanged: _onTextChanged,
                            decoration: const InputDecoration(
                              hintText: "Type a message",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        _buildVoiceButton(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: kDefaultPadding),
                _buildSendButton(),
              ],
            ),
          ),
        ),
        if (_showEmojiPicker) _buildEmojiPicker(),
      ],
    );
  }

  Widget _buildAttachmentButton() {
    return IconButton(
      icon: Icon(
        CupertinoIcons.paperclip,
        color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.64),
      ),
      onPressed: _handleAttachment,
    );
  }

  Widget _buildVoiceButton() {
    return GestureDetector(
      onLongPress: _handleVoiceRecording,
      onLongPressEnd: (_) => _handleVoiceRecording(),
      child: IconButton(
        icon: Icon(
          _isRecording ? CupertinoIcons.stop_fill : CupertinoIcons.mic_fill,
          color: _isRecording ? Colors.red : Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.64),
        ),
        onPressed: () {},
      ),
    );
  }

  Widget _buildSendButton() {
    return AnimatedOpacity(
      opacity: _showSendButton ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: IconButton(
        icon: const Icon(CupertinoIcons.arrow_up_circle_fill),
        color: kPrimaryColor,
        onPressed: _showSendButton ? _handleSend : null,
      ),
    );
  }

  Widget _buildEmojiPicker() {
    return SizedBox(
      height: 250,
      child: emoji_picker.EmojiPicker(
        onEmojiSelected: (category, emoji) {
          _onEmojiSelected(emoji);
        },
        config: const emoji_picker.Config(
          height: 256,
          emojiViewConfig: emoji_picker.EmojiViewConfig(
            emojiSizeMax: 32.0,
          ),
          categoryViewConfig: emoji_picker.CategoryViewConfig(
            initCategory: emoji_picker.Category.RECENT,
          ),
          bottomActionBarConfig: emoji_picker.BottomActionBarConfig(
            backgroundColor: Color(0xFFF2F2F2),
          ),
          // Note: The following properties are not currently supported in BottomActionBarConfig:
          // indicatorColor, iconColor, iconColorSelected
          // If you need these functionalities, consider implementing a custom solution
          // or checking for updates to the emoji_picker package
          // If you need these functionalities, consider updating the emoji_picker package
          // or implementing custom solutions

          // Removed:
          // progressIndicatorColor: Color.fromARGB(255, 55, 131, 230),
          // backspaceColor: Color.fromARGB(255, 60, 130, 236),
          // skinToneDialogBgColor: Colors.white,
          // skinToneIndicatorColor: Colors.grey,
          // enableSkinTones: true,
          // recentTabBehavior: emoji_picker.RecentTabBehavior.RECENT,
          // recentsLimit: 28,
          // The following properties are not part of the current Config class
          // If you need this functionality, consider implementing a custom solution
          // or checking for updates to the emoji_picker package
          // noRecentsText: 'No Recents',
          // noRecentsStyle: TextStyle(fontSize: 20, color: Colors.black26),
          // categoryIcons: emoji_picker.CategoryIcons(),
          // buttonMode: emoji_picker.ButtonMode.MATERIAL,
        ),
      ),
    );
  }

  Future<void> sendImage(File image) async {
    try {
      // Use the local URL for your XAMPP server
      final url = Uri.parse('http://localhost/my_project/api/upload');

      // Create a multipart request
      var request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('image', image.path));

      // Send the request
      var response = await request.send();

      // Check the response
      if (response.statusCode == 200) {
        log.info('Image sent successfully: ${image.path}');
      } else {
        log.severe('Failed to send image: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send image.')),
        );
      }
    } catch (e) {
      log.severe('Error occurred while sending image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send image.')),
      );
    }
  }

  Future<void> sendVoiceMessage(File voiceFile) async {
    // Implement voice message sending logic here
    // For example:
    // await chatService.sendVoiceMessage(voiceFile);
  }
}
