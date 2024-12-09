import 'package:audioplayers/audioplayers.dart';
import 'package:doom/pages/chat_page.dart';
import 'package:doom/pages/news.dart';
import 'package:doom/pages/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui'; 
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomePage extends StatefulWidget {
  final AudioPlayer _audioPlayer = AudioPlayer();

  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  String? userName;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = ''; 
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _hasPlayedAudio = false; 
  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
    _fetchUserName();
  }

  Future<void> _playAudio() async {
    await widget._audioPlayer.play(AssetSource('images/dr_doom.mp3'));
    widget._audioPlayer.onPlayerComplete.listen((_) {
      widget._audioPlayer.stop();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    widget._audioPlayer.dispose(); 
    super.dispose();
  }

  void _fetchUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userName = user.displayName ?? 'User Name';
      });
    } else {
      setState(() {
        userName = 'User Name'; 
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
   
    if (index == 1) {
      Navigator.pushNamed(context, '/data'); 
    }
    if (index == 2) {
      _listen(); 
    }
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NewsPage()),
      );
    }
    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _controller.repeat(); 
        _speech.listen(onResult: (val) => setState(() {
          _text = val.recognizedWords; 
          Future.delayed(const Duration(seconds: 5), () {
            setState(() {
              _text = ''; 
            });
          });
        }));
      }
    } else {
      setState(() => _isListening = false);
      _controller.stop(); 
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x00d8c3a5),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = MediaQuery.of(context).size.width;
          double scaledFontSize = screenWidth * 0.1;

          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/Doctor.gif'),
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ChatPage()), // Navigate to ChatPage
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: Colors.white), // Search icon
                          SizedBox(width: 10),
                          Text(
                            'Search',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 120,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'HELLO',
                        style: TextStyle(
                          fontSize: scaledFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          shadows: [
                            Shadow(
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ],
                        ),
                      ),
                      // Display the user's name below "HELLO"
                      Text(
                        'Welcome, $userName!',
                        style: TextStyle(
                          fontSize: scaledFontSize * 0.5, // Smaller size for the username
                          fontWeight: FontWeight.w400,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!_hasPlayedAudio) {
            _playAudio();
            _hasPlayedAudio = true;
          }
        },
        backgroundColor: Colors.blueGrey.shade700, 
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50), 
          child: Image.asset(
            'assets/images/Doctor Doom Tattoo.jpeg',
            fit: BoxFit.cover, 
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueGrey.shade600,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildNavBarItem(CupertinoIcons.home, 'Home', 0),
            buildNavBarItem(CupertinoIcons.book, 'Data', 1),
            buildNavBarItem(CupertinoIcons.mic, 'Dr. Doom', 2), 
            buildNavBarItem(CupertinoIcons.news, 'News', 3),
            buildNavBarItem(CupertinoIcons.profile_circled, 'Profile', 4),
          ],
        ),
      ),
    );
  }

  Widget buildNavBarItem(IconData icon, String label, int index) {
    return InkWell(
      onTap: () => _onItemTapped(index), 
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(height: 5),
          Text(label),
        ],
      ),
    );
  }
}
