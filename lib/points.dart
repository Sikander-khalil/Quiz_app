import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constant/images.dart';

class PointsScreen extends StatelessWidget {
  final int correctAnswers;
  final int wrongAnswers;
  final int totalAttempts;

  final int totalLikes;

  final List<String> likedQuestions;

  const PointsScreen({super.key,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.totalAttempts, required this.totalLikes, required this.likedQuestions,


  });

  @override
  Widget build(BuildContext context) {
    int totalPoints = correctAnswers * 10;




    return Scaffold(
      appBar: AppBar(
        title: Text('Rewards'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(balloon, width: 400, height: 400,),
              Text(
                'Total Correct Answers: $correctAnswers',
                style: TextStyle(fontSize: 24),
              ),
              Text(
                'Total Wrong Answers: $wrongAnswers',
                style: TextStyle(fontSize: 24),
              ),
              Text(
                'Total Attempts: $totalAttempts',
                style: TextStyle(fontSize: 24),
              ),

              Text(
                'Total Points: $totalPoints',
                style: TextStyle(fontSize: 24),
              ),

              Text(
                'Total likes: $totalLikes',
                style: TextStyle(fontSize: 24),
              ),
              ListView.builder(
                shrinkWrap: true,

                itemCount: likedQuestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      likedQuestions[index], // Display the liked question
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                },
              )



            ],
          ),
        ),
      ),
    );
  }
}
