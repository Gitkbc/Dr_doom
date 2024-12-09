import 'package:speech_to_text/speech_to_text.dart';

class WakeWordService {
  final SpeechToText _speechToText = SpeechToText();

  Future<void> initializeWakeWord() async {
    bool available = await _speechToText.initialize();
    if (!available) {
      print('Speech recognition not available.');
      return;
    }

    _speechToText.listen(onResult: (result) {
      if (result.recognizedWords.toLowerCase() == "hey doom") {
        print("Wake word detected!");
        // Trigger the assistant
      }
    });
  }

  void stopListening() {
    _speechToText.stop();
  }
}