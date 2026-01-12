import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // State
  double _voiceSpeed = 1.0;
  String _interviewerVoice = 'female'; // 'male' or 'female'
  bool _autoPlayAudio = true;
  bool _darkModeEnabled = false;
  String _language = 'en'; // 'en' or 'es'

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if(mounted) {
      setState(() {
        _voiceSpeed = prefs.getDouble('voice_speed') ?? 1.0;
        _interviewerVoice = prefs.getString('interviewer_voice') ?? 'female';
        _autoPlayAudio = prefs.getBool('auto_play_audio') ?? true;
        _darkModeEnabled = prefs.getBool('dark_mode_enabled') ?? false;
        _language = prefs.getString('language') ?? 'en';
      });
    }
  }

  // --- SAVE HELPERS ---
  Future<void> _saveDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
    setState(() {});
  }
  Future<void> _saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
    setState(() {});
  }
  Future<void> _saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
    setState(() {});
  }

  // --- DANGER ACTIONS ---
  Future<void> _resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Nuclear option
    // Re-auth logic needed? Usually resetting progress clears scores/history but keeps account.
    // Prompt says "Reset Progress: Clears study history".
    // "Delete Account: Requires confirmation".
    
    // For Reset Progress, let's clear local stats.
    if(mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("All progress reset locally.")));
    }
  }

  Future<void> _deleteAccount() async {
     try {
       final user = FirebaseAuth.instance.currentUser;
       if (user != null) {
         await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
         await user.delete();
         if (mounted) Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
       }
     } catch (e) {
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e. (Requires recent login)")));
     }
  }

  @override
  Widget build(BuildContext context) {
    final federalBlue = const Color(0xFF112D50);
    final sectionColor = Colors.grey.shade700;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text("Settings", style: GoogleFonts.publicSans(color: federalBlue, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
            // --- SECTION A: AUDIO INTELLIGENCE ---
            _buildSectionHeader("Audio Intelligence"),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
              child: Column(
                children: [
                   // Voice Speed
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                          Text("Voice Speed", style: GoogleFonts.publicSans(fontWeight: FontWeight.w600)),
                          Text("${_voiceSpeed.toStringAsFixed(1)}x", style: GoogleFonts.publicSans(fontWeight: FontWeight.bold, color: federalBlue)),
                       ],
                     ),
                   ),
                   Slider(
                     value: _voiceSpeed,
                     min: 0.5, max: 1.5, divisions: 10,
                     activeColor: federalBlue,
                     onChanged: (val) {
                       setState(() => _voiceSpeed = val);
                       _saveDouble('voice_speed', val);
                     },
                   ),
                   const Divider(height: 1),
                   
                   // Interviewer Voice (Segmented Control style)
                   Padding(
                     padding: const EdgeInsets.all(16),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text("Interviewer Voice", style: GoogleFonts.publicSans(fontWeight: FontWeight.w600)),
                         Row(
                           children: [
                             _voiceOption("Male", 'male'),
                             const SizedBox(width: 8),
                             _voiceOption("Female", 'female'),
                           ],
                         )
                       ],
                     ),
                   ),
                   const Divider(height: 1),

                   // Auto-Play
                   SwitchListTile(
                     title: Text("Auto-Play Audio", style: GoogleFonts.publicSans(fontWeight: FontWeight.w600)),
                     value: _autoPlayAudio,
                     activeColor: const Color(0xFF00C4B4),
                     onChanged: (val) {
                       setState(() => _autoPlayAudio = val);
                       _saveBool('auto_play_audio', val);
                     },
                   ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- SECTION B: APP PREFERENCES ---
            _buildSectionHeader("App Preferences"),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
              child: Column(
                children: [
                   // Dark Mode
                   SwitchListTile(
                     title: Text("Dark Mode", style: GoogleFonts.publicSans(fontWeight: FontWeight.w600)),
                     value: _darkModeEnabled,
                     activeColor: const Color(0xFF00C4B4),
                     onChanged: (val) {
                       setState(() => _darkModeEnabled = val);
                       _saveBool('dark_mode_enabled', val);
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Theme saved (Reload required)")));
                     },
                   ),
                   const Divider(height: 1),
                   
                   // Language
                   ListTile(
                     title: Text("Language", style: GoogleFonts.publicSans(fontWeight: FontWeight.w600)),
                     trailing: DropdownButtonHideUnderline(
                       child: DropdownButton<String>(
                         value: _language,
                         items: const [
                           DropdownMenuItem(value: 'en', child: Text("English Only")),
                           DropdownMenuItem(value: 'es', child: Text("English + Spanish")),
                         ],
                         onChanged: (val) {
                           if (val != null) {
                             setState(() => _language = val);
                             _saveString('language', val);
                           }
                         },
                       ),
                     ),
                   )
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- SECTION C: DANGER ZONE ---
            _buildSectionHeader("Danger Zone", color: Colors.redAccent),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.red.shade100)),
              child: Column(
                children: [
                   ListTile(
                     title: Text("Reset Study Progress", style: GoogleFonts.publicSans(fontWeight: FontWeight.w600, color: Colors.red)),
                     trailing: const Icon(Icons.refresh, color: Colors.red),
                     onTap: () {
                        // Confirm Dialog
                        _showConfirmDialog("Reset Progress?", "This will clear your local quiz history.", _resetProgress);
                     },
                   ),
                   const Divider(height: 1),
                   ListTile(
                     title: Text("Delete Account", style: GoogleFonts.publicSans(fontWeight: FontWeight.w600, color: Colors.red)),
                     trailing: const Icon(Icons.delete_forever, color: Colors.red),
                     onTap: () {
                        _showConfirmDialog("Delete Account?", "This action is permanent and cannot be undone.", _deleteAccount);
                     },
                   ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _voiceOption(String label, String value) {
    final isSelected = _interviewerVoice == value;
    return GestureDetector(
      onTap: () {
        setState(() => _interviewerVoice = value);
        _saveString('interviewer_voice', value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF112D50) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
      child: Text(title.toUpperCase(), 
        style: GoogleFonts.publicSans(fontSize: 12, fontWeight: FontWeight.bold, color: color ?? Colors.grey.shade600, letterSpacing: 1.2)
      ),
    );
  }
  
  void _showConfirmDialog(String title, String content, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text("Confirm", style: TextStyle(color: Colors.red)),
          )
        ],
      )
    );
  }
}
