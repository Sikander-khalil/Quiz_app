import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/api_service.dart';
import 'package:quiz_app/constant/images.dart';
import 'package:quiz_app/constant/textfield.dart';
import 'package:quiz_app/points.dart';

import 'constant/colors.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();

  int seconds = 60;
  Timer? timer;
  var currentQuestionIndex = 0;
  late Future quiz;
  int correctAnswers = 0;
  int wrongAnswers = 0;

  var isLoaded = false;
  int totalLikes = 0;
  List<String> likedQuestions = [];
  late List<bool> questionLikes;
  int totalAttempts = 1;
  var optionsList = [];
  List<AnswerOption> answerOptions = [];

  @override
  void initState() {
    super.initState();
    quiz = getQuiz();
    startTimer();
  }

  void stopAudio() {
    audioPlayer.stop();
  }

  @override
  void dispose() {
    timer!.cancel();
    stopAudio();
    super.dispose();
  }

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds > 0) {
          seconds--;
          playAudioFromUrl();
        } else {
          gotoNextQuestion();
        }
      });
    });
  }

  void playAudioFromUrl() {
    String url = 'assets/Clock-Ticking-C-www.fesliyanstudios.com.mp3';

    audioPlayer.open(
      Audio(url),
      autoStart: true,
      showNotification: false,
    );
  }

  resetColors() {
    answerOptions = List<AnswerOption>.generate(
      optionsList.length,
          (index) => AnswerOption(
        icon: null,
        color: Colors.white,
      ),
    );
  }

  gotoNextQuestion() {
    isLoaded = false;
    currentQuestionIndex++;
    resetColors();
    timer!.cancel();
    seconds = 60;
    totalAttempts++;
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
           color: Color(0xff3471b9)
          ),
          child: FutureBuilder(
              future: quiz,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  );
                } else if (snapshot.hasError) {
                  print("Error: ${snapshot.error}");
                  return Center(
                    child: Text("Error loading quiz data"),
                  );
                } else if (snapshot.hasData) {
                  var data = snapshot.data["results"];
                  if (isLoaded == false) {
                    optionsList = data[currentQuestionIndex]["incorrect_answers"];
                    optionsList.add(data[currentQuestionIndex]["correct_answer"]);
                    optionsList.shuffle();
                    questionLikes = List<bool>.filled(data.length, false);
                    answerOptions = List<AnswerOption>.generate(
                      optionsList.length,
                          (index) => AnswerOption(
                        icon: null,
                        color: Colors.white,
                      ),
                    );
                    isLoaded = true;
                  }
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(color: lightgrey, width: 2),
                              ),
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    CupertinoIcons.xmark,
                                    color: Colors.white,
                                    size: 28,
                                  )),
                            ),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                normalText(
                                    color: Colors.white, size: 22, text: "$seconds"),
                                SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: CircularProgressIndicator(
                                    value: seconds / 60,
                                    valueColor: AlwaysStoppedAnimation(Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: lightgrey, width: 2),
                              ),
                              child: TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    questionLikes[currentQuestionIndex] =
                                    !questionLikes[currentQuestionIndex];
                                  });
                                },
                                icon: Icon(
                                  questionLikes[currentQuestionIndex]
                                      ? CupertinoIcons.heart_fill
                                      : CupertinoIcons.heart,
                                  color: questionLikes[currentQuestionIndex]
                                      ? Colors.red
                                      : Colors.white,
                                  size: 18,
                                ),
                                label: normalText(
                                  color: Colors.white,
                                  size: 15,
                                  text: "Like",
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Image.asset(
                          ideas,
                          width: 200,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: normalText(
                                color: Colors.white,
                                size: 18,
                                text: "Question ${currentQuestionIndex + 1} of ${data.length}")),
                        normalText(color: Colors.white, size: 20, text: data[currentQuestionIndex]["question"]),
                        SizedBox(
                          height: 20,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: optionsList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  if (optionsList[index] == data[currentQuestionIndex]["correct_answer"]) {
                                    answerOptions[index] = AnswerOption(
                                      icon: Icon(Icons.check_circle, color: Colors.green, size: 24),
                                      color: Colors.green,
                                    );
                                    correctAnswers++;
                                  } else {
                                    answerOptions[index] = AnswerOption(
                                      icon: Icon(Icons.cancel, color: Colors.red, size: 24),
                                      color: Colors.red,
                                    );
                                    wrongAnswers++;
                                    // Display a message or indicator for the correct answer here
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Incorrect! The correct answer is: ${data[currentQuestionIndex]["correct_answer"]}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }

                                //  correctAnswer = data[currentQuestionIndex]["correct_answer"];
                                 // correctAnswer = optionsList[index];
                                  if (questionLikes[currentQuestionIndex]) {
                                    totalLikes++;
                                  }
                                  if (questionLikes[currentQuestionIndex]) {
                                    likedQuestions.add(data[currentQuestionIndex]["question"]);
                                  } else {
                                    likedQuestions.remove(data[currentQuestionIndex]["question"]);
                                  }
                                  if (currentQuestionIndex < data.length - 1) {
                                    Future.delayed(const Duration(seconds: 1), () {
                                      gotoNextQuestion();
                                    });
                                  } else {
                                    timer!.cancel();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PointsScreen(
                                          correctAnswers: correctAnswers,
                                          wrongAnswers: wrongAnswers,
                                          totalAttempts: totalAttempts,
                                          likedQuestions: likedQuestions,
                                          totalLikes: totalLikes,
                                        ),
                                      ),
                                    );
                                    stopAudio();
                                  }
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                alignment: Alignment.center,
                                width: size.width - 100,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                               //   color: answerOptions[index].color,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: headingText(
                                        color: blue,
                                        size: 18,
                                        text: optionsList[index].toString(),
                                      ),
                                    ),
                                    answerOptions[index].icon ?? SizedBox(width: 24),
                                  ],
                                ),
                              ),
    );
    },
    ),



                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }
}

class AnswerOption {
  final Icon? icon;
  final Color color;

  AnswerOption({required this.icon, required this.color});
}
