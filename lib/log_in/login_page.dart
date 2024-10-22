import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'signup_page.dart';
import 'forgotID_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'forgotPassword_page.dart';
import '../widgets/default_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 상태 관리할 변수들
  String _email = '';
  String _password = '';
  bool _isPasswordVisible = false; // 비밀번호 가리기/보이기
  bool _isRememberMeChecked = false; // 로그인 상태 유지

  Future<void> signInWithEmailPassword() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);
      print('로그인 성공: ${userCredential.user}');

      // Firestore에 사용자 정보 저장
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': _email,
        'createdAt': FieldValue.serverTimestamp(),
        // 필요한 추가 사용자 정보도 여기에 포함 가능
      });

      // 로그인 성공 시 메인 페이지로 이동
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const DefaultWidget()),
            (route) => false,  // 이 부분에서 모든 이전 화면을 제거
      );

    } catch (e) {
      print('로그인 실패: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인에 실패했습니다.')),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      print('구글 로그인 성공: ${userCredential.user}');

      // Firestore에 사용자 정보 저장
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': userCredential.user!.email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 로그인 성공 시 메인 페이지로 이동
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DefaultWidget()),
      );
    } catch (e) {
      print('구글 로그인 실패: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('구글 로그인에 실패했습니다.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // 로고
              Text(
                'webpick',
                style: TextStyle(
                  fontFamily: 'EF_cucumbersalad',
                  fontSize: 40,
                ),
              ),
              SizedBox(height: 40),
              // 아이디 입력 필드
              TextField(
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: '아이디',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),
              // 비밀번호 입력 필드
              TextField(
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
                obscureText: !_isPasswordVisible, // 비밀번호 보이기/가리기
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: '비밀번호',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              // 로그인 상태 유지 & 구글로 로그인 하기
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      Checkbox(
                        value: _isRememberMeChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _isRememberMeChecked = value ?? false;
                          });
                        },
                      ),
                      Text('로그인 상태 유지', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                  TextButton(
                    onPressed: () async {
                      await signInWithGoogle(); // 구글 로그인 함수 호출
                    },
                    child: Row(
                      children: [
                        Image.asset('assets/icons/google.png',
                          width : 30,
                          height : 30,
                        ),
                        SizedBox(width: 5),
                        Text('구글로 로그인 하기', style: TextStyle(color: Colors.black)
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // 로그인 버튼
              ElevatedButton(
                onPressed: () {
                  // 로그인 로직 추가 가능
                  print('로그인 시도: 아이디=$_email, 비밀번호=$_password');
                  signInWithEmailPassword();
                },
                child: Text('로그인', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Color(0xFF76ABAE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // 아이디 찾기, 비밀번호 찾기 및 회원가입 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      // 아이디 찾기 페이지로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotIdPage()),
                      );
                    },
                    child: Text('아이디 찾기', style: TextStyle(color: Colors.grey)),
                  ),
                  Text('|', style: TextStyle(color: Colors.grey)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPasswordPage()), // ForgotPasswordPage는 구현이 필요합니다.
                      );
                    },
                    child: Text('비밀번호 찾기', style: TextStyle(color: Colors.grey)),
                  ),
                  Text('|', style: TextStyle(color: Colors.grey)),
                  TextButton(
                    onPressed: () {
                      // 회원가입 페이지로 이동
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder : (context) => SignUpPage())
                      );
                    },
                    child: Text('회원가입', style: TextStyle(color: Color(0xFF76ABAE))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}