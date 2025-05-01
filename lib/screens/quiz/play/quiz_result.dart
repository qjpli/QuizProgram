import 'package:flutter/material.dart';

class QuizResultPage extends StatefulWidget {
  final int totalPoints;
  final List<Map<String, dynamic>> results;
  final String nameOfTaker;
  final String avatar;

  const QuizResultPage({
    super.key,
    required this.totalPoints,
    required this.results,
    required this.nameOfTaker,
    required this.avatar,
  });

  @override
  State<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quiz Results")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text("Total Score: ${widget.totalPoints}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ...widget.results.map((r) {
            final selectedChoice = r['choices'].firstWhere((c) => c.id == r['selected']);
            final correctChoice = r['choices'].firstWhere((c) => c.id == r['correctAnswerId']);
            return Card(
              child: ListTile(
                title: Text(r['question']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Your Answer: ${selectedChoice.value}",
                        style: TextStyle(
                            color: r['correct'] ? Colors.green : Colors.red)),
                    if (!r['correct'])
                      Text("Correct Answer: ${correctChoice.value}",
                          style: const TextStyle(color: Colors.green)),
                    Text("Points: ${r['points']}"),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
