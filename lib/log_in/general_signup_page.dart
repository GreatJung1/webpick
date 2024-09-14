import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class GeneralSignUpPage extends StatefulWidget {
  @override
  _GeneralSignUpPageState createState() => _GeneralSignUpPageState();
}

class _GeneralSignUpPageState extends State<GeneralSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String? _userId;
  String? _password;
  String? _confirmPassword;
  String? _name;
  String? _email;
  String? _phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('일반 회원가입'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // 아이디 입력
              TextFormField(
                decoration: InputDecoration(
                  labelText: '아이디 (6~20자 영문, 숫자)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 6 || value.length > 20) {
                    return '아이디는 6~20자 사이여야 합니다.';
                  }
                  return null;
                },
                onChanged: (value) {
                  _userId = value;
                },
              ),
              SizedBox(height: 16),

              // 비밀번호 입력
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '비밀번호 (8~12자 영문, 숫자, 특수문자)',
                ),
                validator: (value) {
                  if (value == null || value.length < 8 || value.length > 12) {
                    return '비밀번호는 8~12자 사이여야 합니다.';
                  }
                  return null;
                },
                onChanged: (value) {
                  _password = value;
                },
              ),
              SizedBox(height: 16),

              // 비밀번호 확인 입력
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '비밀번호 확인',
                ),
                validator: (value) {
                  if (value != _password) {
                    return '비밀번호가 일치하지 않습니다.';
                  }
                  return null;
                },
                onChanged: (value) {
                  _confirmPassword = value;
                },
              ),
              SizedBox(height: 16),

              // 이름 입력
              TextFormField(
                decoration: InputDecoration(
                  labelText: '이름',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), // 이름 한국어 입력이 안됨 ㅠㅜ
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Zㄱ-ㅎ가-힣]')), // 영어와 한글만 허용
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이름을 입력하세요.';
                  }
                  return null;
                },
                onChanged: (value) {
                  _name = value;
                },
              ),
              SizedBox(height: 16),

              // 이메일 입력
              TextFormField(
                decoration: InputDecoration(
                  labelText: '이메일',
                ),
                validator: (value) {
                  if (value == null || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return '올바른 이메일 형식을 입력하세요.';
                  }
                  return null;
                },
                onChanged: (value) {
                  _email = value;
                },
              ),
              SizedBox(height: 16),

              // 휴대폰 번호 입력
              TextFormField(
                decoration: InputDecoration(
                  labelText: '휴대폰 번호',
                ),
                validator: (value) {
                  if (value == null || value.length < 10) {
                    return '올바른 휴대폰 번호를 입력하세요.';
                  }
                  return null;
                },
                onChanged: (value) {
                  _phoneNumber = value;
                },
              ),
              SizedBox(height: 16),

              // 회원가입 완료 버튼
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // 회원가입 처리 로직 추가
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('회원가입 완료')),
                    );
                  }
                },
                child: Text('가입완료'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Color(0xFF76ABAE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}