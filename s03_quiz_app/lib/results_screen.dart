import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:s03_quiz_app/data/questions.dart';
import 'package:s03_quiz_app/qa_textstyle.dart';
import 'package:s03_quiz_app/questions_summary.dart';

class ResultsScreen extends StatelessWidget {
  final List<String> selectedAnswers;
  final void Function() onRestart;

  const ResultsScreen({
    super.key,
    required this.selectedAnswers,
    required this.onRestart,
  });

  List<Map<String, Object>> getSummaryData() {
    final List<Map<String, Object>> summary = [];

    for (int i = 0; i < selectedAnswers.length; i++) {
      summary.add(
        {
          'question_index': i,
          'question': questions[i].text,
          'correct_answer': questions[i].answers[0],
          'user_answer': selectedAnswers[i],
          'is_correct': questions[i].answers[0] == selectedAnswers[i],
        },
      );
    }

    return summary;
  }

  @override
  Widget build(BuildContext context) {
    final summaryData = getSummaryData();
    final numTotalQuestions = questions.length;
    final numCorrectQuestions = summaryData
        .where((d) => d['correct_answer'] == d['user_answer'])
        .length;

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                'You answered $numCorrectQuestions out of $numTotalQuestions questions correctly',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(color: Colors.white),
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 30),
            QuestionsSummary(summaryData: summaryData),
            const SizedBox(height: 20),
            TextButton.icon(
              iconAlignment: IconAlignment.start,
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: onRestart,
              label: Text('Restart Quiz!',
                  style: getQATextStyle(
                    color: Colors.white,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
