import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'likes_count.dart';

class LikeScreen extends StatefulWidget {
  const LikeScreen({super.key});

  @override
  State<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  // Initialize with 10 items and set all to false
  List<bool> likedStatusList = List.generate(10, (index) => false);

  @override
  Widget build(BuildContext context) {

    int likedCount = likedStatusList.where((liked) => liked).length;
    int unlikedCount = likedStatusList.length - likedCount;

    return Scaffold(
      appBar: AppBar(
        title: Text('Like Screen'),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LikesCount(likedCount, unlikedCount),
                ),
              );
            },
            child: Stack(
              children: [
                Icon(Icons.badge, size: 30),
                if (likedCount > 0)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Center(
                        child: Text(
                          '$likedCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Item ${index + 1}'),
            trailing: IconButton(
              icon: Icon(
                likedStatusList[index] ? Icons.favorite : Icons.favorite_border,
                color: likedStatusList[index] ? Colors.red : null,
              ),
              onPressed: () {
                setState(() {
                  likedStatusList[index] = !likedStatusList[index]; // Toggle liked status
                });
              },
            ),
          );
        },
      ),
    );
  }
}
