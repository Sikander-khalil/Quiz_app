import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LikesCount extends StatelessWidget {
  final int likedCount;
  final int unlikedCount;

  LikesCount(this.likedCount, this.unlikedCount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Likes Count"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Liked Count: $likedCount',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Unliked Count: $unlikedCount',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
