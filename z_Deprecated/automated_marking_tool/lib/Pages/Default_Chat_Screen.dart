import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:automated_marking_tool/Theme/AppTheme.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class MultiLineTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  MultiLineTextField({required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          fontSize: 16,
          color: Color(0xFFAAAAAA),
        ),
      ),
      style: TextStyle(
        color: Theme.of(context).colorScheme.secondary,
      ),
      cursorColor: Theme.of(context).colorScheme.secondary,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
    );
  }
}

class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _textController = TextEditingController();
  List<Message> _chatMessages = [];
  bool hasText = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {
        hasText = _textController.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppTheme.buildAppBar(context, 'Engage with AI', true, "Engage with AI", Text(
        'Start conversing with our AI via the ChatGPT API.\n\n'
        'Explore:\n'
        '1. Seamless communication with an AI.\n'
        '2. Explore the capabilities of the ChatGPT API.\n',
        )),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
              child: Container(
                width: 1600, // Set the width of the Message boxes on the screen.
                child: ListView.builder(
                  itemCount: _chatMessages.length,
                  itemBuilder: (context, index) {
                    final message = _chatMessages[index];
                    return ListTile(
                      title: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20, bottom: 20),
                        decoration: BoxDecoration(
                          color: message.isUser 
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Text(
                          message.text,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          ),
          _buildChatInput(),
        ],
      ),
    );
  }

  Widget _buildChatInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 1200,
          minHeight: 60,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            color: Theme.of(context).colorScheme.primary,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 62.0, top: 4.0, bottom: 8.0),
                    child: MultiLineTextField(
                      controller: _textController,
                      hintText: 'Send a message',
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10.0,
                  right: 10.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: hasText 
                        ? Theme.of(context).colorScheme.tertiary
                        : Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.all(8),
                    child: InkWell(
                      onTap: () {
                        if (_textController.text.isNotEmpty) {
                          _sendMessage();
                        }
                      },
                      child: Icon(
                        Icons.send,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<OpenAIChatCompletionChoiceMessageModel> _getChatHistory() {
    List<OpenAIChatCompletionChoiceMessageModel> history = [];

    for (Message message in _chatMessages) {
      OpenAIChatMessageRole role = message.isUser
          ? OpenAIChatMessageRole.user
          : OpenAIChatMessageRole.assistant;

      OpenAIChatCompletionChoiceMessageModel chatMessage =
          OpenAIChatCompletionChoiceMessageModel(
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(message.text),
        ],
        role: role,
      );

      history.add(chatMessage);
    }

    return history;
  }


  Future<void> _sendMessage() async {
    String userMessage = _textController.text;
    if (userMessage.isNotEmpty) {
      setState(() {
        _chatMessages.add(Message(text: userMessage, isUser: true));
      });
      _textController.clear();

      try {
        final chatCompletion = await OpenAI.instance.chat.create(
          model: "gpt-3.5-turbo-1106", // Your model name here
          messages: _getChatHistory(),
        );

        String aiResponse = chatCompletion.choices.first.message.content != null
            ? chatCompletion.choices.first.message.content!
                .map((item) => item.text)
                .join('\n')
            : ''; // Set a default value if content is null

        setState(() {
          _chatMessages.add(Message(text: aiResponse, isUser: false));
        });
      } catch (e) {
        String aiResponse = "$e";
        setState(() {
          _chatMessages.add(Message(text: aiResponse, isUser: false));
        });
      }
    }
  }
}