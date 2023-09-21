import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/constant/colors.dart';
import 'package:quiz_app/constant/images.dart';
import 'package:quiz_app/constant/textfield.dart';
import 'package:quiz_app/quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {



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
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [blue, darkBlue],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(50),
              //     border: Border.all(color: lightgrey, width: 2),
              //   ),
              //   child: IconButton(
              //       onPressed: () {},
              //       icon: Icon(
              //         CupertinoIcons.xmark,
              //         color: Colors.white,
              //         size: 28,
              //       )),
              // ),
              Image.asset(
                balloon2,
              ),
              SizedBox(
                height: 20,
              ),
              normalText(text: "Welcome to Our", color: lightgrey, size: 18),
              headingText(text: "Quiz", color: lightgrey, size: 32),
              SizedBox(
                height: 20,
              ),
              normalText(
                  color: lightgrey,
                  size: 16,
                  text:
                      "Do you feel confident? How you will face our most difficult questions"),
              const Spacer(),

              InkWell(

                onTap: (){

                  Navigator.push(context, MaterialPageRoute(builder: (context) => QuizScreen()));
                },
                child: Align(
                  alignment: Alignment.center,
                  child: Container(

                    margin: EdgeInsets.only(bottom: 20),
                    alignment: Alignment.center,

                    width: size.width,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),

                    ),
                    child: headingText(color: blue, size: 18, text: "Continue"),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
