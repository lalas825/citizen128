import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/stats_service.dart';
import 'quiz_screen.dart';
import 'review_errors_screen.dart';
import 'study_screen.dart';
import 'profile_screen.dart';
import 'n400_vocab_screen.dart'; // Import for N-400

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  // Dashboard State
  double _passProbability = 0.0;
  String _statusLabel = "Start Practicing";
  bool _isPassed = false;
  Color _statusColor = Colors.grey;

  final List<Widget> _screens = [
     Container(), // Placeholder for Dashboard (index 0)
     const StudyScreen(),
     const ProfileScreen(),
  ];

  String _userName = "";

  @override
  void initState() {
    super.initState();
    _loadStats();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? "";
    });
  }

  Future<void> _loadStats() async {
    final stats = await StatsService.getStats();
    // Also reload name in case it changed in Profile tab
    final prefs = await SharedPreferences.getInstance(); 
    
    if (!mounted) return;
    setState(() {
      _userName = prefs.getString('user_name') ?? "";
      _passProbability = stats['average_score'];
      _isPassed = stats['passed'];
      
      if (stats['total_attempts'] == 0) {
        _statusLabel = "Start Practicing";
        _statusColor = Colors.grey;
      } else {
        _statusLabel = _isPassed ? "Passed" : "Failed";
        _statusColor = _isPassed ? const Color(0xFF00C4B4) : Colors.redAccent;
      }
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Reload stats/name when switching back to home
    if (index == 0) {
      _loadStats();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color federalBlue = const Color(0xFF112D50);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildDashboard(), // Index 0
          const StudyScreen(), // Index 1
          const ProfileScreen(), // Index 2
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: federalBlue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: "Study"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    final Color federalBlue = const Color(0xFF112D50);
    final Color libertyGreen = const Color(0xFF00C4B4);
    final Color bgLight = const Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: bgLight,
      appBar: AppBar(
        backgroundColor: bgLight,
        elevation: 0,
        title: Text("Dashboard",
            style: GoogleFonts.publicSans(
                color: federalBlue, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh, color: federalBlue), 
              onPressed: _loadStats)
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // PROFILE HEADER
            Row(
              children: [
                CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey.shade300,
                    child: Text(
                       _userName.isNotEmpty ? _userName[0].toUpperCase() : "U",
                       style: GoogleFonts.publicSans(fontSize: 24, fontWeight: FontWeight.bold, color: federalBlue),
                    )),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_userName.isNotEmpty ? "Hi, $_userName" : "Welcome back,",
                        style: GoogleFonts.publicSans(
                            color: federalBlue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    Text("Preparing for 2025 Version",
                        style: GoogleFonts.publicSans(
                            color: Colors.grey, fontSize: 14)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),

            // PASS PROBABILITY (Dynamic)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 10)
                  ]),
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                            value: _passProbability,
                            strokeWidth: 12,
                            backgroundColor: Colors.grey.shade200,
                            color: _isPassed ? libertyGreen : (_passProbability > 0 ? Colors.redAccent : Colors.grey)),
                        Center(
                            child: Text("${(_passProbability * 100).toInt()}%",
                                style: GoogleFonts.publicSans(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: federalBlue))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(_statusLabel,
                      style: GoogleFonts.publicSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _statusColor)),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // ACTION CARDS (GRID LAYOUT)
            Column(
              children: [
                // ROW 1: The Main Tests
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const QuizScreen()),
                          ).then((_) => _loadStats());
                        },
                        child: _buildActionCard(
                          icon: Icons.assignment,
                          color: Colors.green,
                          title: "Civics Quiz",
                          subtitle: "Practice Mode",
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/voice')
                              .then((_) => _loadStats());
                        },
                        child: _buildActionCard(
                          icon: Icons.mic,
                          color: Colors.blue,
                          title: "Oral Quiz",
                          subtitle: "Exam",
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ROW 2: Study Tools
                Row(
                  children: [
                    // 1. Review Errors
                    Expanded(
                      child: GestureDetector(
                         onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ReviewErrorsScreen()),
                          ).then((_) => _loadStats());
                        },
                        child: _buildActionCard(
                          icon: Icons.warning_amber_rounded,
                          color: Colors.orange,
                          title: "Review Errors",
                          subtitle: "Fix Mistakes",
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // 2. N-400 Vocabulary
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const N400VocabScreen()),
                          );
                        },
                        child: _buildActionCard(
                          icon: Icons.menu_book,
                          color: Colors.deepOrangeAccent,
                          title: "N-400 Vocab",
                          subtitle: "Definitions",
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget for the Cards
  Widget _buildActionCard(
      {required IconData icon,
      required Color color,
      required String title,
      required String subtitle}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 12),
          Text(title,
              style: GoogleFonts.publicSans(
                  fontWeight: FontWeight.bold, fontSize: 16)),
          Text(subtitle,
              style: GoogleFonts.publicSans(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
