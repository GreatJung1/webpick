import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'select_webtoons_page.dart';
import 'select_tags_page.dart';

// CreatePickaBookPage 클래스 정의 복원
class CreatePickaBookPage extends StatefulWidget {
  @override
  _CreatePickaBookPageState createState() => _CreatePickaBookPageState();
}

class _CreatePickaBookPageState extends State<CreatePickaBookPage> {
  final TextEditingController _titleController = TextEditingController();
  String _coverImage = 'assets/icons/Naver_Line_Webtoon_logo.png'; // 기본 표지 이미지
  bool _isPublic = true; // 기본적으로 공개 설정
  final ImagePicker _picker = ImagePicker();

  // 이미지 선택 함수
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _coverImage = pickedFile.path; // 선택된 이미지 경로 저장
      });
    }
  }

  // 픽카북 생성 함수
  void _onCreatePressed() async {
    String title = _titleController.text;

    if (title.isNotEmpty) {
      try {
        // Firestore에 새로운 PickaBook 생성
        DocumentReference docRef = await FirebaseFirestore.instance.collection('pickabookDB').add({
          'title': title,
          'coverImage': _coverImage, // 선택된 표지 이미지 저장
          'isPublic': _isPublic, // 공개 여부 저장
          'createdAt': DateTime.now(),
          'likes': 0,
          'webtoons': [], // 초기에는 웹툰이 없는 빈 배열로 설정
          'tags': [], // 초기에는 태그가 없는 빈 배열로 설정
        });

        print('PickaBook created with ID: ${docRef.id}');

        // 태그 선택 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectTagsPage(pickaBookId: docRef.id),
          ),
        ).then((_) {
          Navigator.pop(context); // 태그 및 웹툰 선택이 끝나면 홈 화면으로 돌아갑니다.
        });
      } catch (e) {
        print('Error creating PickaBook: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('픽카북 생성 중 오류가 발생했습니다.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('제목을 입력해주세요.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('새로운 픽카북 만들기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 표지 이미지 선택
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 100,
                height: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: _coverImage.startsWith('assets/')
                        ? AssetImage(_coverImage)
                        : FileImage(File(_coverImage)) as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: Colors.black),
                ),
                child: _coverImage.startsWith('assets/')
                    ? null
                    : Icon(Icons.edit, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            // 픽카북 제목 입력 필드
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: '픽카북 제목',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            // 공개 여부 설정 스위치
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('공개 설정'),
                Switch(
                  value: _isPublic,
                  onChanged: (value) {
                    setState(() {
                      _isPublic = value; // 공개/비공개 상태 변경
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            // 픽카북 생성 버튼
            ElevatedButton(
              onPressed: _onCreatePressed,
              child: Text('픽카북 생성'),
            ),
          ],
        ),
      ),
    );
  }
}

class PickaBookListPage extends StatelessWidget { // 기존의 픽카북 목록 페이지
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('픽카북 목록'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('pickabookDB')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('오류가 발생했습니다.'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('픽카북 데이터가 없습니다.'));
          }

          final pickaBooks = snapshot.data!.docs;

          return ListView.builder(
            itemCount: pickaBooks.length,
            itemBuilder: (context, index) {
              final pickaBook = pickaBooks[index];
              final title = pickaBook['title'] ?? '제목 없음';
              final coverImage = pickaBook['coverImage'] ?? 'assets/icons/default_cover.png';

              return ListTile(
                leading: Image.asset(
                  coverImage.startsWith('assets/') ? coverImage : 'assets/icons/default_cover.png',
                  width: 50,
                  height: 50,
                ),
                title: Text(title),
              );
            },
          );
        },
      ),
    );
  }
}
