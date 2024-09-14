import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IndividualWebtoonDetailPage extends StatelessWidget {
  final String webtoonId;

  IndividualWebtoonDetailPage({Key? key, required this.webtoonId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final webtoonCollection = FirebaseFirestore.instance.collection("webtoonDB");

    return Scaffold(
      backgroundColor: Colors.white, // 전체 화면 배경색 설정
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 30.0), // 왼쪽 마진을 설정
          child: Text(
            'webpick',
            style: TextStyle(
              fontFamily: 'Salad',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 70, // AppBar의 높이를 70으로 설정
      ),
      body: Stack(
    children: [
    FutureBuilder<DocumentSnapshot>(
        future: webtoonCollection.doc(webtoonId).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 0.5, // 줄의 두께
                    color: Colors.grey, // 줄의 색상
                    width: double.infinity, // 화면 전체 너비
                  ),
                  Row(
                  children: [
                    Container(
                      width: 150.0, // 원하는 너비
                      height: 180.0, // 원하는 높이
                      //padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 16.0, bottom: 16.0), // 내부 여백
                      margin: EdgeInsets.only(left: 36.0, right: 46.0, top: 32.0, bottom: 32.0), // 외부 여백
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF222831), width: 2.0), // 테두리
                      ),
                      //child: Image.asset('assets/images/your_image.png'),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // 수평 방향으로 정렬
                      children: [
                        Text(
                          data['title'] ?? '제목 없음',
                          style: TextStyle(
                            color: Color(0xFF222831),
                            fontFamily: 'Pretendard',
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10), // 위아래 여백
                        Row(
                          children: [
                            Text(
                              '${data['writer'] ?? '정보 없음'}/', // '정보 없음' 뒤에도 슬래시 추가
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Pretendard',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            //SizedBox(width: 10), // 수평 여백
                            //장르
                            Text(
                              '${data['genre'] ?? '정보 없음'}/',
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Pretendard',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${data['platform'] ?? '정보 없음'}', // '정보 없음' 뒤에도 슬래시 추가
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Pretendard',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8), // 위아래 여백
                        Row(
                          children: [
                            //화수
                            Text(
                              '${data['episode'] ?? '정보 없음'}화/',
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Pretendard',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            //SizedBox(width: 10), // 수평 여백
                            //요일
                            Text(
                              data['end'] ? '완결' : '${data['weekday'] ?? '정보 없음'}요일',
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Pretendard',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 40),
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                          children: [
                            Image.asset(
                              'assets/icons/like.png', // 첫 번째 이미지 파일 경로
                              width: 25, // 이미지 너비
                              //height: 20, // 이미지 높이
                              fit: BoxFit.cover, // 이미지 크기에 맞게 조정
                            ),
                            SizedBox(width: 10), // 이미지 간의 여백
                            Image.asset(
                              'assets/icons/box.png', // 두 번째 이미지 파일 경로
                              width: 24, // 이미지 너비
                              //height: 20, // 이미지 높이
                              fit: BoxFit.cover, // 이미지 크기에 맞게 조정
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                  ),
                  Container(
                    height: 0.5, // 줄의 두께
                    color: Colors.grey, // 줄의 색상
                  ),
                  //태그들
                  Row(
                    children: [

                    ],
                  ),
                  Container(
                    height: 0.5, // 줄의 두께
                    color: Colors.grey, // 줄의 색상
                  ),
                  //작품설명
                  Padding(
                    padding: EdgeInsets.only(left: 26.0, right: 26.0, top: 16.0),
                    child: Text(
                      '블ㄹ라라아아ㅏ아아ㅏㅏㅏㅏㅏㅏㅏkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20.0, // 버튼과 화면 아래쪽 간의 거리 설정
                    left: 20.0, // 버튼과 화면 왼쪽 간의 거리 설정
                    right: 20.0, // 버튼과 화면 오른쪽 간의 거리 설정
                    child: ElevatedButton(
                      onPressed: () {
                        print('버튼 클릭됨');
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        foregroundColor: Color(0xFF76ABAE), // 버튼 텍스트 색상
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // 네모 모양
                          side: BorderSide(
                            color: Color(0xFF76ABAE), // 테두리 색상
                            width: 1.0, // 테두리 두께
                          ),
                        ),
                      ),
                      child: Text(
                        '보러 가기',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          color: Color(0xFF76ABAE),
                          fontSize: 22.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    ]
    ),
    );
  }
}
