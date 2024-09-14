import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'changePassword_page.dart';

class SettingsPage extends StatefulWidget {
  // 사용자 정보 (실제 앱에서는 서버에서 받아오거나 로컬에 저장된 데이터를 사용)
  final String username;
  final String email;

  SettingsPage({required this.username, required this.email});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // 사용자 프로필 사진을 저장하는 변수
  XFile? _profileImage;

  // 이미지를 선택하는 함수
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profileImage = image;
    });
  }

  // 비밀번호 변경 페이지로 이동하는 함수
  void _navigateToChangePassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChangePasswordPage()),
    );
  }

  // 계정 삭제 여부를 묻는 팝업
  Future<void> _showDeleteAccountDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('계정 삭제'),
          content: Text('정말 계정을 삭제하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('삭제'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // 로그아웃 여부를 묻는 팝업
  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('로그아웃'),
          content: Text('정말 로그아웃하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('로그아웃'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'webpick',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Pretendard-Light',
            fontSize: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: _profileImage == null
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add),
                          Text('사진 추가하기'),
                        ],
                      ),
                    )
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.file(
                        File(_profileImage!.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.username, // 사용자 이름 표시
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(widget.username), // 사용자 아이디 표시
                    Text(widget.email), // 사용자 이메일 표시
                  ],
                ),
              ],
            ),
            Divider(height: 40),
            ListTile(
              title: Text('비밀번호 변경'),
              onTap: _navigateToChangePassword,
            ),
            ListTile(
              title: Text('계정 삭제'),
              onTap: _showDeleteAccountDialog,
            ),
            ListTile(
              title: Text(
                '로그아웃',
                style: TextStyle(color: Colors.red),
              ),
              onTap: _showLogoutDialog,
            ),
          ],
        ),
      ),
    );
  }
}

