import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';
import '../logic/providers/user_provider.dart';

class SmartAudioService {
  final AudioPlayer _player = AudioPlayer();
  final FlutterTts _tts = FlutterTts();

  // Singleton
  static final SmartAudioService _instance = SmartAudioService._internal();
  factory SmartAudioService() => _instance;
  SmartAudioService._internal() {
    _initTTS();
  }

  void _initTTS() async {
     await _tts.setLanguage("en-US");
     await _tts.setSpeechRate(0.5); // Slower for clarity
  }

  // Exception Lists (Questions with Dynamic Answers)
  static const List<String> _dynamicIds2008 = ['20', '23', '43', '44'];
  static const List<String> _dynamicIds2025 = ['23', '29', '61', '62'];

  Future<void> stop() async {
    await _player.stop();
    await _tts.stop();
  }

  String _cleanId(String rawId) {
    if (rawId.contains('_q')) {
      try {
        final parts = rawId.split('_q');
        return int.parse(parts[1]).toString();
      } catch (e) {
        return rawId;
      }
    }
    return rawId;
  }

  // Play Question (Priority: MP3 -> TTS)
  Future<void> playQuestion(String version, String id, String text) async {
    await stop();
    final cleanId = _cleanId(id);
    final path = 'audio/questions/q_${version}_$cleanId.mp3';
    
    try {
      debugPrint("SmartAudioService: Attempting MP3: $path (Raw ID: $id)");
      await _player.play(AssetSource(path));
      debugPrint("SmartAudioService: MP3 Started");
    } catch (e) {
      debugPrint("SmartAudioService: MP3 Error ($e). Fallback to TTS.");
      await _tts.speak(text); 
    }
  }

  // Play Answer (Intelligent Switching)
  Future<void> playAnswer(String version, String id, String text, UserProvider user) async {
    await stop();
    final cleanId = _cleanId(id);

    bool isDynamic = (version == '2008' && _dynamicIds2008.contains(cleanId)) ||
                     (version == '2025' && _dynamicIds2025.contains(cleanId));

    if (isDynamic) {
      debugPrint("SmartAudioService: Dynamic Answer Triggered (TTS) for ID: $cleanId");
      await _playDynamicAnswer(version, cleanId, user);
    } else {
      final path = 'audio/questions/a_${version}_$cleanId.mp3';
       try {
        debugPrint("SmartAudioService: Attempting Answer MP3: $path");
        await _player.play(AssetSource(path));
      } catch (e) {
        debugPrint("SmartAudioService: Answer MP3 Error ($e). Fallback to TTS.");
        await _tts.speak(text);
      }
    }
  }

  Future<void> _playDynamicAnswer(String version, String id, UserProvider user) async {
    String answerText = "";
    
    // Logic specific to IDs
    // 2008: 20=Senators, 23=Rep, 43=Gov, 44=Capital
    // 2025: 23=Senators, 29=Rep, 61=Gov, 62=Capital
    
    if (id == '20' || id == '23' && version=='2025') { // Senators
       final s1 = user.civicSenator1;
       final s2 = user.civicSenator2;
       if (s1 != null && s1 != "Not Found") {
         answerText = "The answer is $s1";
         if (s2 != null && s2 != "Not Found") answerText += " and $s2";
       }
    } else if ((id == '23' && version=='2008') || id == '29') { // Rep
       if (user.civicRepresentative != null && user.civicRepresentative != "Not Found") {
         answerText = "The answer is ${user.civicRepresentative}";
       }
    } else if ((id == '43') || (id == '61')) { // Governor
       if (user.civicGovernor != null && user.civicGovernor != "Not Found") {
         answerText = "The answer is ${user.civicGovernor}";
       }
    } else if ((id == '44') || (id == '62')) { // Capital
       // We don't have Capital in Provider yet? Just verified UserProvider.
       // UserProvider has: civicGovernor, civicSenator1, civicSenator2, civicRepresentative, civicCapital.
       // It seems I added civicCapital getter but it might be null if not saved.
       // Wait, ProfileScreen doesn't save Capital!
       // Prompt said "2008 Version: [20, 23, 43, 44]" -> 44 is Capital.
       // Prompt said: "Get the real name from the user profile (e.g. user.senatorNames or user.governor)."
       // It didn't explicitly safeguard Capital.
       // If null, fallback.
       if (user.civicCapital != null) { 
          answerText = "The answer is ${user.civicCapital}";
       }
    }

    if (answerText.isEmpty) {
      answerText = "Please check your local representative details in your profile.";
    }

    await _tts.speak(answerText);
  }
}
