import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'dart:convert';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String API_URL = 'https://api.openai.com/v1/chat/completions';
const String OPENAI_API_KEY = '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'; // Replace with your OpenAI API Key

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatUser _user = ChatUser(
    id: '1',
    firstName: 'Charles',
    lastName: 'Leclerc',
  );

  final ChatUser _gptChatUser = ChatUser(
    id: '2',
    firstName: 'Dr',
    lastName: 'Doom',
  );

  final List<ChatMessage> _messages = <ChatMessage>[];
  final List<ChatUser> _typingUsers = <ChatUser>[];

  @override
  void initState() {
    super.initState();
    _messages.add(
      ChatMessage(
        text: 'Hey!',
        user: _user,
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 166, 126, 1),
        title: const Text(
          'Dr Doom',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: DashChat(
        currentUser: _user,
        messageOptions: const MessageOptions(
          currentUserContainerColor: Colors.black,
          containerColor: Color.fromRGBO(0, 166, 126, 1),
          textColor: Colors.white,
        ),
        onSend: (ChatMessage m) {
          getChatResponse(m);
        },
        messages: _messages,
        typingUsers: _typingUsers,
      ),
    );
  }

  Future<void> getChatResponse(ChatMessage m) async {
    setState(() {
      _messages.insert(0, m); // Insert the user's message into the list
      _typingUsers.add(_gptChatUser); // Show that the GPT is typing
    });

    // Prepare the messages history in the required format
 List<Map<String, dynamic>> messagesHistory = _messages.reversed.toList().map((m) {
  return {
    "role": m.user == _user ? "user" : "assistant",
    "content": m.text,
  };
}).toList();


    final requestBody = json.encode({
      'model': 'gpt-3.5-turbo',
      'messages': messagesHistory,
      'max_tokens': 200,
    });

    try {
      final response = await http.post(
        Uri.parse(API_URL),
        headers: {
          'Authorization': 'Bearer $OPENAI_API_KEY',
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        for (var choice in responseData['choices']) {
          final content = choice['message']['content'];
          setState(() {
            _messages.insert(
              0,
              ChatMessage(
                user: _gptChatUser,
                createdAt: DateTime.now(),
                text: content,
              ),
            );
          });
        }
      } else {
        print("Error: ${response.statusCode}: ${response.body}");
      }
    } catch (error) {
      print("Error fetching chat response: $error");
    } finally {
      setState(() {
        _typingUsers.remove(_gptChatUser); 
      });
    }
  }
}
