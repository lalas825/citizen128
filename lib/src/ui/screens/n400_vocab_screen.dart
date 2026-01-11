import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class N400VocabScreen extends StatefulWidget {
  const N400VocabScreen({super.key});

  @override
  State<N400VocabScreen> createState() => _N400VocabScreenState();
}

class _N400VocabScreenState extends State<N400VocabScreen> {
  List<dynamic> _cards = [];
  bool _isLoading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final String response = await rootBundle.loadString('assets/n400_vocabulary.json');
      final List<dynamic> data = json.decode(response);
      setState(() {
        _cards = data;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading N400 vocab: $e");
      setState(() => _isLoading = false);
    }
  }

  void _nextCard() {
    if (_currentIndex < _cards.length - 1) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  void _prevCard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_cards.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No vocabulary found.")),
      );
    }

    final cardData = _cards[_currentIndex];
    final String type = cardData['type'] ?? 'term';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
         title: Text("N-400 Vocabulary", 
            style: GoogleFonts.publicSans(color: const Color(0xFF112D50), fontWeight: FontWeight.bold)),
         backgroundColor: Colors.white,
         elevation: 0,
         centerTitle: true,
         leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF112D50)),
            onPressed: () => Navigator.pop(context),
         ),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentIndex + 1) / _cards.length,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00C4B4)),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Card ${_currentIndex + 1} of ${_cards.length}",
              style: GoogleFonts.publicSans(color: Colors.grey.shade600, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: _nextCard, // Tap to advance
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  key: ValueKey(_currentIndex), // Important for animation
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF112D50).withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                    border: Border.all(color: _getBorderColor(type), width: 2),
                  ),
                  child: Center(
                    child: SingleChildScrollView(
                      child: _buildCardContent(cardData, type),
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Controls
          Container(
            padding: const EdgeInsets.all(24),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: _currentIndex > 0 ? _prevCard : null,
                  icon: const Icon(Icons.arrow_back_ios),
                  color: const Color(0xFF112D50),
                  iconSize: 32,
                ),
                 Text(
                  "Tap card to continue", 
                   style: GoogleFonts.publicSans(color: Colors.grey, fontStyle: FontStyle.italic)
                ),
                IconButton(
                  onPressed: _currentIndex < _cards.length - 1 ? _nextCard : null,
                  icon: const Icon(Icons.arrow_forward_ios),
                  color: const Color(0xFF112D50),
                  iconSize: 32,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getBorderColor(String type) {
    switch (type) {
      case 'intro': return const Color(0xFF00C4B4);
      case 'section': return const Color(0xFF112D50);
      default: return Colors.grey.shade100;
    }
  }

  Widget _buildCardContent(Map<String, dynamic> data, String type) {
    if (type == 'intro') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(data['title'],
            style: GoogleFonts.publicSans(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF00C4B4),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(data['content'],
            style: GoogleFonts.publicSans(
              fontSize: 16,
              color: const Color(0xFF112D50),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else if (type == 'section') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(data['title'],
            style: GoogleFonts.publicSans(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF112D50),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(data['content'],
             style: GoogleFonts.publicSans(
              fontSize: 16,
              color: Colors.grey.shade700,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else {
      // Term
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("VOCABULARY",
            style: GoogleFonts.publicSans(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 2.0
            ),
          ),
          const SizedBox(height: 24),
          Text(data['term'],
             style: GoogleFonts.publicSans(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF112D50),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),
           Text(data['definition'],
             style: GoogleFonts.publicSans(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF00C4B4), // Teal for definition
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }
  }
}
