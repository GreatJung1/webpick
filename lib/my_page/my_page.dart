import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Firebase Auth 추가
import 'favoriteWebtoons_page.dart';
import 'tagWebtoons_page.dart';
import 'settings_page.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String userEmail = user?.email ?? 'Unknown User';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'webpick',
          style: TextStyle(
            fontFamily: 'EF_cucumbersalad',
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),  // 좌우 여백 설정
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[300],
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '닉네임',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      userEmail,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30),  // 여기 위치에 있어야 합니다.
            ListTile(
              title: Text('내가 좋아요 한 웹툰'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoriteWebtoonsPage()),
                );
              },
            ),
            ListTile(
              title: Text('내가 태그한 웹툰'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TagWebtoonsPage()),
                );
              },
            ),
            ListTile(
              title: Text('설정'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(
                      username: '',  // 여기에 적절한 사용자 이름을 전달
                      email: '',  // 여기에 적절한 사용자 이메일을 전달
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}