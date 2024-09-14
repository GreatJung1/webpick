import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  // 비밀번호를 저장할 TextEditingController
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('비밀번호 변경'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPasswordField('현재 비밀번호', currentPasswordController),
            _buildPasswordField('새 비밀번호', newPasswordController),
            _buildPasswordField('새 비밀번호 확인', confirmPasswordController),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _validatePasswords, // 버튼 클릭 시 비밀번호 검증
              child: Text('비밀번호 변경'),
            ),
          ],
        ),
      ),
    );
  }

  // 비밀번호 입력 필드 위젯을 만드는 함수
  Widget _buildPasswordField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: TextField(
        controller: controller,
        obscureText: true, // 비밀번호가 보이지 않도록 설정
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  // 비밀번호 유효성 검사 함수
  void _validatePasswords() {
    String currentPassword = currentPasswordController.text;
    String newPassword = newPasswordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      _showErrorDialog('새 비밀번호와 확인이 일치하지 않습니다.');
    } else {
      // 실제로 비밀번호 변경 로직을 처리하는 부분
      _showSuccessDialog('비밀번호가 성공적으로 변경되었습니다.');
    }
  }

  // 에러 다이얼로그를 보여주는 함수
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('오류'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  // 성공 다이얼로그를 보여주는 함수
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('성공'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}
