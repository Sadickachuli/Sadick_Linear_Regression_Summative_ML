import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Performance Predictor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PredictionPage(),
    );
  }
}

class PredictionPage extends StatefulWidget {
  const PredictionPage({super.key});
  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  final TextEditingController hoursController = TextEditingController();
  final TextEditingController scoresController = TextEditingController();
  final TextEditingController activitiesController = TextEditingController();
  final TextEditingController sleepController = TextEditingController();
  final TextEditingController samplePapersController = TextEditingController();
  String? prediction;
  String? error;

  Future<void> getPrediction() async {
    final String hoursStudied = hoursController.text;
    final String previousScores = scoresController.text;
    final String extracurricularActivities = activitiesController.text;
    final String sleepHours = sleepController.text;
    final String sampleQuestionPapersPracticed = samplePapersController.text;

    if (hoursStudied.isEmpty ||
        previousScores.isEmpty ||
        extracurricularActivities.isEmpty ||
        sleepHours.isEmpty ||
        sampleQuestionPapersPracticed.isEmpty) {
      setState(() {
        error = "All fields are required.";
        prediction = null;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://fast-api-1-5td2.onrender.com/predict'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'hours_studied': int.parse(hoursStudied),
          'previous_scores': int.parse(previousScores),
          'extracurricular_activities': extracurricularActivities,
          'sleep_hours': int.parse(sleepHours),
          'sample_question_papers_practiced': int.parse(sampleQuestionPapersPracticed),
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          prediction = json.decode(response.body)['predicted_performance_index'].toString();
          error = null;
        });
      } else {
        setState(() {
          error = "Failed to get prediction.";
          prediction = null;
        });
      }
    } catch (e) {
      setState(() {
        error = "An error occurred.";
        prediction = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:  const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.orange],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextField(
                  controller: hoursController,
                  label: 'Hours Studied',
                  icon: Icons.book,
                ),
                const SizedBox(height: 16.0),
                CustomTextField(
                  controller: scoresController,
                  label: 'Previous Scores',
                  icon: Icons.score,
                ),
                const SizedBox(height: 16.0),
                CustomTextField(
                  controller: activitiesController,
                  label: 'Extracurricular Activities (Yes or No)',
                  icon: Icons.sports,
                ),
                const SizedBox(height: 16.0),
                CustomTextField(
                  controller: sleepController,
                  label: 'Sleep Hours',
                  icon: Icons.bed,
                ),
                const SizedBox(height: 16.0),
                CustomTextField(
                  controller: samplePapersController,
                  label: 'Sample Question Papers Practiced',
                  icon: Icons.description,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: getPrediction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text('Predict', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
                const SizedBox(height: 20),
                if (prediction != null)
                  Text('Predicted Performance Index: $prediction', style: const TextStyle(fontSize: 20, color: Colors.white)),
                if (error != null)
                  Text('Error: $error', style: const TextStyle(color: Colors.red, fontSize: 20)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;

  CustomTextField({
    required this.controller,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white.withOpacity(0.1),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          labelStyle: const TextStyle(color: Colors.white),
        ),
        style: const TextStyle(color: Colors.white),
        keyboardType: label.contains('Hours') || label.contains('Scores') || label.contains('Practiced')
            ? TextInputType.number
            : TextInputType.text,
      ),
    );
  }
}
 