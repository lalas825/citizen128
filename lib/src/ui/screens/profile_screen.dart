import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // State Variables
  final TextEditingController _nameController = TextEditingController();
  DateTime? _examDate;
  double _voiceSpeed = 1.0;
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  // Load Data from SharedPreferences
  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('user_name') ?? "";
      
      final dateStr = prefs.getString('exam_date');
      if (dateStr != null) {
        _examDate = DateTime.tryParse(dateStr);
      }

      _voiceSpeed = prefs.getDouble('voice_speed') ?? 1.0;
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _darkModeEnabled = prefs.getBool('dark_mode_enabled') ?? false;
      
      _isLoading = false;
    });
  }

  // Save Data Helpers
  Future<void> _saveName(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', value);
    // Trigger rebuild to update Avatar
    setState(() {});
  }

  Future<void> _saveExamDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('exam_date', date.toIso8601String());
    setState(() {
      _examDate = date;
    });
  }

  Future<void> _saveVoiceSpeed(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('voice_speed', value);
    setState(() {
      _voiceSpeed = value;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
    setState(() {
      _notificationsEnabled = value;
    });
  }

  Future<void> _toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode_enabled', value);
    setState(() {
      _darkModeEnabled = value;
    });
    // Note: To make this effectively change the app theme, 
    // we would need a ThemeProvider or callback to main.dart.
    // For now, it just saves the preference.
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Theme preference saved (Refresh needed)")));
  }

  Future<void> _resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    // Clear Score / Stats related keys but KEEP Profile settings
    await prefs.remove('voice_seen_ids');
    await prefs.remove('voice_seen_ids_2008');
    await prefs.remove('stats_data');
    await prefs.remove('incorrect_ids');
    
    // Optional: Clear specific keys instead of clear() to avoid losing name/date
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("All quiz progress has been reset!"),
          backgroundColor: Colors.redAccent,
        )
      );
    }
  }

  // Logic: Calculate Days Until Exam
  String _getDaysUntilExam() {
    if (_examDate == null) return "";
    final now = DateTime.now();
    // Reset time to midnight for accurate day comparison
    final today = DateTime(now.year, now.month, now.day);
    final exam = DateTime(_examDate!.year, _examDate!.month, _examDate!.day);
    final difference = exam.difference(today).inDays;

    if (difference < 0) return "Included Exam Date"; // Or "Exam Passed"
    return "$difference Days Until Interview";
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Colors
    final Color federalBlue = const Color(0xFF112D50);
    final Color sectionTitleColor = Colors.grey.shade700;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text("Study Command Center", 
          style: GoogleFonts.publicSans(color: federalBlue, fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, 
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             // --- HEADER SECTION ---
             Center(
               child: Column(
                 children: [
                   CircleAvatar(
                     radius: 50,
                     backgroundColor: federalBlue.withOpacity(0.1),
                     child: Text(
                       _nameController.text.isNotEmpty ? _nameController.text[0].toUpperCase() : "U",
                       style: GoogleFonts.publicSans(fontSize: 40, color: federalBlue, fontWeight: FontWeight.bold),
                     ),
                   ),
                   const SizedBox(height: 16),
                   // Editable Name
                   TextField(
                     controller: _nameController,
                     textAlign: TextAlign.center,
                     style: GoogleFonts.publicSans(fontSize: 22, fontWeight: FontWeight.bold, color: federalBlue),
                     decoration: const InputDecoration(
                       hintText: "Enter Your Name",
                       border: InputBorder.none,
                       hintStyle: TextStyle(color: Colors.grey)
                     ),
                     onChanged: _saveName, // Auto-save on type
                   ),
                 ],
               ),
             ),
             const SizedBox(height: 32),

             // --- COUNTDOWN WIDGET ---
             if (_examDate != null)
               Container(
                 width: double.infinity,
                 padding: const EdgeInsets.all(16),
                 margin: const EdgeInsets.only(bottom: 32),
                 decoration: BoxDecoration(
                   gradient: LinearGradient(colors: [federalBlue, federalBlue.withOpacity(0.8)]),
                   borderRadius: BorderRadius.circular(16),
                   boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))]
                 ),
                 child: Column(
                   children: [
                      Text(
                        _getDaysUntilExam(),
                        style: GoogleFonts.publicSans(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat.yMMMMd().format(_examDate!),
                        style: GoogleFonts.publicSans(color: Colors.white70, fontSize: 14),
                      )
                   ],
                 ),
               ),

             // --- EXAM DETAILS ---
             Text("EXAM DETAILS", style: GoogleFonts.publicSans(color: sectionTitleColor, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1.2)),
             const SizedBox(height: 8),
             Card(
               elevation: 0,
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
               child: ListTile(
                 leading: const Icon(Icons.calendar_today, color: Colors.blueAccent),
                 title: Text(_examDate == null ? "Set Exam Date" : DateFormat.yMMMMd().format(_examDate!), 
                   style: GoogleFonts.publicSans(fontWeight: FontWeight.w600)
                 ),
                 subtitle: const Text("Tap to select your interview date"),
                 trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                 onTap: () async {
                   final DateTime? picked = await showDatePicker(
                     context: context,
                     initialDate: _examDate ?? DateTime.now().add(const Duration(days: 30)),
                     firstDate: DateTime.now(),
                     lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                   );
                   if (picked != null) {
                     _saveExamDate(picked);
                   }
                 },
               ),
             ),
             const SizedBox(height: 32),

             // --- SETTINGS ---
             Text("SETTINGS", style: GoogleFonts.publicSans(color: sectionTitleColor, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1.2)),
             const SizedBox(height: 8),
             Card(
               elevation: 0,
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
               child: Column(
                 children: [
                   // Voice Speed
                   Padding(
                     padding: const EdgeInsets.all(16.0),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                               Text("Interviewer Voice Speed", style: GoogleFonts.publicSans(fontWeight: FontWeight.w600)),
                               Text("${_voiceSpeed.toStringAsFixed(1)}x", style: GoogleFonts.publicSans(fontWeight: FontWeight.bold, color: federalBlue)),
                           ],
                         ),
                         Slider(
                           value: _voiceSpeed,
                           min: 0.5,
                           max: 1.5,
                           divisions: 10,
                           activeColor: federalBlue,
                           onChanged: _saveVoiceSpeed,
                         ),
                       ],
                     ),
                   ),
                   const Divider(height: 1),
                   
                   // Notifications
                   SwitchListTile(
                     title: Text("Daily Reminders", style: GoogleFonts.publicSans(fontWeight: FontWeight.w600)),
                     subtitle: const Text("Get study reminders at 9:00 AM"),
                     value: _notificationsEnabled,
                     activeColor: const Color(0xFF00C4B4),
                     onChanged: _toggleNotifications,
                   ),
                    const Divider(height: 1),

                   // Dark Mode
                   SwitchListTile(
                     title: Text("Dark Mode", style: GoogleFonts.publicSans(fontWeight: FontWeight.w600)),
                     value: _darkModeEnabled,
                     activeColor: const Color(0xFF00C4B4),
                     onChanged: _toggleDarkMode,
                   ),
                 ],
               ),
             ),
             const SizedBox(height: 32),

             // --- DANGER ZONE ---
             Text("DANGER ZONE", style: GoogleFonts.publicSans(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1.2)),
             const SizedBox(height: 8),
             SizedBox(
               width: double.infinity,
               child: OutlinedButton(
                 onPressed: () {
                   showDialog(
                     context: context, 
                     builder: (context) => AlertDialog(
                       title: const Text("Reset All Progress?"),
                       content: const Text("This will delete all quiz scores and history. Your name and interview date will be kept."),
                       actions: [
                         TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                         TextButton(
                           onPressed: () {
                             _resetProgress();
                             Navigator.pop(context);
                           }, 
                           child: const Text("Reset", style: TextStyle(color: Colors.red))
                          ),
                       ],
                     )
                   );
                 },
                 style: OutlinedButton.styleFrom(
                   foregroundColor: Colors.red,
                   side: const BorderSide(color: Colors.red),
                   padding: const EdgeInsets.symmetric(vertical: 16),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                 ),
                 child: Text("Reset All Progress", style: GoogleFonts.publicSans(fontWeight: FontWeight.bold)),
               ),
             ),
             const SizedBox(height: 40),
           ],
        ),
      ),
    );
  }
}
