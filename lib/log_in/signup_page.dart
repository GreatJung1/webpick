import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'general_signup_page.dart';


class SignUpPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
        title : Text('Webpick',
          style: TextStyle(fontFamily: 'EF_cucumbersalad',
          ),
        ),
        centerTitle: true,
        elevation : 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment : CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children : [
                Text('webpick ',
                  style : TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'EF_cucumbersalad',
                  ),
                ),
                Text(
                  '회원가입',
                  style : TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Pretendard-light',
                  ),
                ),
              ],
            ),
            SizedBox(height : 40),
            ElevatedButton(
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GeneralSignUpPage())
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor : Color(0xFF76ABAE),
                  minimumSize: Size(double.infinity, 50),
                  shape : RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )
              ),
              child: Text('일반 회원가입',
                style : TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height : 10),
            ElevatedButton.icon(
              onPressed: (){
                //구글로 회원가입 로직 추가 예정
              },
              icon: Image.asset('assets/google.png',
                width : 20, height: 20,),
              label: Text(
                '구글로 회원가입',
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor : Colors.white,
                minimumSize: Size(double.infinity, 50),
                side: BorderSide(color : Colors.grey),
                shape: RoundedRectangleBorder(
                  borderRadius : BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}