enum ChatMessageType { text, audio, image, video }

enum MessageStatus { not_sent, not_view, viewed }

class ChatMessage {
  final String username;
  final String text;
  final ChatMessageType messageType;
  final MessageStatus messageStatus;
  final bool isSender;

  ChatMessage({
    this.text = '',
    required this.messageType,
    required this.messageStatus,
    required this.isSender,
    required this.username,
  });

  get message => null;
}

List demeChatMessages = [
  ChatMessage(
    text: "Hi Nana,",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.viewed,
    isSender: false,
    username: '',
  ),
  ChatMessage(
    text: "Hello, How are you?",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.viewed,
    isSender: true,
    username: '',
  ),
  ChatMessage(
    text: "",
    messageType: ChatMessageType.audio,
    messageStatus: MessageStatus.viewed,
    isSender: false,
    username: '',
  ),
  ChatMessage(
    text: "",
    messageType: ChatMessageType.video,
    messageStatus: MessageStatus.viewed,
    isSender: true,
    username: '',
  ),
  ChatMessage(
    text: "Error happend",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.not_sent,
    isSender: true,
    username: '',
  ),
  ChatMessage(
    text: "This looks great man!!",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.viewed,
    isSender: false,
    username: '',
  ),
  ChatMessage(
    text: "Glad you like it",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.not_view,
    isSender: true,
    username: '',
  ),
];
