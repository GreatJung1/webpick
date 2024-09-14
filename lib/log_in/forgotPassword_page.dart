import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;


class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  String? _resultMessage;

  Future<void> _findPasswordByEmail(String email) async {
    final response = await http.post(
      Uri.parse('https://your-api-url.com/find-password'), // 실제 API URL로 변경 필요
      body: {'email': email},
    );

    if (response.statusCode == 200) {
      final result = response.body;
      setState(() {
        _resultMessage = '비밀번호 찾기 이메일이 전송되었습니다.';
      });
    } else {
      setState(() {
        _resultMessage = '서버 오류로 인해 비밀번호 찾기에 실패했습니다.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('비밀번호 찾기'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: '이메일 입력',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final email = _emailController.text;
                if (email.isNotEmpty) {
                  _findPasswordByEmail(email);
                } else {
                  setState(() {
                    _resultMessage = '이메일을 입력해주세요.';
                  });
                }
              },
              child: Text('비밀번호 찾기'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Color(0xFF76ABAE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 16),
            if (_resultMessage != null)
              Text(
                _resultMessage!,
                style: TextStyle(
                  color: _resultMessage!.contains('전송') ? Colors.green : Colors.red,
                  fontSize: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}